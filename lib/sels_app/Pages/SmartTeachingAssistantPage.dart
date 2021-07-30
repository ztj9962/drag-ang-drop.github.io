

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sels_app/main.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';
import 'package:sels_app/sels_app/Utils/ChatMessageUtil.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';
import 'package:sels_app/sels_app/utils/SharedPreferencesUtil.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SmartTeachingAssistantPage extends StatefulWidget {
  @override
  _SmartTeachingAssistantPage createState() => _SmartTeachingAssistantPage();
}

enum TtsState { playing, stopped, paused, continued }

class _SmartTeachingAssistantPage extends State<SmartTeachingAssistantPage> {

  String _applicationSettingsDataAccessToken = '';
  String _applicationSettingsDataConversationID = '';

  final List<ChatMessageUtil> _messages = <ChatMessageUtil>[];

  var _allowTouchButtons = {
    'listenResultButton' : false,
    'voiceInputButton' : true,
    'copyResultButton' : false,
  };

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
    initApplicationSettingsData();
    initTts();
    initSpeechState();
    initChatBot();
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
    SharedPreferencesUtil.getData<String>('applicationSettingsDataAccessToken').then((value) {
      setState(() => _applicationSettingsDataAccessToken = value!);
    });
    SharedPreferencesUtil.getData<String>('applicationSettingsDataConversationID').then((value) {
      setState(() => _applicationSettingsDataConversationID = value!);
    });
  }


  Future<void> initChatBot() async {
    _responseAPI('/restart');
    _responseAPI('Hi');
    //await _sendChatMessageAndSpeak('Hi! I\'m BYOS. Your smart teaching assistant.', 'Hi! I\'m byos. Your smart teaching assistant.', 'en-US');

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
      /*
        appBar: AppBar(
          centerTitle: true,
          title: Text('文法校正' ),
        ),

       */
        body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[

                ]
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
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

                                Padding(
                                  padding:
                                  EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                  child: SizedBox(
                                    width: 38 * 2.0,
                                    height: 38 + 62.0,
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      color: Colors.transparent,
                                      child: SizedBox(
                                        width: 38 * 2.0,
                                        height: 38 * 2.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: (){
                                                if(_allowTouchButtons['voiceInputButton']! && !isPlaying ){
                                                  if( !_sttHasSpeech || speechToText.isListening ){
                                                    sttStopListening();
                                                  } else {
                                                    sttStartListening();
                                                  }
                                                }
                                              },
                                              onDoubleTap: (){
                                                print('雙極');
                                              },
                                              onLongPress: (){
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: SELSAppTheme.nearlyDarkBlue,
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        SELSAppTheme.nearlyDarkBlue,
                                                        HexColor('#6A88E5'),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight),
                                                  shape: BoxShape.circle,
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: SELSAppTheme.nearlyDarkBlue
                                                            .withOpacity(0.4),
                                                        offset: const Offset(8.0, 16.0),
                                                        blurRadius: 16.0),
                                                  ],
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    splashColor: Colors.white.withOpacity(0.1),
                                                    highlightColor: Colors.transparent,
                                                    focusColor: Colors.transparent,
                                                    child: Icon(
                                                      (_allowTouchButtons['voiceInputButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.psychology : Icons.psychology_outlined) : Icons.psychology_outlined,
                                                      color: SELSAppTheme.white,
                                                      size: 32,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ]
                          )
                      )

                  )
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
    //print('Result listener $sttResultListened');

    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
      //print(sttLastWords);
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
    //print(selectedVal);
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
      _allowTouchButtons['voiceInputButton'] = false;
    });
    await sttStopListening();
    await flutterTts.setLanguage(speakLanguage);
    await flutterTts.setSpeechRate(ttsRate);
    await flutterTts.setVolume(ttsVolume);
    await flutterTts.setPitch(ttsPitch);

    if (speakMessage != null) {
      if (speakMessage.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(speakMessage);
      }
    }
    setState(() {
      _allowTouchButtons['voiceInputButton'] = true;
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
  Future sendChatMessage(bool senderIsMe, String senderName, {String messageText: '', String messageImage: '', bool needSpeak : false, String speakMessage : '', String speakLanguage : 'en-US'}) async {
    ChatMessageUtil message = new ChatMessageUtil(
      senderIsMe: senderIsMe,
      senderName: senderName,
      messageText: messageText,
      messageImage: messageImage,
    );
    setState(() {
      _messages.insert(0, message);
    });

    if(needSpeak) {
      await _ttsSpeak(speakMessage, speakLanguage);
    }
  }

  void _handleSubmitted(String text, {bool isFinalResult:false}) {
    if(isFinalResult){
      sendChatMessage(true, 'Me', messageText:text);
      _responseAPI(text);
    }
  }


  void _responseAPI(text) async {

    String sendMessageToConversationJSON = await APIUtil.sendMessageToConversation(_applicationSettingsDataAccessToken, _applicationSettingsDataConversationID, text);
    var sendMessageToConversation = jsonDecode(sendMessageToConversationJSON.toString());

    print(sendMessageToConversationJSON);

    if(sendMessageToConversation['apiStatus'] == 'success'){

      var responseMessage = sendMessageToConversation['data'];

      for (var i = 0; i < responseMessage.length; i++) {
        switch(responseMessage[i]['type']){
          case 'image':
            var value = responseMessage[i]['value'];
            await sendChatMessage(false, 'Rasa', messageImage:value, needSpeak:true, speakMessage:'', speakLanguage:'en-US');
            break;
          case 'text':
            String value = responseMessage[i]['value'];
            await sendChatMessage(false, 'Rasa', messageText:value, needSpeak:true, speakMessage:value.toLowerCase(), speakLanguage:'en-US');
            break;
        }


      }


    } else {
      print('_responseAPI Error apiStatus:' + sendMessageToConversation['apiStatus'] + ' apiMessage:' + sendMessageToConversation['apiMessage']);
      await sendChatMessage(false, 'Rasa', messageText:'發生錯誤，正在重新嘗試連線', needSpeak:false, speakMessage:'發生錯誤，正在重新嘗試連線', speakLanguage:'zh-TW');
      //sleep(Duration(seconds:1));
      _responseAPI(text);
    }



  }


}
