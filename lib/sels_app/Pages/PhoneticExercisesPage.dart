
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sels_app/sels_app/utils/ChatMessageUtil.dart';
import 'package:sels_app/sels_app/utils/SharedPreferencesUtil.dart';
import 'package:sels_app/sels_app/utils/APIUtil.dart';


class PhoneticExercisesPage extends StatefulWidget {

  String topicClass = '';
  String topicName = '';
  List<int> sentencesIDData = const [];

  PhoneticExercisesPage({String topicClass:'', String topicName:'', List<int> sentencesIDData:const []}) {
    this.topicClass = topicClass;
    this.topicName = topicName;
    this.sentencesIDData = sentencesIDData;
  }

  @override
  _PhoneticExercisesPage createState() => new _PhoneticExercisesPage(topicClass:topicClass, topicName:topicName, sentencesIDData:sentencesIDData);
}

enum TtsState { playing, stopped, paused, continued }

class _PhoneticExercisesPage extends State<PhoneticExercisesPage> {

  List<int> _sentencesIDData = [];
  List _questionsData = [];
  int _totalTestQuestions = 25;
  String _applicationSettingsDataListenAndSpeakLevel = 'A1';
  double _applicationSettingsDataListenAndSpeakRanking = 300;
  String _topicClass = '';
  String _topicName = '';
  int _part = 0;
  String _questionText = '';
  _PhoneticExercisesPage({String topicClass:'', String topicName:'', List<int> sentencesIDData:const []}) {
    this._topicClass = topicClass;
    this._topicName = topicName;
    this._sentencesIDData = sentencesIDData;
  }
  var _allowTouchButtons = {
    'reListenButton' : false,
    'speakButton' : false,
    'pauseButton' : true,
  };
  int _correctCombo = 0;


  final List<ChatMessageUtil> _messages = <ChatMessageUtil>[];

  


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
    super.initState();
    initPhoneticExercisesPage();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    speechToText.stop();
    EasyLoading.dismiss();
  }

  /*
  initState() 初始化相關
   */

  initPhoneticExercisesPage() async {
    await initApplicationSettingsData();
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

      if (Platform.isIOS) {
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
    await sendChatMessage(false, 'Bot', [TextSpan(text: '測驗即將開始')], needSpeak:true, speakMessage:'Quiz is about to start', speakLanguage:'en-US');
    await sendChatMessage(false, 'Bot', [TextSpan(text: '請跟著我重複一次')], needSpeak:true, speakMessage:'Please repeat after me', speakLanguage:'en-US');
    await sendNextQuestion();
  }

  Future<void> initTestQuestions() async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    if(_sentencesIDData.length != 0){
      var getSentencesByID;
      for(final sentencesID in _sentencesIDData){
        do {
          String getSentencesByIDJSON = await APIUtil.getSentencesByID(sentencesID);
          getSentencesByID = jsonDecode(getSentencesByIDJSON.toString());
          print('getSentences 6 apiStatus:' + getSentencesByID['apiStatus'] + ' apiMessage:' + getSentencesByID['apiMessage']);
          sleep(Duration(seconds:1));
        } while (getSentencesByID['apiStatus'] != 'success');
        _questionsData.addAll(getSentencesByID['data']);
      }
      _totalTestQuestions = _questionsData.length;
    } else {
      var getSentences;
      // 獲取~5單字數的句子10句
      do {
        String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, sentenceMaxLength:'5', dataLimit:'10', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 1 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        sleep(Duration(seconds:1));
      } while (getSentences['apiStatus'] != 'success');
      _questionsData.addAll(getSentences['data']);
      // 獲取6~8單字數的句子10句
      do {
        String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, sentenceMinLength:'6', sentenceMaxLength:'8', dataLimit:'10', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 2 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        sleep(Duration(seconds:1));
      } while (getSentences['apiStatus'] != 'success');
      _questionsData.addAll(getSentences['data']);
      // 獲取9~10單字數的句子3句
      do {
        String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, sentenceMinLength:'9', sentenceMaxLength:'10', dataLimit:'3', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 3 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        sleep(Duration(seconds:1));
      } while (getSentences['apiStatus'] != 'success');
      _questionsData.addAll(getSentences['data']);
      // 獲取11~單字數的句子2句
      do {
        String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, sentenceMinLength:'11', dataLimit:'2', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 4 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        sleep(Duration(seconds:1));
      } while (getSentences['apiStatus'] != 'success');
      _questionsData.addAll(getSentences['data']);
      // 檢查是否共_totalTestQuestions句，若否則隨機補足
      while(_questionsData.length < _totalTestQuestions) {
        do {
          String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, dataLimit:'1', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
          getSentences = jsonDecode(getSentencesJSON.toString());
          print('getSentences 5 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
          sleep(Duration(seconds:1));
        } while (getSentences['apiStatus'] != 'success');
        _questionsData.addAll(getSentences['data']);
      }
    }
    EasyLoading.dismiss();
    print('_questionsData');
    print(_questionsData);


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





  /*
  UI 介面
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('(自動)[' + _applicationSettingsDataListenAndSpeakLevel + '] (' + _topicClass + ': ' + _topicName + ')' ),
      ),
      body:

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
                                  /*
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
                                                    icon: const Icon(Icons.pause),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      if(_allowTouchButtons['pauseButton']!){
                                                        _ttsStop();
                                                        sttStopListening();
                                                        //getTestQuestions();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '暫停',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                  ),

                                   */
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


      /*
      Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                )
            ),
            Divider(
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          children: [
                            Center(
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.red,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.replay),
                                  color: Colors.white,
                                  onPressed: () { print('reply Button'); },
                                ),
                              ),
                            ),
                            //Text('Replay')
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
                                  endRadius: 50.0,
                                  duration: const Duration(milliseconds: 2000),
                                  repeatPauseDuration: const Duration(milliseconds: 100),
                                  repeat: true,
                                  child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.red,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(speechToText.isListening ? Icons.mic : Icons.mic_none),
                                      color: Colors.white,
                                      onPressed: (){
                                        if(_allowTouchButton){
                                          if( !_sttHasSpeech || speechToText.isListening ){
                                            sttStopListening();
                                          } else {
                                            sttStartListening();
                                          }
                                        }

                                      },
                                    ),
                                  ),
                                )
                            ),
                            //Text('Speak')
                          ],
                        )
                    )
                  ],
                )
            ),
          ]
      ),

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
        partialResults: false,
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
    sleep(Duration(seconds:1));
    await sttStopListening();
    await sttStartListening();
  }

  void sttResultListener(SpeechRecognitionResult result) {
    ++sttResultListened;
    print('Result listener $sttResultListened');
    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
      if(result.finalResult){
        _handleSubmitted(result.recognizedWords);
      }
      print(sttLastWords);
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

  Future sendChatMessage(bool senderIsMe, String senderName, List<TextSpan> messageTextWidget, {String messageImage: '', bool needSpeak : false, String speakMessage : '', String speakLanguage : 'en-US'}) async {
    ChatMessageUtil message = new ChatMessageUtil(
      senderIsMe: senderIsMe,
      senderName: senderName,
      //messageText: messageText,
      messageTextWidget: messageTextWidget,
      messageImage: messageImage,
    );
    setState(() {
      _messages.insert(0, message);
    });

    if(needSpeak) {
      await _ttsSpeak(speakMessage, speakLanguage);
    }
  }

  void _handleSubmitted(String text) {
    sendChatMessage(true, 'Me', [TextSpan(text: text)]);
    setState(() {
      ttsRateSlow = false;
      _allowTouchButtons['reListenButton'] = false;
      _allowTouchButtons['speakButton'] = false;
      _allowTouchButtons['pauseButton'] = false;
    });
    _responseChatBot(text);
  }


  void _responseChatBot(text) async {
    String checkSentencesJSON = await APIUtil.checkSentences(_questionText, text, correctCombo:_correctCombo);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());
    //print(checkSentencesJSON.toString());

    if(checkSentences['apiStatus'] == 'success'){

      if(checkSentences['data']['ipaTextSimilarity'] == 100){
        _correctCombo++;
      } else {
        _correctCombo = 0;
      }

      ChatMessageUtil message;

      var questionTextArray = checkSentences['data']['questionText'].split(' ');
      List<TextSpan> questionTextWidget = [TextSpan(text: '第 $_part/$_totalTestQuestions 題：')];
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
          questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' '));
        }
      }

      message = new ChatMessageUtil(
        senderIsMe: false,
        senderName: 'Bot',
        messageTextWidget: questionTextWidget,
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

      message = new ChatMessageUtil(
        senderIsMe: true,
        senderName: 'Me',
        messageTextWidget: answerTextWidget,
      );
      setState(() {
        _messages[0] = message;
      });
      //await sendChatMessage(true, 'Me', [TextSpan(text: text)]);
      await sendChatMessage(false, 'Bot', [TextSpan(text: checkSentences['data']['scoreComment']['text'] + ' ' + checkSentences['data']['scoreComment']['emoji'])], needSpeak:true, speakMessage:checkSentences['data']['scoreComment']['text'].toLowerCase(), speakLanguage:'en-US');

      /*
      if(checkSentences['data']['ErrorWord'].length > 0){

        final _random = new Random();
        String errorWord = checkSentences['data']['ErrorWord'][_random.nextInt(checkSentences['data']['ErrorWord'].length)];
        String msg2 = 'Oh, there seems to be something wrong with your pronunciation of $errorWord, try this related sentence';
        await sendChatMessage(false, 'Bot', msg2, needSpeak:true, speakMessage:msg2, speakLanguage:'en-US');
        await sendTestQuestions(aboutWord:errorWord);
      } else{
        await sendTestQuestions();
      }
       */
      await sendNextQuestion();


    } else {
      print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      sleep(Duration(seconds:1));
      _responseChatBot(text);
    }
  }


  Future<void> sendNextQuestion() async {
    _part++;
    if( _part > _totalTestQuestions){
      await sendChatMessage(false, 'Bot', [TextSpan(text: 'Quiz is over')], needSpeak:true, speakMessage:'Quiz is over', speakLanguage:'en-US');
    } else {
      _questionText = _questionsData[_part - 1]['sentenceContent'];
      await sendChatMessage(false, 'Bot', [TextSpan(text: '第 ${_part}/$_totalTestQuestions 題：${_questionsData[_part - 1]['sentenceChinese']}')], needSpeak:false, speakMessage:'', speakLanguage:'zh-TW');
      await sendChatMessage(false, 'Bot', [TextSpan(text: '第 ${_part}/$_totalTestQuestions 題：${_questionText}')], needSpeak:true, speakMessage:_questionText, speakLanguage:'en-US');
      setState(() {
        ttsRateSlow = false;
        _allowTouchButtons['reListenButton'] = true;
        _allowTouchButtons['speakButton'] = true;
        _allowTouchButtons['pauseButton'] = true;
      });
      await sttStartListening();
    }



  }

}