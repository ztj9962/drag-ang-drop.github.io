
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
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

class LearningAutoVocabularyPracticeWordLitePage extends StatefulWidget {

  final List<String> contentList;
  final List<String> ipaList;
  final List<String> translateList;
  final List<bool> mainCheckList;
  final List<String> oriList;
  final List<int> idList;
  const LearningAutoVocabularyPracticeWordLitePage ({ Key? key, required this.contentList, required this.ipaList, required this.translateList, required this.mainCheckList, required this.oriList, required this.idList}): super(key: key);

  @override
  _LearningAutoVocabularyPracticeWordLitePage createState() => _LearningAutoVocabularyPracticeWordLitePage();
}

enum TtsState { playing, stopped, paused, continued }

class _LearningAutoVocabularyPracticeWordLitePage extends State<LearningAutoVocabularyPracticeWordLitePage> {
  late List<String> _contentList;
  late List<String> _ipaList;
  late List<String> _translateList;
  late List<bool> _mainCheckList;
  late List<String> _oriLIst;
  late List<int> _idList;
  int _mainCheckIndex = 0;
  int _sentenceCounter = 1;
  int _sentenceTotal = 1;
  int _chunksCounter = 0;
  List<int> _chunksTotal = [];
  bool _changeColor = false;

  int _part = 0;
  final List<Widget> _messages = <Widget>[];

  String _answerText = '';
  var _startTime;

  var _allowTouchButtons = {
    'reListenButton' : false,
    'speakButton' : false,
    'pauseButton' : true,
  };
  int _correctCombo = 0;
  Map _finishQuizData = {
    'sentenceAnswerArray' : <String>[],
    'scoreArray' : <int>[],
    'secondsArrayQ' : <int>[],
    'secondsArray' : <int>[],
    'userAnswerRate' : <double>[],
  };




  // 測驗時長計時器
  late Timer _timer;
  late int _answerSeconds;
  bool _isActive = false;

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
  late double ttsRate;
  String ttsRateString = '一般';
  bool ttsRateSlow = false;
  bool ttsIsCurrentLanguageInstalled = false;
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
    _contentList = widget.contentList;
    _ipaList = widget.ipaList;
    _translateList = widget.translateList;
    _mainCheckList = widget.mainCheckList;
    _oriLIst = widget.oriList;
    _idList = widget.idList;
    int chunksCounting = 0;
    for(int c = 0; c <_oriLIst.length;c++){
      if(c != 0 && _oriLIst[c] != _oriLIst[c-1]){
        _chunksTotal.add(chunksCounting);
        chunksCounting = 1;
        _sentenceTotal++;
      }else{
        chunksCounting++;
      }
    }
    _chunksTotal.add(chunksCounting);
    super.initState();
    initLearningAutoVocabularyPracticeWordLitePage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              tooltip: 'Info',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog());
              },
            ), //IconButton
          ],
          centerTitle: true,
          backgroundColor: PageTheme.app_theme_black,
          title: Column(
            children: <Widget>[
              AutoSizeText(
                '',
                maxLines: 1,
              ),
              AutoSizeText(
                '',
                maxLines: 1,
              ),
            ],
          ),
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                flex: 7,
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
                color: PageTheme.app_theme_blue,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  //color: Colors.red,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          switch (ttsRateString) {
                            case '2倍':
                              ttsRate = 0.125;
                              break;
                            case '0.25倍':
                              ttsRate = 0.25;
                              break;
                            case '0.5倍':
                              ttsRate = 0.5;
                              break;
                            case '一般':
                              ttsRate = 0.625;
                              break;
                            case '1.25倍':
                              ttsRate = 0.75;
                              break;
                            case '1.5倍':
                              ttsRate = 0.875;
                              break;
                            case '1.75倍':
                              ttsRate = 1.0;
                              break;
                            default:
                              ttsRate = 0.5;
                              break;
                          }
                          setState(() {
                            ttsRate = ttsRate;
                            ttsRateSlow = false;
                          });
                          print(ttsRateSlow.toString());
                          SharedPreferencesUtil.setTTSRate(ttsRate);
                          SharedPreferencesUtil.getTTSRateString().then((value) {
                            setState(() => ttsRateString = value);
                          });

                        },
                        child: Text('語速：${ttsRateString}'),
                      ),
                    ],
                  ),
                ),
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
  initState() 初始化相關
   */

  initLearningAutoVocabularyPracticeWordLitePage() async {
    Wakelock.enable();
    await initApplicationSettingsData();
    await initAnswerTimer();
    await initTts();
    await initSpeechState();
    await initChatBot();
  }

  initApplicationSettingsData() {
    SharedPreferencesUtil.getTTSVolume().then((value) {
      setState(() => ttsVolume = value);
    });
    SharedPreferencesUtil.getTTSPitch().then((value) {
      setState(() => ttsPitch = value);
    });
    SharedPreferencesUtil.getTTSRate().then((value) {
      setState(() => ttsRate = value);
      print('update iiiiiii'+value.toString());
    });
    SharedPreferencesUtil.getTTSRateString().then((value) {
      setState(() => ttsRateString = value);
    });
  }


  /// This initializes SpeechToText. That only has to be done
  /// once per application, though calling it again is harmless
  /// it also does nothing. The UX of the sample app ensures that
  /// it can only be called once.
  Future<void> initSpeechState() async {
    try {
      var sttHasSpeech = await speechToText.initialize(
        onError: sttErrorListener,
        onStatus: sttStatusListener,
        debugLogging: true,
      );
      if (sttHasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.

        _sttLocaleNames = await speechToText.locales();

        var systemLocale = await speechToText.systemLocale();
        //_sttCurrentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        _sttHasSpeech = sttHasSpeech;
      });
    } catch (e) {
      print('Speech recognition failed: ${e.toString()}');
      setState(() {
        _sttHasSpeech = false;
      });
    }
  }

  initTts() async {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        //print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        //print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        //print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          //print("Paused");
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
          //print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        //print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }


  Future<void> initChatBot() async {
    _startTime = new DateTime.now();
    await sendChatMessage(false, 'Bot', [TextSpan(text: '測驗即將開始\n請跟著我重複一次')], needSpeak:true, speakMessage:'Quiz is about to start. Please repeat after me', speakLanguage:'en-US');
    await sendNextQuestion();
  }

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
    //print('Result listener $sttResultListened');
    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
    //print(sttLastWords);
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
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    //print('Received listener status: $status, listening: ${speechToText.isListening}');
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
    //print(selectedVal);
  }



  /* tts 相關 */
  Future<dynamic> _getLanguages() => flutterTts.getLanguages;

  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      //print(engine);
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
      changeColor: _changeColor,
      senderIsMe: senderIsMe,
      senderName: senderName,
      messageTextWidget: messageTextWidget,
      actionButton:
      (canSpeak)
          ? IconButton(
        icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined),
        color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.black : Colors.grey ,
        onPressed: () async {
          /*if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
            ttsRateSlow = !ttsRateSlow;
            await _ttsSpeak(speakMessage, speakLanguage);
          }*/
          _handleSubmitted('A test content', isFinalResult:false);
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

  void _handleSubmitted(String text,{bool isFinalResult:false}) {
    setState(() {
      _answerText = text;
    });

    if(_answerText != '' && isFinalResult){
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
    String checkSentencesJSON = await APIUtil.checkSentences(_contentList[_part - 1], text, correctCombo:_correctCombo);
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

      questionTextWidget.add(
          TextSpan(text: '\n[${_ipaList[_part - 1]}]',style: TextStyle(color: Colors.black.withOpacity(0.5)))
      );
      if(_mainCheckList[_part - 1])
        questionTextWidget.add(
            TextSpan(text: '\n${_translateList[_sentenceCounter - 1]}')
        );
      questionTextWidget.add(
          TextSpan(text: '\n${_idList[_sentenceCounter - 1]} / ${_sentenceCounter} of ${_sentenceTotal} / ${_chunksCounter} of ${_chunksTotal[_sentenceCounter - 1]}',style: TextStyle(color: Colors.black.withOpacity(0.5)))
      );
      questionTextWidget.add(
          TextSpan(text: '\n原句:${_oriLIst[_part-1]}',style: TextStyle(color: Colors.black.withOpacity(0.5)))
      );

      message = ChatMessageUtil(
        changeColor: _changeColor,
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
      _finishQuizData['sentenceAnswerArray']!.add(checkSentences['data']['answerText']);
      _finishQuizData['scoreArray']!.add(checkSentences['data']['scoreComment']['score']);
      _finishQuizData['userAnswerRate']!.add(checkSentences['data']['answerText'].split(' ').length / _finishQuizData['secondsArray']![_part - 1]);
      //print(_finishQuizData);
      await sendChatMessage(false, 'Bot', [TextSpan(text: '${checkSentences['data']['scoreComment']['text']} ${checkSentences['data']['scoreComment']['emoji']}\n您花 ${_finishQuizData['secondsArray']![_part - 1].toString()} 秒（${_finishQuizData['userAnswerRate']![_part - 1].toStringAsFixed(2)}wps）回答')], needSpeak:true, speakMessage:checkSentences['data']['scoreComment']['text'].toLowerCase(), speakLanguage:'en-US');
      await sendNextQuestion();
    } else {
      //print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      await Future.delayed(Duration(seconds: 1));
      _responseChatBot(text);
    }
  }


  Future<void> sendNextQuestion() async {
    await Future.delayed(Duration(milliseconds: 780));
    _part++;
    if(_part % 2 == 1) _changeColor = true; else _changeColor = false;
    if( _part > _contentList.length){
      var _endTime = DateTime.now();
      await sendChatMessage(false, 'Bot', [TextSpan(text: '測驗結束')], needSpeak:true, speakMessage:'Quiz is over', speakLanguage:'en-US');
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
    } else {
      /*if(_mainCheckList[_part -1])
        {
          mainCheckIndex++;
        }*/
      if(_part != 1 && _oriLIst[_part - 1] != _oriLIst[_part - 2]){
        _chunksCounter = 1;
        _sentenceCounter++;
      }else{
        _chunksCounter++;
      }
      //_questionStart = DateTime.now();
      List<TextSpan> questionTextWidget = [];
      questionTextWidget.add(
          TextSpan(text: '${_contentList[_part - 1]}')
      );

      questionTextWidget.add(
          TextSpan(text: '\n[${_ipaList[_part - 1]}]',style: TextStyle(color: Colors.black.withOpacity(0.5)))
      );
      if(_mainCheckList[_part - 1])
        questionTextWidget.add(
            TextSpan(text: '\n${_translateList[_sentenceCounter - 1]}')
        );
      questionTextWidget.add(
          TextSpan(text: '\n${_idList[_sentenceCounter - 1]} / ${_sentenceCounter} of ${_sentenceTotal} / ${_chunksCounter} of ${_chunksTotal[_sentenceCounter - 1]}',style: TextStyle(color: Colors.black.withOpacity(0.5)))
      );
      questionTextWidget.add(
          TextSpan(text: '\n原句:${_oriLIst[_part-1]}',style: TextStyle(color: Colors.black.withOpacity(0.5)))
      );
      await sendChatMessage(false, 'Bot', questionTextWidget, needSpeak:true, canSpeak:true, speakMessage:_contentList[_part - 1], speakLanguage:'en-US');
      //${_questionsData[_part - 1]['sentenceChinese']}
      //_questionEnd = DateTime.now();
      //var questionSecond = _questionEnd.difference(_questionStart).inSecond;
      //await sendChatMessage(false, 'Bot', [TextSpan(text: '${questionSecond}')]);
      //await sendChatMessage(false, 'Bot', [TextSpan(text: 'The number of seconds in the sentence is: ${ttsRate}')], needSpeak:false, speakMessage:'', speakLanguage: 'en-US');
      await Future.delayed(Duration(milliseconds: (_part / _contentList.length * 2340).round()));
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

class CustomAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          //overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 550,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: Column(
                  children: [
                    Text(
                      'Alicsnet App 精簡版',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '此功能由系統朗讀，使用者複誦作為主要訓練英語方式。',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Divider(color: Colors.black54,thickness: 1,),
                    SizedBox(
                      height: 5,
                    ),
                    Text.rich(
                      TextSpan(
                        text: '題目介面說明如下:\n',
                        style: TextStyle(color: Colors.black54,height: 1.5),
                        children: [
                          TextSpan(text: '◎ the go\n',style: TextStyle(height: 2,color: Colors.black)),
                          TextSpan(text: '↑ 切塊或句子內容(你需要複誦這個部分)\n',style: TextStyle(height: 1.5)),
                          TextSpan(text: '◎ 如果該題為句子，這裡或會出現中文翻譯\n',style: TextStyle(height: 1.5,color: Colors.black)),
                          TextSpan(text: '◎ [ðə goʊ]\n',style: TextStyle(height: 1.5,color: Colors.black)),
                          TextSpan(text: '↑ 切塊或句子音標\n',style: TextStyle(height: 1.5)),
                          TextSpan(text: '◎ 197786 / 1 of 1 / 1 of 3\n',style: TextStyle(height: 1.5,color: Colors.black)),
                          TextSpan(text: '↑ 句子ID / 當前第幾句 of 總句子數量 / 當前句子切塊數量 of 當前句子總切塊數量\n',style: TextStyle(height: 1.5)),
                          TextSpan(text: "◎ 原句:I'm on the go\n",style: TextStyle(height: 1.5,color: Colors.black)),
                          TextSpan(text: '↑ 該切片的原始句子\n',style: TextStyle(height: 1.5)),
                        ],
                      ),
                    ),
                    ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child:Text('OK'),style: ElevatedButton.styleFrom(primary: PageTheme.cutom_article_practice_background),)
                  ],
                ),
              ),
            ),
            Positioned(
                top: -30,
                child: CircleAvatar(
                  backgroundColor: PageTheme.cutom_article_practice_background,
                  radius: 30,
                  child: Icon(
                    Icons.question_mark,
                    color: Colors.white,
                    size: 18,
                  ),
                )),
          ],
        ));
  }
}
