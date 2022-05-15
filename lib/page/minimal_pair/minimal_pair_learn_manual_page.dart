import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:io';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_tts/flutter_tts.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MinimalPairLearnManualPage extends StatefulWidget {

  final String IPA1;
  final String IPA2;
  final String word;
  const MinimalPairLearnManualPage ({ Key? key, this.IPA1 = '', this.IPA2 = '', this.word = '' }): super(key: key);

  @override
  _MinimalPairLearnManualPageState createState() => _MinimalPairLearnManualPageState();
}

enum TtsState { playing, stopped, paused, continued }

class _MinimalPairLearnManualPageState extends State<MinimalPairLearnManualPage> {
  String _IPA1 = '';
  String _IPA2 = '';
  String _word = '';

  final _allowTouchButtons = {
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
  List<TextSpan> _questionTextWidget = [ const TextSpan(text: 'is my time to go to school to wo dow sorhb sonw'), ];
  List<TextSpan> _questionIPATextWidget = [ const TextSpan(text: '[IPA]'), ];
  List<TextSpan> _questionChineseWidget = [ const TextSpan(text: 'Ch'), ];
  List<TextSpan> _replyTextWidget = [ const TextSpan(text: '_replyTextWidget'), ];
  List<TextSpan> _answerTextWidget = [ const TextSpan(text: "_answerTextWidget"), ];
  List<TextSpan> _answerIPATextWidget = [ const TextSpan(text: '_answerIPATextWidget'), ];
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
    _IPA1 = widget.IPA1;
    _IPA2 = widget.IPA2;
    _word = widget.word;
    super.initState();
    initMinimalPairLearnManualPage();
  }

  @override
  void dispose() {
    super.dispose();

    flutterTts.stop();
    speechToText.stop();
  }

  initMinimalPairLearnManualPage() async {
    await initTts();
    await initSpeechState();
    getTestQuestions();
  }

  Future<void> initSpeechState() async {
    var sttHasSpeech = await speechToText.initialize(
        onError: sttErrorListener,
        onStatus: sttStatusListener,
        debugLogging: true,
        finalTimeout: const Duration(milliseconds: 0));
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

    if (isIOS) {
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
          backgroundColor: PageTheme.app_theme_black,
          title: Text('(手動)(' ),
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                    padding: const EdgeInsets.all(0),
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: RichText(
                                  text: TextSpan(
                                    text: '',
                                    style: const TextStyle(
                                      fontSize: 20 ,
                                      color: PageTheme.app_theme_blue,
                                    ),
                                    children: _replyTextWidget,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: const TextStyle(
                                        fontSize: 24 ,
                                        color: Colors.black,
                                      ),
                                      children: _questionTextWidget,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: const TextStyle(
                                        fontSize: 18 ,
                                        color: Colors.black,
                                      ),
                                      children: _questionChineseWidget,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: const TextStyle(
                                        fontSize: 18 ,
                                        color: Colors.black,
                                      ),
                                      children: _questionIPATextWidget,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                height: 100,
                                //color: Colors.blue,
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: CircleAvatar(
                                              backgroundColor: PageTheme.app_theme_blue,
                                              radius: 25.0,
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
                                          const AutoSizeText(
                                            '再聽一次',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: CircleAvatar(
                                              backgroundColor: PageTheme.app_theme_blue,
                                              radius: 25.0,
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
                                          const AutoSizeText(
                                            '下一題',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: PageTheme.app_theme_blue,
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: const TextStyle(
                                        fontSize: 24 ,
                                        color: Colors.black,
                                      ),
                                      children: _answerTextWidget,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: const TextStyle(
                                        fontSize: 18 ,
                                        color: Colors.black,
                                      ),
                                      children: _answerIPATextWidget,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _viewIPAAboutList,
                                child: Column(
                                  children: <Widget>[
                                    const Divider(
                                      thickness: 1,
                                      color: PageTheme.app_theme_blue,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child:  Card(
                                        color: Colors.white,
                                        margin: EdgeInsets.all(0.0),
                                        elevation: 2.0,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                              child: AutoSizeText(
                                                '在這裡聽看看類似的發音吧',
                                                maxLines: 1,
                                              )
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemCount: _ipaAboutList.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    leading: const Icon(Icons.hearing_outlined),
                                                    title: RichText(
                                                      text: TextSpan(
                                                        text: _ipaAboutList[index],
                                                        style: const TextStyle(
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
                                                  return const Divider(
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
                                  ],
                                ),
                              ),
                            ]
                        )
                    )
                ),
              ),

              const Divider(
                thickness: 1,
                color: PageTheme.app_theme_blue,
              ),

              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: SvgPicture.asset('assets/icon/audio.svg'),
                      ),
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundColor: PageTheme.app_theme_blue,
                          radius: 40.0,
                          child: IconButton(
                            icon: Icon( (_allowTouchButtons['speakButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.stop : Icons.mic_none) : Icons.mic_off_outlined , size: 30),
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
                      Expanded(
                        flex: 2,
                        child: SvgPicture.asset('assets/icon/audio.svg'),
                      ),
                    ],
                  ),
                ),
              ),
            ]
        )
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
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
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
    });
    _handleSubmitted(result.recognizedWords, isFinalResult:result.finalResult);
  }

  void sttSoundLevelListener(double level) {
    sttMinSoundLevel = min(sttMinSoundLevel, level);
    sttMaxSoundLevel = max(sttMaxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      sttLevel = level;
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
    print('Received listener status: $status, listening: ${speechToText.isListening}');
    setState(() {
      sttLastStatus = status;
    });

    if (isWeb && sttLastStatus != 'listening' && speechToText.isListening == false) {
      _handleSubmitted(_answerText, isFinalResult:true);
    }
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

    if (speakMessage.isNotEmpty) {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakMessage);
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
      _answerIPATextWidget = [ const TextSpan(text: ''), ];
    });
    if(isFinalResult && _answerText!=""){
      _responseChatBot(_answerText);
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
                style: const TextStyle(
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
          if (i < questionTextArray.length) questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' '));
          if (i < questionIPATextArray.length) questionIPATextWidget.add(TextSpan(text: questionIPATextArray[i] + ' '));
        }

      }
      questionIPATextWidget.add(const TextSpan(text: ']'));



      var answerTextArray = checkSentences['data']['answerText'].split(' ');
      List<TextSpan> answerTextWidget = [];

      var answerIPATextArray = checkSentences['data']['answerIPAText'].split(' ');
      List<TextSpan> answerIPATextWidget = [];

      answerIPATextWidget.add(const TextSpan(text: '['));
      for (var i = 0; i < answerTextArray.length; i++) {
        if(checkSentences['data']['answerError'].containsKey(answerTextArray[i])){
          answerTextWidget.add(
              TextSpan(
                text: answerTextArray[i] + ' ',
                style: const TextStyle(
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
                style: const TextStyle(
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
      answerIPATextWidget.add(const TextSpan(text: ']'));

      List<TextSpan> replyTextWidget = [];
      replyTextWidget.add(TextSpan(text: checkSentences['data']['scoreComment']['text'] + ' '));
      replyTextWidget.add(const TextSpan(text: ' '));
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
        _viewIPAAboutList = (ipaAboutList.isNotEmpty);
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
      sleep(const Duration(seconds:1));
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

      // 來源為 IPA1, IPA2
      if (_IPA1 != '' && _IPA2 != '') {
        var minimalPairTwoFinder;
        do {
          String minimalPairTwoFinderJSON = await APIUtil.minimalPairTwoFinder(
              _IPA1, _IPA2, dataLimit: '10');
          minimalPairTwoFinder =
              jsonDecode(minimalPairTwoFinderJSON.toString());
          print('minimalPairTwoFinder 1 apiStatus:' +
              minimalPairTwoFinder['apiStatus'] + ' apiMessage:' +
              minimalPairTwoFinder['apiMessage']);
          if (minimalPairTwoFinder['apiStatus'] != 'success') {
            await Future.delayed(Duration(seconds: 1));
          }
        } while (minimalPairTwoFinder['apiStatus'] != 'success');

        final _random = Random().nextInt(minimalPairTwoFinder['data'].length);
        String sentenceContent = minimalPairTwoFinder['data'][_random]['leftWord'] +
            ', ' + minimalPairTwoFinder['data'][_random]['rightWord'];
        String sentenceIPA = minimalPairTwoFinder['data'][_random]['leftIPA'] +
            ', ' + minimalPairTwoFinder['data'][_random]['rightIPA'];
        String sentenceChinese = '';
        getTestQuestions(questionText: sentenceContent,
            questionIPAText: sentenceIPA,
            questionChineseText: sentenceChinese);

        setState(() {
          //_allowTouchButtons['nextButton'] = true;
        });
        return;
      }
      // 來源為 word
      if (_word != '') {
        var minimalPairWordFinder;
        do {
          String minimalPairWordFinderJSON = await APIUtil.minimalPairWordFinder(_word, dataLimit: '10');
          minimalPairWordFinder = jsonDecode(minimalPairWordFinderJSON.toString());
          print('minimalPairTwoFinder 1 apiStatus:' + minimalPairWordFinder['apiStatus'] + ' apiMessage:' + minimalPairWordFinder['apiMessage']);
          if(minimalPairWordFinder['apiStatus'] != 'success') {
            await Future.delayed(Duration(seconds: 1));
          }
        } while (minimalPairWordFinder['apiStatus'] != 'success');

        if (minimalPairWordFinder['data'].length == 0) {
          context.router.pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('哎呀，找不到相關資料'),
          ));
          return;
        }

        final _random = Random().nextInt(minimalPairWordFinder['data'].length);
        String sentenceContent = minimalPairWordFinder['data'][_random]['leftWord'] +
            ', ' + minimalPairWordFinder['data'][_random]['rightWord'];
        String sentenceIPA = minimalPairWordFinder['data'][_random]['leftIPA'] +
            ', ' + minimalPairWordFinder['data'][_random]['rightIPA'];
        String sentenceChinese = '';
        getTestQuestions(questionText: sentenceContent,
            questionIPAText: sentenceIPA,
            questionChineseText: sentenceChinese);

        setState(() {
          //_allowTouchButtons['nextButton'] = true;
        });
        return;
      }
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