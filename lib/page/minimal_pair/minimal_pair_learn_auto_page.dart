
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:alicsnet_app/util/chat_message_util.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:wakelock/wakelock.dart';

class MinimalPairLearnAutoPage extends StatefulWidget {

  final String IPA1;
  final String IPA2;
  final String word;
  const MinimalPairLearnAutoPage ({ Key? key, this.IPA1 = '', this.IPA2 = '', this.word = '' }): super(key: key);

  @override
  _MinimalPairLearnAutoPage createState() => _MinimalPairLearnAutoPage();
}

enum TtsState { playing, stopped, paused, continued }

class _MinimalPairLearnAutoPage extends State<MinimalPairLearnAutoPage> {

  /* 測驗時長計時器 */
  late Timer _timer;
  late int _answerSeconds;
  bool _isActive = false;

  var _startTime;
  var _questionStart;
  var _questionEnd;
  String _IPA1 = '';
  String _IPA2 = '';
  String _word = '';


  late double _progress;
  List<int> _sentencesIDData = [];
  List _questionsData = [];
  int _totalTestQuestions = 25;
  int _quizID = 0;
  String _answerText = '';
  Map<String, dynamic> _wordSet = {'learningClassification': '' , 'learningPhase': '' };
  String _applicationSettingsDataUUID = '';
  String _applicationSettingsDataListenAndSpeakLevel = '';
  double _applicationSettingsDataListenAndSpeakRanking = 0;
  String _topicClass = '';
  String _topicName = '';
  int _part = 0;
  String _questionText = '';

  var _allowTouchButtons = {
    'reListenButton' : false,
    'speakButton' : false,
    'pauseButton' : true,
  };
  int _correctCombo = 0;
  Map _finishQuizData = {
    'sentenceIDArray' : <int>[],
    'sentenceAnswerArray' : <String>[],
    'scoreArray' : <int>[],
    'secondsArrayQ' : <int>[],
    'secondsArray' : <int>[],
    'userAnswerRate' : <double>[],
  };


  final List<Widget> _messages = <Widget>[];




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
    initMinimalPairLearnAutoPage();
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    flutterTts.stop();
    speechToText.stop();
    EasyLoading.dismiss();
    //_timer?.cancel();
    _timer.cancel();
  }

  /*
  initState() 初始化相關
   */

  initMinimalPairLearnAutoPage() async {
    Wakelock.enable();
    await initApplicationSettingsData();
    await initAnswerTimer();
    await initTts();
    await initSpeechState();
    await initTestQuestions();
    await initChatBot();
  }

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
    SharedPreferencesUtil.getData<String>('applicationSettingsDataUUID').then((value) {
      setState(() => _applicationSettingsDataUUID = value!);
    });
    SharedPreferencesUtil.getData<String>('applicationSettingsDataListenAndSpeakLevel').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakLevel = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataListenAndSpeakRanking').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakRanking = value!);
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

      if (isIOS) {
        await flutterTts
            .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
        ]);
      }

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }


  Future<void> initChatBot() async {
    _startTime = new DateTime.now();
    await sendChatMessage(false, 'Bot', [TextSpan(text: '測驗即將開始\n請跟著我重複一次')], needSpeak:true, speakMessage:'Quiz is about to start. Please repeat after me', speakLanguage:'en-US');
    await sendNextQuestion();
  }

  Future<void> initTestQuestions() async {

    List questionsData = [];
    _progress = 0;
    EasyLoading.show(status: '正在讀取資料，請稍候......');

    // 來源為 IPA1, IPA2
    if (_IPA1 != '' && _IPA2 != '') {
      var minimalPairTwoFinder;
      do {
        String minimalPairTwoFinderJSON = await APIUtil.minimalPairTwoFinder(_IPA1, _IPA2, dataLimit: '10');
        minimalPairTwoFinder = jsonDecode(minimalPairTwoFinderJSON.toString());
        print('minimalPairTwoFinder 1 apiStatus:' + minimalPairTwoFinder['apiStatus'] + ' apiMessage:' + minimalPairTwoFinder['apiMessage']);
        if(minimalPairTwoFinder['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (minimalPairTwoFinder['apiStatus'] != 'success');
      print(minimalPairTwoFinder['data']);

      minimalPairTwoFinder['data'].forEach((value) {
        questionsData.add({
          "sentenceId":0,
          "sentenceContent": value['leftWord'] + ', ' + value['rightWord'],
          "sentenceChinese": '',
        });
      });

      EasyLoading.dismiss();
      print('questionsData');
      print(questionsData);
      _questionsData = questionsData;
      _totalTestQuestions = questionsData.length;
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

      minimalPairWordFinder['data'].forEach((value) {
        questionsData.add({
          "sentenceId":0,
          "sentenceContent": value['leftWord'] + ', ' + value['rightWord'],
          "sentenceChinese": '',
        });
      });

      EasyLoading.dismiss();
      print('questionsData');
      print(questionsData);
      _questionsData = questionsData;
      _totalTestQuestions = questionsData.length;
      return;

    }

    EasyLoading.dismiss();
    return;
  }
/*
  Future<String> createTestQuestions() async {
    final response = await http.post(
      Uri.https('sels.nfs.tw', 'API_TEST/v2/chatBot/getTestSentence/'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceLevel': _sentenceLevel,
        'topicID': _topicID,
        'topicName': _topicName,
        'topicClass': _topicClass
      },
    );
    String json = response.body.toString();
    return json;
  }

 */

  Future<void> initAnswerTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      handleTick();
    });
    if (isIOS) {
      _answerSeconds = -3;
    } else {
      _answerSeconds = 0;
    }
  }





  /*
  UI 介面
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PageTheme.minimal_pair_background,
          title: (_quizID != 0)? Text('記錄檔') : (_wordSet['learningClassification'] != '')? Text('單字集') : Text('(自)[${_applicationSettingsDataListenAndSpeakLevel}/${_applicationSettingsDataListenAndSpeakRanking.round().toString()}] (${_topicClass}:${_topicName})' ),
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  child: ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                color: PageTheme.minimal_pair_background,
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
                          backgroundColor: PageTheme.minimal_pair_background,
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

      /*
        Stack(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.grey, offset: Offset(1.1, 1.1), blurRadius: 10.0),
                        ],
                      ),
                      child: Container(
                          child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                                  child: Divider(
                                    height: 1,
                                    thickness: 1,
                                  ),
                                ),
                                Flexible(
                                    child: ListView.builder(
                                      padding: new EdgeInsets.all(8.0),
                                      reverse: true,
                                      itemBuilder: (_, int index) => _messages[index],
                                      itemCount: _messages.length,
                                    )
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
                                                        onPressed: () async {
                                                          if(_allowTouchButtons['speakButton']! && !isPlaying ){
                                                            if( !_sttHasSpeech || speechToText.isListening ){
                                                              sttStopListening();
                                                            } else {
                                                              sttCancelListening();
                                                              await Future.delayed(Duration(milliseconds: 800));
                                                              sttStartListening();
                                                            }
                                                          }},
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
                                    ],
                                  ),
                                ),


                              ]
                          )
                      )
                  )
              )
            ]
        )
        */


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
    //await Future.delayed(Duration(seconds: 1));
    //await sttStopListening();
    //await sttStartListening();
  }

  void sttResultListener(SpeechRecognitionResult result) {
    ++sttResultListened;
    print('Result listener $sttResultListened');
    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
    print(sttLastWords);
    _handleSubmitted(result.recognizedWords, isFinalResult:result.finalResult);
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

    await sttStopListening();

    await flutterTts.setLanguage(speakLanguage);
    if(ttsRateSlow){
      await flutterTts.setSpeechRate(ttsRate * 0.22);
    } else {
      await flutterTts.setSpeechRate(ttsRate);
    }
    await flutterTts.setPitch(ttsPitch);
    if (speakMessage != null) {
      if (speakMessage.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(speakMessage);
      }
    }
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

  Future sendChatMessage(bool senderIsMe, String senderName, List<TextSpan> messageTextWidget, {bool needSpeak : false, bool canSpeak : false, String speakMessage : '', String speakLanguage : 'en-US'}) async {
    ChatMessageUtil message = ChatMessageUtil(
      senderIsMe: senderIsMe,
      senderName: senderName,
      messageTextWidget: messageTextWidget,
      actionButton:
      (canSpeak)
          ? IconButton(
            icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined),
            color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.black : Colors.grey ,
            onPressed: () async {
              if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                ttsRateSlow = !ttsRateSlow;
                await _ttsSpeak(speakMessage, speakLanguage);
              }
            },
          )
          : null

      ,
    );
    setState(() {
      _messages.insert(0, message);
    });

    if(needSpeak) {
      await _ttsSpeak(speakMessage, speakLanguage);
    }
  }

  void _handleSubmitted(String text, {bool isFinalResult:false}) {
    setState(() {
      _answerText = text;
    });

    if(text != '' && isFinalResult){
      sendChatMessage(true, 'Me', [TextSpan(text: text)]);
      _finishQuizData['secondsArray']!.add(_answerSeconds);

      setState(() {
        _isActive = false;
        ttsRateSlow = false;
        _allowTouchButtons['reListenButton'] = false;
        _allowTouchButtons['speakButton'] = false;
        _allowTouchButtons['pauseButton'] = false;
      });

      _responseChatBot(text);
    }
  }


  void _responseChatBot(text) async {
    print('_responseChatBot('+text);
    String checkSentencesJSON = await APIUtil.checkSentences(_questionText, text, correctCombo:_correctCombo);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());
    print(checkSentencesJSON.toString());

    if(checkSentences['apiStatus'] == 'success'){

      if(checkSentences['data']['ipaTextSimilarity'] == 100){
        _correctCombo++;
      } else {
        _correctCombo = 0;
      }

      ChatMessageUtil message;

      var questionTextArray = checkSentences['data']['questionText'].split(' ');
      List<TextSpan> questionTextWidget = [];
      for (var i = 0; i < questionTextArray.length; i++) {
        if(checkSentences['data']['questionError'].containsKey(questionTextArray[i])){
          questionTextWidget.add(
              TextSpan(
                text: questionTextArray[i] + ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
          );
        } else {
          if (i < questionTextArray.length) questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' '));
        }
      }
      questionTextWidget.add(TextSpan(text: '\n第 $_part/$_totalTestQuestions 題：${_questionsData[_part - 1]['sentenceChinese']}'));


      message = ChatMessageUtil(
        senderIsMe: false,
        senderName: 'Bot',
        messageTextWidget: questionTextWidget,
        actionButton: IconButton(
          icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined),
          color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.black : Colors.grey ,
          onPressed: () async {
            if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
              ttsRateSlow = !ttsRateSlow;
              await _ttsSpeak(checkSentences['data']['questionText'], "en-US");
            }
          },
        )
        ,
      );
      setState(() {
        _messages[1] = message;
      });

      var answerTextArray = checkSentences['data']['answerText'].split(' ');
      List<TextSpan> answerTextWidget = [];

      for (var i = 0; i < answerTextArray.length; i++) {
        if(checkSentences['data']['answerError'].containsKey(answerTextArray[i])){
          answerTextWidget.add(
              TextSpan(
                text: answerTextArray[i] + ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
          );
        } else {
          answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' '));
        }
      }

      message = ChatMessageUtil(
        senderIsMe: true,
        senderName: 'Me',
        messageTextWidget: answerTextWidget,
      );
      setState(() {
        _messages[0] = message;
        _answerText = '';
      });
      _finishQuizData['sentenceIDArray']!.add(_questionsData[_part - 1]['sentenceId']);
      _finishQuizData['sentenceAnswerArray']!.add(checkSentences['data']['answerText']);
      _finishQuizData['scoreArray']!.add(checkSentences['data']['scoreComment']['score']);
      _finishQuizData['userAnswerRate']!.add(checkSentences['data']['answerText'].split(' ').length / _finishQuizData['secondsArray']![_part - 1]);
      print(_finishQuizData);
      await sendChatMessage(false, 'Bot', [TextSpan(text: '${checkSentences['data']['scoreComment']['text']} ${checkSentences['data']['scoreComment']['emoji']}\n您花 ${_finishQuizData['secondsArray']![_part - 1].toString()} 秒（${_finishQuizData['userAnswerRate']![_part - 1].toStringAsFixed(2)}wps）回答')], needSpeak:true, speakMessage:checkSentences['data']['scoreComment']['text'].toLowerCase(), speakLanguage:'en-US');
      await sendNextQuestion();


    } else {
      print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      await Future.delayed(Duration(seconds: 1));
      _responseChatBot(text);
    }
  }


  Future<void> sendNextQuestion() async {
    await Future.delayed(Duration(milliseconds: 780));
    _part++;
    if( _part > _totalTestQuestions){
      var _endTime = DateTime.now();
      await sendChatMessage(false, 'Bot', [TextSpan(text: '測驗結束')], needSpeak:true, speakMessage:'Quiz is over', speakLanguage:'en-US');

      //var secondsArraySum = _finishQuizData['secondsArray'].reduce((sum, element) => int.parse(sum) + int.parse(element));
      var secondsArraySum = _finishQuizData['secondsArray'].fold(0, (p, c) => p + c);
      var userAnswerRate = _finishQuizData['userAnswerRate'].fold(0, (p, c) => p + c);



      await sendChatMessage(false, 'Bot', [
        TextSpan(text: '=== 紀錄 ===\n'),
        TextSpan(text: '答對題數/總題數：${ _finishQuizData['scoreArray'].where((score) => score == 100).toList().length } / ${ _finishQuizData['scoreArray'].length }\n'),
        TextSpan(text: '設定AI語速：${ttsRate.toStringAsFixed(2)} 倍速\n'),
        TextSpan(text: '您的平均語速：${userAnswerRate.toStringAsFixed(2)} wps\n'),
        TextSpan(text: '總測驗時間：${_endTime.difference(_startTime).inSeconds}秒'),
        //TextSpan(text: '總回答秒數：${ secondsArraySum }秒\n'),
        //TextSpan(text: '平均回答秒數：${ secondsArraySum / _finishQuizData['secondsArray'].length }秒\n'),

      ], needSpeak:false, speakMessage:'', speakLanguage:'en-US');

      /*
      if(_quizID != 0){
        EasyLoading.show(status: '正在儲存資料，請稍候......\nsssss');
        var updateQuizData;
        do {
          String updateQuizDataJSON = await APIUtil.updateQuizData(_applicationSettingsDataUUID, _quizID, _finishQuizData['sentenceIDArray'], _finishQuizData['sentenceAnswerArray'], _finishQuizData['scoreArray'], _finishQuizData['secondsArray']);
          updateQuizData = jsonDecode(updateQuizDataJSON.toString());
          print('updateQuizData 1 apiStatus:' + updateQuizData['apiStatus'] + ' apiMessage:' + updateQuizData['apiMessage']);
          if(updateQuizData['apiStatus'] != 'success') {
            EasyLoading.show(status: '儲存資料發生錯誤，正在重試......\n${updateQuizData['apiMessage']}');
            await Future.delayed(Duration(seconds: 1));
          }
        } while (updateQuizData['apiStatus'] != 'success');

        EasyLoading.dismiss();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('紀錄已更新'),
        ));
      } else {
        showCupertinoDialog();
      }
       */
    } else {
      _questionText = _questionsData[_part - 1]['sentenceContent'];
      //_questionStart = DateTime.now();
      await sendChatMessage(false, 'Bot', [TextSpan(text: '${_questionText}\n第 ${_part}/$_totalTestQuestions 題：${_questionsData[_part - 1]['sentenceChinese']}')], needSpeak:true, canSpeak:true, speakMessage:_questionText, speakLanguage:'en-US');
      //_questionEnd = DateTime.now();
      //var questionSecond = _questionEnd.difference(_questionStart).inSecond;
      //await sendChatMessage(false, 'Bot', [TextSpan(text: '${questionSecond}')]);
      //await sendChatMessage(false, 'Bot', [TextSpan(text: 'The number of seconds in the sentence is: ${ttsRate}')], needSpeak:false, speakMessage:'', speakLanguage: 'en-US');
      await Future.delayed(Duration(milliseconds: (_part / _totalTestQuestions * 2340).round()));
      setState(() {
        _isActive = true;
      });
      await sttStartListening();
      setState(() {
        ttsRateSlow = false;
        _allowTouchButtons['reListenButton'] = true;
        _allowTouchButtons['speakButton'] = true;
        _allowTouchButtons['pauseButton'] = true;
      });
    }
  }

  /*
  void showCupertinoDialog() {
    TextEditingController textInputController = new TextEditingController();

    //textInputController..text = '[${_applicationSettingsDataListenAndSpeakLevel}/${_applicationSettingsDataListenAndSpeakRanking.round().toString()}] (${_topicClass}:${_topicName})';
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('請問要儲存本次紀錄嗎？'),
          content: TextField(
            controller: textInputController,
            decoration: InputDecoration(hintText: '請在此輸入標題'),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('不要儲存'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('儲存'),
              onPressed: () async {
                if(textInputController.text == ''){
                  textInputController..text = '[${_applicationSettingsDataListenAndSpeakLevel}/${_applicationSettingsDataListenAndSpeakRanking.round().toString()}] (${_topicClass}:${_topicName})';
                }

                var saveQuizData;
                do {
                  String saveQuizDataJSON = await APIUtil.saveQuizData(_applicationSettingsDataUUID, textInputController.text, _finishQuizData['sentenceIDArray'], _finishQuizData['sentenceAnswerArray'], _finishQuizData['scoreArray'], _finishQuizData['secondsArray']);
                  saveQuizData = jsonDecode(saveQuizDataJSON.toString());
                  print('saveQuizData 1 apiStatus:' + saveQuizData['apiStatus'] + ' apiMessage:' + saveQuizData['apiMessage']);
                  if(saveQuizData['apiStatus'] != 'success') {
                    await Future.delayed(Duration(seconds: 1));
                  }
                } while (saveQuizData['apiStatus'] != 'success');

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('紀錄已儲存'),
                ));

                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

   */

  void handleTick() {
    //print(_answerSeconds);
    if (_isActive) {
      setState(() {
        _answerSeconds += 1;
      });
    } else {
      setState(() {
        if (isIOS) {
          _answerSeconds = -3;
        } else {
          _answerSeconds = 0;
        }
      });
    }
  }

}
