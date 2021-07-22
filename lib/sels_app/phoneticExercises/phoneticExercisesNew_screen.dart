import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:sels_app/sels_app/utils/APIUtil.dart';
import 'package:sels_app/sels_app/utils/SharedPreferencesUtil.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../ui_view/body_measurement.dart';
import '../ui_view/glass_view.dart';
import '../ui_view/mediterranean_diet_view.dart';
import '../ui_view/title_view.dart';
import '../sels_app_theme.dart';
import '../my_diary/meals_list_view.dart';
import '../my_diary/water_view.dart';
import 'package:flutter/material.dart';

class PhoneticExercisesScreen extends StatefulWidget {

  String topicClass = '';
  String topicName = '';

  PhoneticExercisesScreen({String topicClass:'', String topicName:''}) {
    this.topicClass = topicClass;
    this.topicName = topicName;
  }

  @override
  _PhoneticExercisesScreenState createState() => _PhoneticExercisesScreenState(topicClass:topicClass, topicName:topicName);
}

enum TtsState { playing, stopped, paused, continued }

class _PhoneticExercisesScreenState extends State<PhoneticExercisesScreen> {



  String _applicationSettingsDataListenAndSpeakLevel = 'A1';
  String _topicClass = '';
  String _topicName = '';
  String _questionText = '';
  String _questionIPAText = '';
  String _answerText = '';
  String _answerIPAText = 'BB';
  //final ValueNotifier<String> _answerIPAText = ValueNotifier<String>('');
  _PhoneticExercisesScreenState({String topicClass:'', String topicName:''}) {
    this._topicClass = topicClass;
    this._topicName = topicName;
  }
 var _allowTouchButtons = {
   'reListenButton' : false,
   'speakButton' : false,
   'nextButton' : false,
 };
  List<TextSpan> _questionTextWidget = [ TextSpan(text: ' XXX'), ];
  List<TextSpan> _questionIPATextWidget = [ TextSpan(text: ' XXX'), ];
  List<TextSpan> _answerTextWidget = [ TextSpan(text: ' XXX'), ];
  List<TextSpan> _answerIPATextWidget = [ TextSpan(text: ' XXX'), ];
  List<String> _ipaAboutList = ['111', '222'];


  // Speech_to_text
  bool _sttHasSpeech = false;
  double sttLevel = 0.0;
  double sttMinSoundLevel = 50000;
  double sttMaxSoundLevel = -50000;
  String sttLastWords = '';
  String sttLastError = '';
  String sttLastStatus = '';
  String _sttCurrentLocaleId = 'en_US';
  int sttResultListened = 0;
  List<LocaleName> _sttLocaleNames = [];
  final SpeechToText speechToText = SpeechToText();



  // flutter_tts
  late FlutterTts flutterTts;
  String? ttsLanguage;
  String? ttsEngine;
  double ttsVolume = 1;
  double ttsPitch = 1.0;
  double ttsRate = 0.5;
  bool ttsRateSlow = false;
  bool ttsIsCurrentLanguageInstalled = false;
  String? _newVoiceText;
  int? _inputLength;
  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;



  @override
  void initState() {
    initApplicationSettingsData();

    initTts();
    initSpeechState();
    getTestQuestions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    speechToText.stop();
  }

  /*
  initState() 初始化相關
   */

  initApplicationSettingsData() {
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsVolume').then((value) {
      setState(() => ttsVolume = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsPitch').then((value) {
      setState(() => ttsPitch = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsRate').then((value) {
      setState(() => ttsRate = value!);
    });
    SharedPreferencesUtil.getData<String>('applicationSettingsDataListenAndSpeakLevel').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakLevel = value!);
    });
  }

  Future<void> initSpeechState() async {
    var sttHasSpeech = await speechToText.initialize(
        onError: sttErrorListener,
        onStatus: sttStatusListener,
        debugLogging: true,
        finalTimeout: Duration(milliseconds: 0));
    if (sttHasSpeech) {
      _sttLocaleNames = await speechToText.locales();

      var systemLocale = await speechToText.systemLocale();
      //_sttCurrentLocaleId = systemLocale?.localeId ?? '';
    }

    if (!mounted) return;

    setState(() {
      _sttHasSpeech = sttHasSpeech;
    });
  }

  initTts() async {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    if (Platform.isIOS) {
      await flutterTts
          .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
      ]);
    }


    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //title: Text('[' + _applicationSettingsDataListenAndSpeakLevel + ']級別 (' + _topicClass + ': ' + _topicName + ')' ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
        child: Container(
          decoration: BoxDecoration(
            color: FitnessAppTheme.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: FitnessAppTheme.grey.withOpacity(0.2), offset: Offset(1.1, 1.1), blurRadius: 10.0),
            ],
          ),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, bottom: 8, top: 16),
                        child: Text(
                          'Repeat after me:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              letterSpacing: -0.1,
                              color: FitnessAppTheme.darkText),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                                children: _questionTextWidget,
                              ),
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                                children: _questionIPATextWidget,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 4, bottom: 8, top: 16),
                        child: Text(
                          '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              letterSpacing: -0.1,
                              color: FitnessAppTheme.darkText),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                                children: _answerTextWidget,
                              ),
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                                children: _answerIPATextWidget,
                              ),
                            ),
                            /*
                              child: Text(
                                _answerIPAText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                               */
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 8),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.background,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Column(
                            children: [
                              Center(
                                child: IconButton(
                                  //icon: const Icon(Icons.volume_up_outlined),
                                  icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                  color: Colors.black,
                                  onPressed: () async {
                                    if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                      ttsRateSlow = !ttsRateSlow;
                                      await _ttsSpeak(_questionText, 'en-US');
                                    }
                                  },
                                ),
                              ),
                              Text(
                                'Re-Listen',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Center(
                                child: IconButton(
                                  icon: Icon( (_allowTouchButtons['speakButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.mic : Icons.mic_none) : Icons.mic_off_outlined ),
                                  color: Colors.black,
                                  onPressed: () {
                                    if(_allowTouchButtons['speakButton']! && !isPlaying ){
                                      if( !_sttHasSpeech || speechToText.isListening ){
                                        sttStopListening();
                                      } else {
                                        sttStartListening();
                                      }
                                    }},
                                ),
                              ),
                              Text(
                                'Speak',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Center(
                                child: IconButton(
                                  icon: const Icon(Icons.navigate_next_outlined),
                                  color: Colors.black,
                                  onPressed: () {
                                    if(_allowTouchButtons['nextButton']!){
                                      _ttsStop();
                                      sttStopListening();
                                      getTestQuestions();
                                    }
                                  },
                                ),
                              ),Text(
                                'Next',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 8),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: FitnessAppTheme.background,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                ),

                Padding(
                padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 8),
                  child:
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ListView.separated(
                      itemCount: _ipaAboutList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: '${_ipaAboutList[index]}',
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: FitnessAppTheme.nearlyDarkBlue,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () async {
                                ttsRateSlow = !ttsRateSlow;
                                await _ttsSpeak(_ipaAboutList[index], 'en-US');
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index){
                        return Divider(
                          thickness: 2,
                        );
                      },
                    )
                    
                    
                    
                    
                    /*
                    ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      children: const <Widget>[
                        Text("I'm dedicating every day to you"),
                        Text('Domestic life was never quite my style'),
                        Text('When you smile, you knock me out, I fall apart'),
                        Text('And I thought I was so smart'),
                      ],
                    ),*/
                    
                    
                    
                  )
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }




  /*
  speech_to_text
   */
  Future<void> sttStartListening() async {
    sttLastWords = '';
    sttLastError = '';
    speechToText.listen(
        onResult: sttResultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: _sttCurrentLocaleId,
        onSoundLevelChange: sttSoundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  Future<void> sttStopListening() async {
    speechToText.stop();
    setState(() {
      sttLevel = 0.0;
    });
  }

  Future<void> sttCancelListening() async {
    await speechToText.cancel();
    setState(() {
      sttLevel = 0.0;
    });
    //sleep(Duration(seconds:1));
    //await sttStopListening();
    //await sttStartListening();
  }

  void sttResultListener(SpeechRecognitionResult result) {
    ++sttResultListened;
    print('Result listener $sttResultListened');
    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
      print(sttLastWords);
      _handleSubmitted(result.recognizedWords, isFinalResult:result.finalResult);
    });
  }

  void sttSoundLevelListener(double level) {
    sttMinSoundLevel = min(sttMinSoundLevel, level);
    sttMaxSoundLevel = max(sttMaxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.sttLevel = level;
    });
  }

  Future<void> sttErrorListener(SpeechRecognitionError error) async {
    await sttCancelListening();
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      sttLastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void sttStatusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      sttLastStatus = '$status';
    });
  }

  void _sttSwitchLang(selectedVal) {
    setState(() {
      _sttCurrentLocaleId = selectedVal;
    });
    print(selectedVal);
  }



  /* tts 相關 */
  Future<dynamic> _getLanguages() => flutterTts.getLanguages;

  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }
  Future _ttsSpeak(String speakMessage, String speakLanguage) async {

    setState(() {
      _allowTouchButtons['speakButton'] = false;
    });
    await sttStopListening();

    await flutterTts.setLanguage(speakLanguage);
    if(ttsRateSlow){
      await flutterTts.setSpeechRate(ttsRate * 0.22);
    } else {
      await flutterTts.setSpeechRate(ttsRate);
    }
    await flutterTts.setVolume(ttsVolume);
    await flutterTts.setPitch(ttsPitch);

    if (speakMessage != null) {
      if (speakMessage.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(speakMessage);
      }
    }
    setState(() {
      _allowTouchButtons['speakButton'] = true;
    });
  }

  Future _ttsStop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _ttsPause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }



  /*
  other
   */

  void _handleSubmitted(String text, {bool isFinalResult:false}) {
    setState(() {
      _answerText = text;
      _answerTextWidget = [ TextSpan(text: _answerText), ];
      _answerIPATextWidget = [ TextSpan(text: ''), ];
    });
    if(isFinalResult){
      _responseChatBot(text);
    }
  }

  void _responseChatBot(text) async {
    String checkSentencesJSON = await APIUtil.checkSentences(_questionText, text, sentenceLevel:_applicationSettingsDataListenAndSpeakLevel);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());

    setState(() {
      _answerTextWidget = [ TextSpan(text: 'Please wait......'), ];
    });

    //print(checkSentencesJSON.toString());
    if(checkSentences['apiStatus'] == 'success'){

      var questionTextArray = checkSentences['data']['questionText'].split(' ');
      List<TextSpan> questionTextWidget = [];
      for (var i = 0; i < questionTextArray.length; i++) {
        if(checkSentences['data']['questionError']['word'].contains(questionTextArray[i])){
          questionTextWidget.add(
              TextSpan(
                text: questionTextArray[i]+' ',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  ttsRateSlow = !ttsRateSlow;
                  await _ttsSpeak(questionTextArray[i], 'en-US');
                },
              )
          );
        } else {
          questionTextWidget.add(TextSpan(text: questionTextArray[i]+' ', style: TextStyle()));
        }
      }

      var questionIPATextArray = checkSentences['data']['questionIPAText'].split(' ');
      List<TextSpan> questionIPATextWidget = [];
      for (var i = 0; i < questionIPATextArray.length; i++) {
        if(checkSentences['data']['questionError']['ipa'].contains(questionIPATextArray[i])){
          questionIPATextWidget.add(
              TextSpan(
                  text: questionIPATextArray[i]+' ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red ),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    ttsRateSlow = !ttsRateSlow;
                    await _ttsSpeak(questionTextArray[i], 'en-US');
                  },
              )
          );
        } else {
          questionIPATextWidget.add(TextSpan(text: questionIPATextArray[i]+' ', style: TextStyle()));
        }
      }

      var answerTextArray = checkSentences['data']['answerText'].split(' ');
      List<TextSpan> answerTextWidget = [];
      for (var i = 0; i < answerTextArray.length; i++) {
        if(checkSentences['data']['answerError']['word'].contains(answerTextArray[i])){
          answerTextWidget.add(
              TextSpan(
                text: answerTextArray[i]+' ',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  ttsRateSlow = !ttsRateSlow;
                  await _ttsSpeak(answerTextArray[i], 'en-US');
                },
              )
          );
        } else {
          answerTextWidget.add(TextSpan(text: answerTextArray[i]+' ', style: TextStyle()));
        }
      }

      var answerIPATextArray = checkSentences['data']['answerIPAText'].split(' ');
      List<TextSpan> answerIPATextWidget = [];
      for (var i = 0; i < answerIPATextArray.length; i++) {
        if(checkSentences['data']['answerError']['ipa'].contains(answerIPATextArray[i])){
          answerIPATextWidget.add(
              TextSpan(
                text: answerIPATextArray[i]+' ',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  ttsRateSlow = !ttsRateSlow;
                  await _ttsSpeak(answerTextArray[i], 'en-US');
                },
              )
          );
        } else {
          answerIPATextWidget.add(TextSpan(text: answerIPATextArray[i]+' ', style: TextStyle()));
        }
      }

      List<String> ipaAboutList = [];
      for (var i = 0; i < checkSentences['data']['questionError']['ipaAbout'].length; i++) {
        checkSentences['data']['questionError']['ipaAbout'][i].forEach((k,v) {
          if(v != 'not found word'){

            String text = '${k}: [ ';
            for (var i = 0; i < v.length; i++) {
              if(i == (v.length - 1)){
                text = text + v[i] + ' ]';
              }else{
                text = text + v[i] + ', ';
              }
            }
            ipaAboutList.add(text);
          }
        });
      }
      for (var i = 0; i < checkSentences['data']['answerError']['ipaAbout'].length; i++) {
        checkSentences['data']['answerError']['ipaAbout'][i].forEach((k,v) {
          if(v != 'not found word'){

            String text = '${k}: [ ';
            for (var i = 0; i < v.length; i++) {
              if(i == (v.length - 1)){
                text = text + v[i] + ' ]';
              }else{
                text = text + v[i] + ', ';
              }
            }
            ipaAboutList.add(text);
          }
        });
      }

      setState(() {
        _questionTextWidget = questionTextWidget;
        _questionIPATextWidget = questionIPATextWidget;
        _answerTextWidget = answerTextWidget;
        _answerIPATextWidget = answerIPATextWidget;
        _ipaAboutList = ipaAboutList;
        ttsRateSlow = false;
      });

      await _ttsSpeak(checkSentences['data']['replyText'], 'en-US');

      setState(() {
        _allowTouchButtons['speakButton'] = false;
      });

    } else {
      print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      sleep(Duration(seconds:1));
      _responseChatBot(text);
    }
  }







  Future<void> getTestQuestions({String questionText : '', String questionIPAText : '', String aboutWord:''}) async {
    if(questionText == ''){
      setState(() {
        _questionText = 'Please wait......';
        _questionIPAText = '';
        _questionTextWidget = [];
        _questionTextWidget = [ TextSpan(text: _questionText), ];
        _questionIPATextWidget = [];
        _answerText = '';
        _answerIPAText = '';
        _answerTextWidget = [];
        _answerIPATextWidget = [];
        _ipaAboutList = [];
        _allowTouchButtons['reListenButton'] = false;
        _allowTouchButtons['speakButton'] = false;
        _allowTouchButtons['nextButton'] = false;
      });

      String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, sentenceTopic :_topicName, sentenceClass:_topicClass, aboutWord:aboutWord, sentenceLengthLimit:'5', dataLimit:'1');
      var getSentences = jsonDecode(getSentencesJSON.toString());

      if(getSentences['apiStatus'] == 'success'){
        final _random = new Random();
        String sentenceContent = getSentences['data'][_random.nextInt(getSentences['data'].length)]['sentenceContent'];
        String sentenceIPA = getSentences['data'][_random.nextInt(getSentences['data'].length)]['sentenceIPA'];
        getTestQuestions(questionText:sentenceContent, questionIPAText:sentenceIPA);

        setState(() {
          //_allowTouchButtons['nextButton'] = true;
        });
      } else {
        print('sendTestQuestions Error apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        sleep(Duration(seconds:1));
        getTestQuestions();
      }
    }else{

      setState(() {
        _questionText = questionText;
        _questionTextWidget = [ TextSpan(text: _questionText), ];
        _questionIPAText = questionIPAText;
        _questionIPATextWidget = [ TextSpan(text: _questionIPAText), ];
        ttsRateSlow = false;
        _allowTouchButtons['reListenButton'] = true;
        _allowTouchButtons['speakButton'] = true;
        _allowTouchButtons['nextButton'] = true;
      });
      await _ttsSpeak('Repeat after me', 'en-US');
      await _ttsSpeak(questionText, 'en-US');

      await sttStartListening();
    }
  }














}
