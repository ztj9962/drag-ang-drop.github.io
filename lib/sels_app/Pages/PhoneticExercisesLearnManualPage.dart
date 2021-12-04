import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:sels_app/sels_app/utils/APIUtil.dart';
import 'package:sels_app/sels_app/utils/SharedPreferencesUtil.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter/material.dart';

class PhoneticExercisesLearnManualPage extends StatefulWidget {

  String topicClass = '';
  String topicName = '';

  PhoneticExercisesLearnManualPage({String topicClass:'', String topicName:''}) {
    this.topicClass = topicClass;
    this.topicName = topicName;
  }

  @override
  _PhoneticExercisesLearnManualPageState createState() => _PhoneticExercisesLearnManualPageState(topicClass:topicClass, topicName:topicName);
}

enum TtsState { playing, stopped, paused, continued }

class _PhoneticExercisesLearnManualPageState extends State<PhoneticExercisesLearnManualPage> {



  String _applicationSettingsDataListenAndSpeakLevel = 'A1';
  double _applicationSettingsDataListenAndSpeakRanking = 300;
  bool _applicationSettingsPhoneticExercisesLearnManualPageIntroduce = true;
  String _topicClass = '';
  String _topicName = '';


  //final ValueNotifier<String> _answerIPAText = ValueNotifier<String>('');
  _PhoneticExercisesLearnManualPageState({String topicClass:'', String topicName:''}) {
    this._topicClass = topicClass;
    this._topicName = topicName;
  }
 var _allowTouchButtons = {
   'reListenButton' : false,
   'speakButton' : false,
   'nextButton' : false,
 };
  String _questionText = '';
  String _questionIPAText = '';
  String _questionChineseText = '';
  String _replyText = '';
  String _answerText = '';
  String _answerIPAText = '';
  List<TextSpan> _questionTextWidget = [ TextSpan(text: ''), ];
  List<TextSpan> _questionIPATextWidget = [ TextSpan(text: ''), ];
  List<TextSpan> _questionChineseWidget = [ TextSpan(text: ''), ];
  List<TextSpan> _replyTextWidget = [ TextSpan(text: ''), ];
  List<TextSpan> _answerTextWidget = [ TextSpan(text: ''), ];
  List<TextSpan> _answerIPATextWidget = [ TextSpan(text: ''), ];
  List<String> _ipaAboutList = ['111', '222'];
  bool _viewIPAAboutList = false;
  int _correctCombo = 0;


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

    //getTestQuestions();


    SharedPreferencesUtil.getData<bool>('applicationSettingsPhoneticExercisesLearnManualPageIntroduce').then((value) {
      if(!value!){
        getTestQuestions();
      }
    });
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
    SharedPreferencesUtil.getData<double>('applicationSettingsDataListenAndSpeakRanking').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakRanking = value!);
    });

    SharedPreferencesUtil.getData<bool>('applicationSettingsPhoneticExercisesLearnManualPageIntroduce').then((value) {
      setState(() => _applicationSettingsPhoneticExercisesLearnManualPageIntroduce = value!);
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
        title: Text('(手動)[' + _applicationSettingsDataListenAndSpeakLevel + '] (' + _topicClass + ': ' + _topicName + ')' ),
      ),
      body: Stack(
          children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(0.0),
                      elevation: 2.0,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(padding: const EdgeInsets.only(bottom: 8, top: 8)),
                                        RichText(
                                          text: TextSpan(
                                            text: '',
                                            style: TextStyle(
                                              fontSize: 24 ,
                                              color: Colors.black,
                                            ),
                                            children: _replyTextWidget,
                                          ),
                                        ),
                                        Padding(padding: const EdgeInsets.only(bottom: 8, top: 8)),
                                        Column(
                                          children: <Widget>[
                                            Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xFF2633C5),
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
                                                    fontSize: 16,
                                                    color: Color(0xFF2633C5),
                                                  ),
                                                  children: _questionIPATextWidget,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFF2633C5),
                                                  ),
                                                  children: _questionChineseWidget,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8, top: 8),
                                          child: Divider(
                                            height: 1,
                                            thickness: 1,
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
                                                    fontSize: 20,
                                                    color: Color(0xFF2633C5),
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
                                                    fontSize: 16,
                                                    color: Color(0xFF2633C5),
                                                  ),
                                                  children: _answerIPATextWidget,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 8),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: AvatarGlow(
                                              animate: isPlaying,
                                              glowColor: Theme.of(context).primaryColor,
                                              endRadius: 30.0,
                                              duration: Duration(milliseconds: 2000),
                                              repeat: true,
                                              showTwoGlows: true,
                                              repeatPauseDuration: Duration(milliseconds: 100),
                                              child: Material(     // Replace this child with your own
                                                elevation: 8.0,
                                                shape: CircleBorder(),
                                                child: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  radius: 20.0,
                                                  child: IconButton(
                                                    icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                    color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                    onPressed: () async {
                                                      if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                        ttsRateSlow = !ttsRateSlow;
                                                        await _ttsSpeak(_questionText, 'en-US');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '再聽一次',
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
                                            child: AvatarGlow(
                                              animate: speechToText.isListening,
                                              glowColor: Theme.of(context).primaryColor,
                                              endRadius: 30.0,
                                              duration: Duration(milliseconds: 2000),
                                              repeat: true,
                                              showTwoGlows: true,
                                              repeatPauseDuration: Duration(milliseconds: 100),
                                              child: Material(     // Replace this child with your own
                                                elevation: 8.0,
                                                shape: CircleBorder(),
                                                child: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  radius: 20.0,
                                                  child: IconButton(
                                                    icon: Icon( (_allowTouchButtons['speakButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.mic : Icons.mic_none) : Icons.mic_off_outlined ),
                                                    color: (_allowTouchButtons['speakButton']! && !isPlaying ) ? Colors.white : Colors.grey ,
                                                    onPressed: () {
                                                      if(_allowTouchButtons['speakButton']! && !isPlaying ){
                                                        if( !_sttHasSpeech || speechToText.isListening ){
                                                          sttStopListening();
                                                        } else {
                                                          sttStartListening();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            (speechToText.isListening)? '暫停回答' : '回答' ,
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
                                            child: AvatarGlow(
                                              animate: false,
                                              glowColor: Theme.of(context).primaryColor,
                                              endRadius: 30.0,
                                              duration: Duration(milliseconds: 2000),
                                              repeat: true,
                                              showTwoGlows: true,
                                              repeatPauseDuration: Duration(milliseconds: 100),
                                              child: Material(     // Replace this child with your own
                                                elevation: 8.0,
                                                shape: CircleBorder(),
                                                child: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  radius: 20.0,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.navigate_next_outlined),
                                                    color: (_allowTouchButtons['nextButton']! ) ? Colors.white : Colors.grey ,
                                                    onPressed: () {
                                                      if(_allowTouchButtons['nextButton']!){
                                                        _ttsStop();
                                                        sttStopListening();
                                                        getTestQuestions();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '下一題',
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

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _viewIPAAboutList,
                  child: Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(0.0),
                        elevation: 2.0,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                              child: Text('在這裡聽看看類似的發音吧！'),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                              child: ListView.separated(
                                itemCount: _ipaAboutList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.hearing_outlined),
                                    title: RichText(
                                      text: TextSpan(
                                        text: '${_ipaAboutList[index]}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      ttsRateSlow = true;
                                      await _ttsSpeak(_ipaAboutList[index], 'en-US');
                                      ttsRateSlow = !ttsRateSlow;
                                      await _ttsSpeak(_ipaAboutList[index], 'en-US');
                                    },

                                  );
                                },
                                separatorBuilder: (context, index){
                                  return Divider(
                                    height: 1,
                                    thickness: 1,

                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
            Visibility(
              visible: _applicationSettingsPhoneticExercisesLearnManualPageIntroduce,
              child: Stack(
                  children: <Widget>[
                    Dismissible(
                        key: ValueKey('PhoneticExercisesLearnManualPage_Introduce_01'),
                        onDismissed: (DismissDirection direction){
                          setState(() => _applicationSettingsPhoneticExercisesLearnManualPageIntroduce = false);
                          getTestQuestions();
                          SharedPreferencesUtil.saveData<bool>('applicationSettingsPhoneticExercisesLearnManualPageIntroduce', _applicationSettingsPhoneticExercisesLearnManualPageIntroduce);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('讓我們開始吧！'),
                          ));
                        },
                        child: ConstrainedBox(
                          child: Image.asset(
                            'assets/sels_app/PhoneticExercisesLearnManualPage/PhoneticExercisesLearnManualPage_Introduce_01.png',
                            fit: BoxFit.fill,
                          ),
                          constraints: new BoxConstraints.expand(),
                        )
                    ),
                  ]
              ),
            ),

          ]
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
    setState(() {
      _replyText = '請稍候......';
      _replyTextWidget = [ TextSpan(text: _replyText), ];
      _allowTouchButtons['reListenButton'] = false;
      _allowTouchButtons['speakButton'] = false;
      _allowTouchButtons['nextButton'] = false;
    });

    String checkSentencesJSON = await APIUtil.checkSentences(_questionText, text, correctCombo:_correctCombo);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());


    //print(checkSentences['data']['questionError'].toString());
    if(checkSentences['apiStatus'] == 'success'){

      if(checkSentences['data']['ipaTextSimilarity'] == 100){
        _correctCombo++;
      } else {
        _correctCombo = 0;
      }

      var questionTextArray = checkSentences['data']['questionText'].split(' ');
      List<TextSpan> questionTextWidget = [];

      var questionIPATextArray = checkSentences['data']['questionIPAText'].split(' ');
      List<TextSpan> questionIPATextWidget = [];

      questionIPATextWidget.add(TextSpan(text: '['));
      for (var i = 0; i < questionTextArray.length; i++) {
        if(checkSentences['data']['questionError'].containsKey(questionTextArray[i])){
          questionTextWidget.add(
              TextSpan(
                text: questionTextArray[i] + ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  ttsRateSlow = !ttsRateSlow;
                  await _ttsSpeak(questionTextArray[i], 'en-US');},
              )
          );
          questionIPATextWidget.add(
              TextSpan(
                text: questionIPATextArray[i] + ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  ttsRateSlow = !ttsRateSlow;
                  await _ttsSpeak(questionTextArray[i], 'en-US');
                  },
              )
          );
        } else {
          questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' '));
          questionIPATextWidget.add(TextSpan(text: questionIPATextArray[i] + ' '));
        }
      }
      questionIPATextWidget.add(TextSpan(text: ']'));



      var answerTextArray = checkSentences['data']['answerText'].split(' ');
      List<TextSpan> answerTextWidget = [];

      var answerIPATextArray = checkSentences['data']['answerIPAText'].split(' ');
      List<TextSpan> answerIPATextWidget = [];

      answerIPATextWidget.add(TextSpan(text: '['));
      for (var i = 0; i < answerTextArray.length; i++) {
        if(checkSentences['data']['answerError'].containsKey(answerTextArray[i])){
          answerTextWidget.add(
              TextSpan(
                text: answerTextArray[i] + ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  ttsRateSlow = !ttsRateSlow;
                  await _ttsSpeak(answerTextArray[i], 'en-US');},
              )
          );
          answerIPATextWidget.add(
              TextSpan(
                text: answerIPATextArray[i] + ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                recognizer: TapGestureRecognizer()..onTap = () async {
                  ttsRateSlow = !ttsRateSlow;
                  await _ttsSpeak(answerTextArray[i], 'en-US');
                },
              )
          );
        } else {
          answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' '));
          answerIPATextWidget.add(TextSpan(text: answerIPATextArray[i] + ' '));
        }
      }
      answerIPATextWidget.add(TextSpan(text: ']'));

      List<TextSpan> replyTextWidget = [];
      replyTextWidget.add(TextSpan(text: checkSentences['data']['scoreComment']['text'] + ' '));
      replyTextWidget.add(TextSpan(text: ' '));
      replyTextWidget.add(TextSpan(text: checkSentences['data']['scoreComment']['emoji'] ));
//
      List<String> ipaAboutList = [];

      checkSentences['data']['questionError'].forEach((key, value) {
        String text = '';
        value['ipaAbout'].forEach((key, value) {
          text = text + value['word'] + ' ';
        });
        text = value['word'] + ': [ ' + text.trim().replaceAll(' ',', ') + ' ]';
        ipaAboutList.add(text);
      });
      checkSentences['data']['answerError'].forEach((key, value) {
        String text = '';
        value['ipaAbout'].forEach((key, value) {
          text = text + value['word'] + ' ';
        });
        text = value['word'] + ': [ ' + text.trim().replaceAll(' ',', ') + ' ]';
        ipaAboutList.add(text);
      });

      setState(() {
        _questionTextWidget = questionTextWidget;
        _questionIPATextWidget = questionIPATextWidget;
        _replyTextWidget = replyTextWidget;
        _answerTextWidget = answerTextWidget;
        _answerIPATextWidget = answerIPATextWidget;
        _ipaAboutList = ipaAboutList;
        _viewIPAAboutList = (ipaAboutList.length > 0);
        ttsRateSlow = false;
        _allowTouchButtons['reListenButton'] = true;
        _allowTouchButtons['speakButton'] = true;
        _allowTouchButtons['nextButton'] = true;
      });
//
      await _ttsSpeak(checkSentences['data']['scoreComment']['text'] , 'en-US');
//
      setState(() {
        _allowTouchButtons['speakButton'] = false;
      });
    } else {
      print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      sleep(Duration(seconds:1));
      _responseChatBot(text);
    }

  }





  Future<void> getTestQuestions({String questionText : '', String questionIPAText : '', String questionChineseText : '', String aboutWord:''}) async {

    if(questionText == ''){
      setState(() {
        _replyText = '請稍候......';
        _replyTextWidget = [ TextSpan(text: _replyText), ];
        _questionText = '';
        _questionIPAText = '';
        _questionChineseText = '';
        _questionTextWidget = [];
        _questionIPATextWidget = [];
        _questionChineseWidget = [];
        _answerText = '';
        _answerIPAText = '';
        _answerTextWidget = [];
        _answerIPATextWidget = [];
        _ipaAboutList = [];
        _viewIPAAboutList = false;
        _allowTouchButtons['reListenButton'] = false;
        _allowTouchButtons['speakButton'] = false;
        _allowTouchButtons['nextButton'] = false;
      });

      String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, sentenceTopic :_topicName, sentenceClass:_topicClass, aboutWord:aboutWord, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString(), dataLimit:'1');
      var getSentences = jsonDecode(getSentencesJSON.toString());

      if(getSentences['apiStatus'] == 'success'){
        final _random = new Random();
        String sentenceContent = getSentences['data'][_random.nextInt(getSentences['data'].length)]['sentenceContent'];
        String sentenceIPA = getSentences['data'][_random.nextInt(getSentences['data'].length)]['sentenceIPA'];
        String sentenceChinese = getSentences['data'][_random.nextInt(getSentences['data'].length)]['sentenceChinese'];
        getTestQuestions(questionText: sentenceContent, questionIPAText: sentenceIPA, questionChineseText: sentenceChinese);

        setState(() {
          //_allowTouchButtons['nextButton'] = true;
        });
      } else {
        print('sendTestQuestions Error apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        sleep(Duration(seconds:1));
        getTestQuestions();
      }
      return;
    }

    setState(() {
      _replyText = 'Repeat after me: ';
      _replyTextWidget = [ TextSpan(text: _replyText), ];
      _questionText = questionText;
      _questionTextWidget = [ TextSpan(text: _questionText), ];
      _questionIPAText = questionIPAText;
      _questionIPATextWidget = [ TextSpan(text: '[' + _questionIPAText + ']'), ];
      _questionChineseText = questionChineseText;
      _questionChineseWidget = [ TextSpan(text: _questionChineseText), ];
      ttsRateSlow = false;
      _allowTouchButtons['reListenButton'] = true;
      _allowTouchButtons['speakButton'] = true;
      _allowTouchButtons['nextButton'] = true;
    });
    await _ttsSpeak('Repeat after me', 'en-US');
    await _ttsSpeak(questionText, 'en-US');

    await sttStartListening();
    return;

  }














}
