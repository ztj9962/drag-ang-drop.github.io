import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/chat_message_util.dart';
import 'package:alicsnet_app/util/chat_topic_message_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:wakelock/wakelock.dart';

class LearningAutoChatTopicPage extends StatefulWidget {
  final List<List<String>> contentList;

  //final List<String> ipaList;
  final List<List<String>> translateList;
  final String title;
  final String subtitle;
  final List<List<String>> speakerList;
  final List<List<String>> orderList;

  const LearningAutoChatTopicPage(
      {Key? key,
      required this.contentList,
      //required this.ipaList,
      required this.translateList,
      required this.title,
      required this.speakerList,
      required this.subtitle,
      required this.orderList})
      : super(key: key);

  @override
  _LearningAutoChatTopicPage createState() => _LearningAutoChatTopicPage();
}

enum TtsState { playing, stopped, paused, continued }

class _LearningAutoChatTopicPage extends State<LearningAutoChatTopicPage> {
  late List<List<String>> _contentList;

  //late List<String> _ipaList;
  late List<List<String>> _translateList;
  late List<List<String>> _speakerList;
  late List<List<String>> _orderList;
  late String _title;
  late String _subtitle;

  final audioPlayer = AudioPlayer();

  int _part = 0;
  int _topicPart = 0;
  List<Widget> _messages = <Widget>[];

  ScrollController sc = ScrollController();

  String _answerText = '';
  var _allowTouchButtons = {
    'reListenButton': false,
    'speakButton': false,
    'pauseButton': true,
  };
  int _correctCombo = 0;
  Map _summaryReportData = {
    'ttsRateString': '',
    'startTime': '',
    'sentenceQuestionArray': <String>[],
    'sentenceQuestionIPAArray': <String>[],
    'sentenceQuestionErrorArray': <List<String>>[],
    'sentenceQuestionChineseArray': <String>[],
    'sentenceAnswerArray': <String>[],
    'sentenceAnswerIPAArray': <String>[],
    'sentenceAnswerErrorArray': <List<String>>[],
    'scoreArray': <int>[],
    'secondsArray': <int>[],
    'userAnswerRate': <double>[],
    'endTime': '',
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
    //_ipaList = widget.ipaList;
    _translateList = widget.translateList;
    _title = widget.title;
    _speakerList = widget.speakerList;
    _subtitle = widget.subtitle;
    _orderList = widget.orderList;
    super.initState();
    initLearningAutoGenericPage();
    print(_contentList);
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
          centerTitle: true,
          backgroundColor: PageTheme.app_theme_black,
          title: Row(
            children: <Widget>[
              Expanded(
                child: AutoSizeText(
                  _subtitle,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              child: ListView.builder(
                controller: sc,
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Divider(
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
                        Text('語速：'),
                        DropdownButton(
                          value: (isWeb) ? ttsRate / 2.0 : ttsRate,
                          disabledHint: Text(ttsRateString),
                          items: [
                            DropdownMenuItem(
                                child: Text('0.25倍'), value: 0.125),
                            DropdownMenuItem(child: Text('0.5倍'), value: 0.25),
                            DropdownMenuItem(child: Text('一般'), value: 0.5),
                            DropdownMenuItem(
                                child: Text('1.25倍'), value: 0.625),
                            DropdownMenuItem(child: Text('1.5倍'), value: 0.75),
                            DropdownMenuItem(
                                child: Text('1.75倍'), value: 0.875),
                            DropdownMenuItem(child: Text('2倍'), value: 1.0),
                          ],
                          onChanged: (_allowTouchButtons['speakButton']! &&
                                  !isPlaying)
                              ? (value) {
                                  setState(() {
                                    ttsRateSlow = true;
                                  });
                                  SharedPreferencesUtil.setTTSRate(
                                      double.parse(value.toString()));
                                  SharedPreferencesUtil.getTTSRate()
                                      .then((newTTSRate) {
                                    setState(() => ttsRate = newTTSRate);
                                    print('newTTSRate: $newTTSRate');
                                  });
                                  SharedPreferencesUtil.getTTSRateString()
                                      .then((newTTSRateString) {
                                    setState(
                                        () => ttsRateString = newTTSRateString);
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        if (_part <= _contentList[_topicPart].length) ...[
                          Expanded(
                            flex: 2,
                            child: SvgPicture.asset('assets/icon/audio.svg'),
                          ),
                        ] else ...[
                          Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              backgroundColor: PageTheme.app_theme_blue,
                              radius: 40.0,
                              child: IconButton(
                                icon: Icon(Icons.restart_alt, size: 30),
                                color: Colors.white,
                                onPressed: () {
                                  initChatBot();
                                },
                              ),
                            ),
                          ),
                        ],
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            backgroundColor: PageTheme.app_theme_blue,
                            radius: 40.0,
                            child: IconButton(
                              icon: Icon(
                                  (_allowTouchButtons['speakButton']! &&
                                          !isPlaying)
                                      ? (speechToText.isListening
                                          ? Icons.stop
                                          : Icons.mic_none)
                                      : Icons.mic_off_outlined,
                                  size: 30),
                              color: (_allowTouchButtons['speakButton']! &&
                                      !isPlaying)
                                  ? Colors.white
                                  : Colors.grey,
                              onPressed: () {
                                if (_allowTouchButtons['speakButton']! &&
                                    !isPlaying) {
                                  if (!_sttHasSpeech ||
                                      speechToText.isListening) {
                                    sttStopListening();
                                  } else {
                                    sttStartListening();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        if (_part <= _contentList[_topicPart].length) ...[
                          Expanded(
                            flex: 2,
                            child: SvgPicture.asset('assets/icon/audio.svg'),
                          ),
                        ] else ...[
                          Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              backgroundColor: PageTheme.app_theme_blue,
                              radius: 40.0,
                              child: IconButton(
                                icon: Icon(Icons.summarize, size: 30),
                                color: Colors.white,
                                onPressed: () {
                                  AutoRouter.of(context).push(
                                      LearningAutoGenericSummaryReportRoute(
                                          summaryReportData:
                                              _summaryReportData));
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  /*
  initState() 初始化相關
   */

  initLearningAutoGenericPage() async {
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
    });
    SharedPreferencesUtil.getTTSRateString().then((value) {
      setState(() => ttsRateString = value);
    });

    /*
    SharedPreferencesUtil.getData<String>('applicationSettingsDataUUID').then((value) {
      setState(() => _applicationSettingsDataUUID = value!);
    });
    SharedPreferencesUtil.getData<String>('applicationSettingsDataListenAndSpeakLevel').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakLevel = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataListenAndSpeakRanking').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakRanking = value!);
    });

     */
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
    // 清空紀錄
    _messages = [];
    _part = 0;
    _summaryReportData = {
      'ttsRateString': '',
      'startTime': '',
      'sentenceQuestionArray': <String>[],
      'sentenceQuestionIPAArray': <String>[],
      'sentenceQuestionErrorArray': <List<String>>[],
      'sentenceQuestionChineseArray': <String>[],
      'sentenceAnswerArray': <String>[],
      'sentenceAnswerIPAArray': <String>[],
      'sentenceAnswerErrorArray': <List<String>>[],
      'scoreArray': <int>[],
      'secondsArray': <int>[],
      'userAnswerRate': <double>[],
      'endTime': '',
    };

    // 設定聊天機器人
    _summaryReportData['startTime'] =
        DateTime.now().toString().substring(0, 19);
    await sendChatMessage(
        false, 'Bot', [TextSpan(text: '情境對話即將開始\n請跟著我重複一次下列發光對話')],
        needSpeak: true,
        speakMessage:
            'Topic conversation is about to start. Please repeat the following highlighted conversation with me',
        speakLanguage: 'en-US');

    await initConversation();

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
    if(isWeb){
      print('m4r');
      await audioPlayer.setFilePath('assets/assets/sounds/speech_to_text_listening.m4r');
      audioPlayer.play();
    }
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
    if(isWeb && sttResultListened <= 1){
      audioPlayer.setFilePath('assets/assets/sounds/speech_to_text_stop.m4r');
      audioPlayer.play();
    }
    //print('Result listener $sttResultListened');
    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
    //print(sttLastWords);
    _handleSubmitted(result.recognizedWords, isFinalResult: result.finalResult);
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
    if (ttsRateSlow) {
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

  Future sendChatMessage(
      bool senderIsMe, String senderName, List<TextSpan> messageTextWidget,
      {bool needSpeak: false,
      bool canSpeak: false,
      bool secondaryTheme: false,
      String speakMessage: '',
      String speakLanguage: 'en-US',
      bool usePrefix = false,
      String prefix = '',
      int insertIndex = 0,
      bool highlighted = false,
      String commentary = '',
      bool useTopicUtil = false}) async {
    if (useTopicUtil) {
      ChatTopicMessageUtil message = ChatTopicMessageUtil(
        commentary: commentary,
        senderIsMe: senderIsMe,
        senderName: senderName,
        messageTextWidget: messageTextWidget,
        usePrefix: usePrefix,
        prefix: prefix,
        highlighted: highlighted,
        secondaryTheme: secondaryTheme,
        actionButton: (canSpeak)
            ? IconButton(
                icon: Icon((_allowTouchButtons['reListenButton']! &&
                        !speechToText.isListening)
                    ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined)
                    : Icons.volume_off_outlined),
                color: (_allowTouchButtons['reListenButton']! &&
                        !speechToText.isListening)
                    ? Colors.black
                    : Colors.grey,
                onPressed: () async {
                  print(_allowTouchButtons['reListenButton']! &&
                      !speechToText.isListening);
                  if (_allowTouchButtons['reListenButton']! &&
                      !speechToText.isListening) {
                    ttsRateSlow = !ttsRateSlow;
                    await _ttsSpeak(speakMessage, speakLanguage);
                  }
                },
              )
            : (!senderIsMe)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.volume_off_outlined),
                  )
                : null,
      );
      setState(() {
        _messages.insert(insertIndex, message);
      });

      if (needSpeak) {
        await _ttsSpeak(speakMessage, speakLanguage);
      }
    } else {
      ChatMessageUtil message = ChatMessageUtil(
        senderIsMe: senderIsMe,
        senderName: senderName,
        messageTextWidget: messageTextWidget,
        actionButton: (canSpeak)
            ? IconButton(
                icon: Icon((_allowTouchButtons['reListenButton']! &&
                        !speechToText.isListening)
                    ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined)
                    : Icons.volume_off_outlined),
                color: (_allowTouchButtons['reListenButton']! &&
                        !speechToText.isListening)
                    ? Colors.black
                    : Colors.grey,
                onPressed: () async {
                  if (_allowTouchButtons['reListenButton']! &&
                      !speechToText.isListening) {
                    ttsRateSlow = !ttsRateSlow;
                    await _ttsSpeak(speakMessage, speakLanguage);
                  }
                },
              )
            : null,
      );
      setState(() {
        _messages.insert(insertIndex, message);
      });

      if (needSpeak) {
        await _ttsSpeak(speakMessage, speakLanguage);
      }
    }
  }

  void _handleSubmitted(String text, {bool isFinalResult: false}) {
    setState(() {
      _answerText = text;
    });

    if (_answerText != '' && isFinalResult) {
      sendChatMessage(true, 'Me', [TextSpan(text: text)],
          insertIndex: _contentList[_topicPart].length - _part,
          useTopicUtil: true,
          canSpeak: false);
      _summaryReportData['secondsArray']!.add(_answerSeconds);

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
    sttResultListened = 0;
    String checkSentencesJSON = await APIUtil.checkSentences(
        _contentList[_topicPart][_part - 1], text,
        correctCombo: _correctCombo);

    var checkSentences = jsonDecode(checkSentencesJSON.toString());
    //print(checkSentencesJSON.toString());

    if (checkSentences['apiStatus'] == 'success') {
      if (checkSentences['data']['ipaTextSimilarity'] == 100) {
        _correctCombo++;
      } else {
        _correctCombo = 0;
      }

      ChatTopicMessageUtil message;

      var questionTextArray = checkSentences['data']['questionText'].split(' ');
      List<TextSpan> questionTextWidget = [];
      for (var i = 0; i < questionTextArray.length; i++) {
        if (checkSentences['data']['questionError']
            .containsKey(questionTextArray[i])) {
          questionTextWidget.add(TextSpan(
            text: questionTextArray[i] + ' ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ));
        } else {
          if (i < questionTextArray.length)
            questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' '));
        }
      }

      ///回答之後的部分

      //questionTextWidget.add(TextSpan(text: '\n[${_ipaList[_part - 1]}]'));

      questionTextWidget
          .add(TextSpan(text: '\n${_translateList[_topicPart][_part - 1]}'));

      //questionTextWidget.add(TextSpan(text: '\n${_part}/${_contentList.length}'));

      //questionTextWidget.add(TextSpan(text: '\n${checkSentences['data']['answerText']}'));
      message = ChatTopicMessageUtil(
        senderIsMe: false,
        senderName: _speakerList[_topicPart][_part - 1],
        messageTextWidget: questionTextWidget,
        usePrefix: true,
        secondaryTheme: (_speakerList[_topicPart][_part - 1] != 'P1'),
        prefix: (int.parse(_orderList[_topicPart][_part - 1])).toString(),
        actionButton: IconButton(
          icon: Icon((_allowTouchButtons['reListenButton']! &&
                  !speechToText.isListening)
              ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined)
              : Icons.volume_off_outlined),
          color: (_allowTouchButtons['reListenButton']! &&
                  !speechToText.isListening)
              ? Colors.black
              : Colors.grey,
          onPressed: () async {
            if (_allowTouchButtons['reListenButton']! &&
                !speechToText.isListening) {
              ttsRateSlow = !ttsRateSlow;
              await _ttsSpeak(checkSentences['data']['questionText'], "en-US");
            }
          },
        ),
      );
      setState(() {
        _messages[_contentList[_topicPart].length - _part + 1] = message;
      });
      //print(_contentList.length-_part+1);
      var answerTextArray = checkSentences['data']['answerText'].split(' ');
      List<TextSpan> answerTextWidget = [];

      for (var i = 0; i < answerTextArray.length; i++) {
        if (checkSentences['data']['answerError']
            .containsKey(answerTextArray[i])) {
          answerTextWidget.add(TextSpan(
            text: answerTextArray[i] + ' ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ));
        } else {
          answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' '));
        }
      }

      _summaryReportData['sentenceQuestionArray']!
          .add(checkSentences['data']['questionText']);
      _summaryReportData['sentenceQuestionIPAArray']!
          .add(checkSentences['data']['questionIPAText']);
      _summaryReportData['sentenceQuestionErrorArray']!
          .add(checkSentences['data']['questionError'].keys.toList());
      _summaryReportData['sentenceQuestionChineseArray']!
          .add(_translateList[_topicPart][_part - 1]);
      _summaryReportData['sentenceAnswerArray']!
          .add(checkSentences['data']['answerText']);
      _summaryReportData['sentenceAnswerIPAArray']!
          .add(checkSentences['data']['answerIPAText']);
      _summaryReportData['sentenceAnswerErrorArray']!
          .add(checkSentences['data']['answerError'].keys.toList());
      _summaryReportData['scoreArray']!
          .add(checkSentences['data']['scoreComment']['score']);
      _summaryReportData['userAnswerRate']!.add(
          checkSentences['data']['answerText'].split(' ').length /
              _summaryReportData['secondsArray']![_part - 1]);

      ///指出使用者錯誤與評語
      ChatTopicMessageUtil messageMe = ChatTopicMessageUtil(
        senderIsMe: true,
        senderName: 'Me',
        commentary:
            '${checkSentences['data']['scoreComment']['text']} ${checkSentences['data']['scoreComment']['emoji']} 您花 ${_summaryReportData['secondsArray']![_part - 1].toString()} 秒（${_summaryReportData['userAnswerRate']![_part - 1].toStringAsFixed(2)}wps）回答',
        messageTextWidget: answerTextWidget,
      );

      await _ttsSpeak(checkSentences['data']['scoreComment']['text'], 'en');

      setState(() {
        _messages[_contentList[_topicPart].length - _part] = messageMe;
        _answerText = '';
      });

      ///發送評論
      //print(_summaryReportData);
      /*await sendChatMessage(
          false,'Person A',
          [TextSpan(text:'${checkSentences['data']['scoreComment']['text']} ${checkSentences['data']['scoreComment']['emoji']}\n您花 ${_summaryReportData['secondsArray']![_part - 1].toString()} 秒（${_summaryReportData['userAnswerRate']![_part - 1].toStringAsFixed(2)}wps）回答')],
          needSpeak: true,
          speakMessage:checkSentences['data']['scoreComment']['text'].toLowerCase(),
          speakLanguage: 'en-US');*/
      await sendNextQuestion();
    } else {
      //print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      await Future.delayed(Duration(seconds: 1));
      _responseChatBot(text);
    }
  }

  _showToast(String show) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(show),
        ],
      ),
    );

    /*fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );*/

    // Custom Toast Position
    /*fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });*/
  }

  Future<void> sendNextQuestion() async {
    await Future.delayed(Duration(milliseconds: 780));
    _part++;
    if (_part > _contentList[_topicPart].length &&
        _topicPart == _contentList.length - 1) {
      print('fin');
      // 如果完成所有題目
      _summaryReportData['ttsRateString'] = ttsRateString;
      _summaryReportData['endTime'] =
          DateTime.now().toString().substring(0, 19);
      await sendChatMessage(
          false, 'Bot', [TextSpan(text: '測驗結束。如果您想查看詳細測驗資訊，請點擊右下方的報表按鈕。')],
          needSpeak: true,
          speakMessage:
              'Quiz is over. If you want to view detailed quiz information, please click the report button at the bottom right.',
          speakLanguage: 'en-US');
    } else if (_part > _contentList[_topicPart].length) {
      ///完成一個conversation
      ///
      _part = 0;
      _topicPart++;
      /*await sendChatMessage(
          false, 'Bot', [TextSpan(text: '下一個對話:${_topicPart+1} / ${_contentList.length}')],
          needSpeak: true,
          speakMessage:
          'You Complete this conversation, next conversation.',
          speakLanguage: 'en-US');*/

      await initConversation();

      await sendNextQuestion();

      await highlightQuestion();

      //await _ttsSpeak(_contentList[_topicPart][_part - 1], 'en-US');
    } else {
      ///一開始丟題目出來
      sc.jumpTo((_contentList[_topicPart].length - _part) * 100);
      await highlightQuestion();
      if (_speakerList[_topicPart][_part - 1] == 'P1') {
        ttsPitch = 0.5;
      } else {
        ttsPitch = 1.2;
      }
      await _ttsSpeak(_contentList[_topicPart][_part - 1], 'en-US');
      await Future.delayed(Duration(
          milliseconds:
              (_part / _contentList[_topicPart].length * 2360).round()));
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

  Future<void> initConversation() async {
    //await Future.delayed(Duration(milliseconds: 780));
    for (int i = 0; i < _contentList[_topicPart].length; i++) {
      List<TextSpan> questionTextWidget = [];

      questionTextWidget.add(TextSpan(text: '${_contentList[_topicPart][i]}'));

      questionTextWidget
          .add(TextSpan(text: '\n${_translateList[_topicPart][i]}'));

      await sendChatMessage(
          false, _speakerList[_topicPart][i], questionTextWidget,
          useTopicUtil: true,
          needSpeak: false,
          usePrefix: true,
          canSpeak: false,
          secondaryTheme: (_speakerList[_topicPart][i] != 'P1'),
          prefix: _orderList[_topicPart][i],
          speakMessage: '',
          speakLanguage: 'en-US');
      setState(() {
        /*
        _messages.insert(0,
          Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon((_allowTouchButtons['reListenButton']! &&
                        !speechToText.isListening)
                        ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined)
                        : Icons.volume_off_outlined),
                    color: (_allowTouchButtons['reListenButton']! &&
                        !speechToText.isListening)
                        ? Colors.black
                        : Colors.grey,
                    onPressed: () async {
                      if (_allowTouchButtons['reListenButton']! &&
                          !speechToText.isListening) {
                        ttsRateSlow = !ttsRateSlow;
                        //await _ttsSpeak(checkSentences['data']['questionText'], "en-US");
                      }
                    },
                  ),
                  AutoSizeText(_contentList[_topicPart][i]),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(),
              shape: BoxShape.rectangle, // 矩形
              borderRadius: new BorderRadius.circular(
                  (20.0)), // 圓角度
            ),
          ),
        );*/
      });
    }
    sc.jumpTo(1000);
  }

  Future<void> highlightQuestion() async {
    //await Future.delayed(Duration(milliseconds: 780));
    List<TextSpan> questionTextWidget = [];

    questionTextWidget
        .add(TextSpan(text: '${_contentList[_topicPart][_part - 1]}'));

    questionTextWidget
        .add(TextSpan(text: '\n${_translateList[_topicPart][_part - 1]}'));

    ChatTopicMessageUtil message;

    message = ChatTopicMessageUtil(
      senderIsMe: false,
      senderName: _speakerList[_topicPart][_part - 1],
      messageTextWidget: questionTextWidget,
      usePrefix: true,
      highlighted: true,
      secondaryTheme: (_speakerList[_topicPart][_part - 1] != 'P1'),
      prefix: (int.parse(_orderList[_topicPart][_part - 1])).toString(),
      actionButton: IconButton(
        icon: Icon(
            (_allowTouchButtons['reListenButton']! && !speechToText.isListening)
                ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined)
                : Icons.volume_up),
        color:
            (_allowTouchButtons['reListenButton']! && !speechToText.isListening)
                ? Colors.black
                : Colors.grey,
        onPressed: () async {
          if (_allowTouchButtons['reListenButton']! &&
              !speechToText.isListening) {
            ttsRateSlow = !ttsRateSlow;
            await _ttsSpeak(_contentList[_topicPart][_part - 1], "en-US");
          }
        },
      ),
    );

    setState(() {
      _messages[_contentList[_topicPart].length - _part] = message;
    });
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
