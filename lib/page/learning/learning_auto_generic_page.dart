import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
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

class LearningAutoGenericPage extends StatefulWidget {
  final List<String> contentList;
  final List<String> ipaList;
  final List<String> translateList;

  const LearningAutoGenericPage(
      {Key? key,
      required this.contentList,
      required this.ipaList,
      required this.translateList})
      : super(key: key);

  @override
  _LearningAutoGenericPage createState() => _LearningAutoGenericPage();
}

enum TtsState { playing, stopped, paused, continued }

class _LearningAutoGenericPage extends State<LearningAutoGenericPage> {
  late List<String> _contentList;
  late List<String> _ipaList;
  late List<String> _translateList;

  int _part = 0;
  List<Widget> _messages = <Widget>[];

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
    _ipaList = widget.ipaList;
    _translateList = widget.translateList;
    super.initState();
    initLearningAutoGenericPage();
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
        body: Column(children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              child: ListView.builder(
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
                            SharedPreferencesUtil.getTTSRateString()
                                .then((value) {
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
                  flex: 2,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        if (_part <= _contentList.length) ...[
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
                        if (_part <= _contentList.length) ...[
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
      print('update iiiiiii' + value.toString());
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
    await sendChatMessage(false, 'Bot', [TextSpan(text: '測驗即將開始\n請跟著我重複一次')],
        needSpeak: true,
        speakMessage: 'Quiz is about to start. Please repeat after me',
        speakLanguage: 'en-US');
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
      String speakMessage: '',
      String speakLanguage: 'en-US'}) async {
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
      _messages.insert(0, message);
    });

    if (needSpeak) {
      await _ttsSpeak(speakMessage, speakLanguage);
    }
  }

  void _handleSubmitted(String text, {bool isFinalResult: false}) {
    setState(() {
      _answerText = text;
    });

    if (_answerText != '' && isFinalResult) {
      sendChatMessage(true, 'Me', [TextSpan(text: text)]);
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
    String checkSentencesJSON = await APIUtil.checkSentences(
        _contentList[_part - 1], text,
        correctCombo: _correctCombo);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());
    //print(checkSentencesJSON.toString());

    if (checkSentences['apiStatus'] == 'success') {
      if (checkSentences['data']['ipaTextSimilarity'] == 100) {
        _correctCombo++;
      } else {
        _correctCombo = 0;
      }

      ChatMessageUtil message;

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
      /*
      questionTextWidget.add(
          TextSpan(text: '\n[${_ipaList[_part - 1]}]')
      );
      */
      questionTextWidget.add(TextSpan(text: '\n${_translateList[_part - 1]}'));
      questionTextWidget
          .add(TextSpan(text: '\n${_part}/${_contentList.length}'));

      message = ChatMessageUtil(
        senderIsMe: false,
        senderName: 'Bot',
        messageTextWidget: questionTextWidget,
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
        _messages[1] = message;
      });

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

      message = ChatMessageUtil(
        senderIsMe: true,
        senderName: 'Me',
        messageTextWidget: answerTextWidget,
      );
      setState(() {
        _messages[0] = message;
        _answerText = '';
      });
      _summaryReportData['sentenceQuestionArray']!
          .add(checkSentences['data']['questionText']);
      _summaryReportData['sentenceQuestionIPAArray']!
          .add(checkSentences['data']['questionIPAText']);
      _summaryReportData['sentenceQuestionErrorArray']!
          .add(checkSentences['data']['questionError'].keys.toList());
      _summaryReportData['sentenceQuestionChineseArray']!
          .add(_translateList[_part - 1]);
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
      //print(_summaryReportData);
      await sendChatMessage(
          false,
          'Bot',
          [
            TextSpan(
                text:
                    '${checkSentences['data']['scoreComment']['text']} ${checkSentences['data']['scoreComment']['emoji']}\n您花 ${_summaryReportData['secondsArray']![_part - 1].toString()} 秒（${_summaryReportData['userAnswerRate']![_part - 1].toStringAsFixed(2)}wps）回答')
          ],
          needSpeak: true,
          speakMessage:
              checkSentences['data']['scoreComment']['text'].toLowerCase(),
          speakLanguage: 'en-US');
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
    if (_part > _contentList.length) {
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
    } else {
      //_questionStart = DateTime.now();
      List<TextSpan> questionTextWidget = [];
      questionTextWidget.add(TextSpan(text: '${_contentList[_part - 1]}'));
      /*
      questionTextWidget.add(
          TextSpan(text: '\n[${_ipaList[_part - 1]}]')
      );
       */
      questionTextWidget.add(TextSpan(text: '\n${_translateList[_part - 1]}'));
      questionTextWidget
          .add(TextSpan(text: '\n${_part}/${_contentList.length}'));
      await sendChatMessage(false, 'Bot', questionTextWidget,
          needSpeak: true,
          canSpeak: true,
          speakMessage: _contentList[_part - 1],
          speakLanguage: 'en-US');
      //${_questionsData[_part - 1]['sentenceChinese']}
      //_questionEnd = DateTime.now();
      //var questionSecond = _questionEnd.difference(_questionStart).inSecond;
      //await sendChatMessage(false, 'Bot', [TextSpan(text: '${questionSecond}')]);
      //await sendChatMessage(false, 'Bot', [TextSpan(text: 'The number of seconds in the sentence is: ${ttsRate}')], needSpeak:false, speakMessage:'', speakLanguage: 'en-US');
      await Future.delayed(
          Duration(milliseconds: (_part / _contentList.length * 2340).round()));
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
