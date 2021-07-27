
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
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

  PhoneticExercisesPage({String topicClass:'', String topicName:''}) {
    this.topicClass = topicClass;
    this.topicName = topicName;
  }

  @override
  _PhoneticExercisesPage createState() => new _PhoneticExercisesPage(topicClass:topicClass, topicName:topicName);
}

enum TtsState { playing, stopped, paused, continued }

class _PhoneticExercisesPage extends State<PhoneticExercisesPage> {

  String _applicationSettingsDataListenAndSpeakLevel = 'A1';
  String _topicClass = '';
  String _topicName = '';
  int _part = 0;
  String _questionText = '';
  _PhoneticExercisesPage({String topicClass:'', String topicName:''}) {
    this._topicClass = topicClass;
    this._topicName = topicName;
  }


  final List<ChatMessageUtil> _messages = <ChatMessageUtil>[];

  bool _allowTouchButton = false;
  


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
    initApplicationSettingsData();
    initTts();
    initSpeechState();
    initChatBot();
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
    //await initTestQuestions();
    await sendChatMessageAndSpeak('歡迎使用!', 'Welcome!', 'en-US');
    //await sendChatMessageAndSpeak('您目前選擇的題目分類為 ' + _topicClass + ': ' + _topicName + ' (' + _selectMode + ')', 'Your currently selected category is  ' + _topicClass + ': ' + _topicName, 'en-US');
    //await sendChatMessageAndSpeak('級別為 ' + _applicationSettingsDataListenAndSpeakLevel, 'The level is ' + _applicationSettingsDataListenAndSpeakLevel, 'en-US');
    await sendTestQuestions();
  }





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
      body: Column(
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
    await flutterTts.setVolume(ttsVolume);
    await flutterTts.setSpeechRate(ttsRate);
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

  Future sendChatMessage(bool senderIsMe, String senderName, String messageText, {bool needSpeak : false, String speakMessage : '', String speakLanguage : 'en-US'}) async {
    ChatMessageUtil message = new ChatMessageUtil(
      senderIsMe: senderIsMe,
      senderName: senderName,
      messageText: messageText,
    );
    setState(() {
      _messages.insert(0, message);
    });

    if(needSpeak) {
      await _ttsSpeak(speakMessage, speakLanguage);
    }
  }

  Future<void> sendChatMessageAndSpeak(String sendMessage, String speakMessage, String speakLanguage) async {
    sendChatMessage(false, 'Bot', sendMessage);
    await _ttsSpeak(speakMessage, speakLanguage);
  }


  void _handleSubmitted(String text) {
    sendChatMessage(true, 'Me', text);
    setState(() {
      _allowTouchButton = false;
    });
    _responseChatBot(text);
  }


  void _responseChatBot(text) async {
    String checkSentencesJSON = await APIUtil.checkSentences(_questionText, text, sentenceLevel:_applicationSettingsDataListenAndSpeakLevel);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());
    print(checkSentencesJSON.toString());

    if(checkSentences['apiStatus'] == 'success'){
      //String msg1 = checkSentences['data']['replyText'] + '! You get ' + checkSentences['data']['ipaTextSimilarity'].toString() + ' points';
      String msg1 = checkSentences['data']['replyText'] + '!';
      await sendChatMessage(false, 'Bot', msg1, needSpeak:true, speakMessage:msg1, speakLanguage:'en-US');

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
      await sendTestQuestions();


    } else {
      print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      sleep(Duration(seconds:1));
      _responseChatBot(text);
    }
  }

  Future<void> sendTestQuestions({String questionText : '', String aboutWord:''}) async {
    if(questionText == ''){

      String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, sentenceTopic :_topicName, sentenceClass:_topicClass, aboutWord:aboutWord, dataLimit:'1');
      var getSentences = jsonDecode(getSentencesJSON.toString());
      if(getSentences['apiStatus'] == 'success'){
        final _random = new Random();
        String sentenceContent = getSentences['data'][_random.nextInt(getSentences['data'].length)]['sentenceContent'];
        await sendTestQuestions(questionText:sentenceContent);
      } else {
        print('sendTestQuestions Error apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        sleep(Duration(seconds:1));
        await sendTestQuestions();
      }
    }else{
      _part++;
      _questionText = questionText;
      await sendChatMessage(false, 'Bot', '第 $_part 題：$questionText', needSpeak:true, speakMessage:questionText, speakLanguage:'en-US');
      setState(() {
        _allowTouchButton = true;
      });
      await sttStartListening();
    }
  }




}