import 'dart:convert';
import 'dart:math';

import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:io';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_tts/flutter_tts.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class LearningManualContractionPage extends StatefulWidget {
  final List<String> getPairContraction;
  final List<String> getPairFullForm;
  final List<String> getPracticeContraction;
  final List<String> getPracticeContractionIPA;
  final List<String> getPracticeFullForm;
  final List<String> getPracticeSentence;
  final List<String> getPracticeSentenceIPA;

  const LearningManualContractionPage({
    Key? key,
    required this.getPairContraction,
    required this.getPairFullForm,
    required this.getPracticeContraction,
    required this.getPracticeContractionIPA,
    required this.getPracticeFullForm,
    required this.getPracticeSentence,
    required this.getPracticeSentenceIPA,
  }) : super(key: key);

  @override
  _LearningManualContractionPage createState() =>
      _LearningManualContractionPage();
}

enum TtsState { playing, stopped, paused, continued }

class _LearningManualContractionPage
    extends State<LearningManualContractionPage> {
  late List<String> _getPairContraction;
  late List<String> _getPairFullForm;
  late List<String> _getPracticeContraction;
  late List<String> _getPracticeContractionIPA;
  late List<String> _getPracticeFullForm;
  late List<String> _getPracticeSentence;
  late List<String> _getPracticeSentenceIPA;
  int _testIndex = 0;
  int _testListIndex = 0;
  int _testPracticeListIndex = 0;

  final _allowTouchButtons = {
    'reListenButton': false,
    'speakButton': false,
    'nextButton': true,
  };

  String _questionText = '';
  String _questionIPAText = '';
  String _replyText = '';
  String _answerText = '';
  String _answerIPAText = '';
  List<TextSpan> _questionTextWidget = [
    const TextSpan(text: ''),
  ];
  List<TextSpan> _questionIPATextWidget = [
    const TextSpan(text: ''),
  ];
  List<TextSpan> _questionChineseWidget = [
    const TextSpan(text: ''),
  ];
  List<TextSpan> _replyTextWidget = [
    const TextSpan(text: ''),
  ];
  List<TextSpan> _answerTextWidget = [
    const TextSpan(text: ""),
  ];
  List<TextSpan> _answerIPATextWidget = [
    const TextSpan(text: ''),
  ];
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
  late double ttsRate;
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
    _getPairContraction = widget.getPairContraction;
    _getPairFullForm = widget.getPairFullForm;
    _getPracticeContraction = widget.getPracticeContraction;
    _getPracticeContractionIPA = widget.getPracticeContractionIPA;
    _getPracticeFullForm = widget.getPracticeFullForm;
    _getPracticeSentence = widget.getPracticeSentence;
    _getPracticeSentenceIPA = widget.getPracticeSentenceIPA;
    print(_getPracticeSentence);
    super.initState();
    initLearningManualMinimalPairContractionPage();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    speechToText.stop();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PageTheme.app_theme_black,
        title: AutoSizeText(
          '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 3.0,
            color: Color(0xFFFEFEFE),
          ),
          maxLines: 1,
        ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Visibility(
                                  visible: _testListIndex != 0,
                                  child: IconButton(
                                      icon: const Icon(Icons.navigate_before),
                                      color: Colors.black,
                                      onPressed: () async {
                                        setState(() {
                                          _testListIndex -= 1;
                                          _testPracticeListIndex =
                                              _getPracticeFullForm.indexWhere(
                                                  (note) => note.startsWith(
                                                      _getPairFullForm[
                                                          _testListIndex]));
                                          _testIndex = _testPracticeListIndex;
                                        });
                                        _ttsStop();
                                        sttStopListening();
                                        getPracticeWord();
                                      }),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.volume_up),
                                      color: Colors.black,
                                      onPressed: () async {
                                        ttsRateSlow = !ttsRateSlow;
                                        await _ttsSpeak(
                                            _getPracticeContraction[_testIndex],
                                            'en-US');
                                      },
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          _getPracticeContraction[_testIndex],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '[' +
                                              _getPracticeContractionIPA[
                                                  _testIndex] +
                                              ']',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          _getPracticeFullForm[_testIndex],
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ],
                                ))),
                            Expanded(
                                flex: 1,
                                child: Visibility(
                                  visible: _testListIndex <
                                      _getPairFullForm.length - 1,
                                  child: IconButton(
                                      icon: const Icon(Icons.navigate_next),
                                      color: Colors.black,
                                      onPressed: () async {
                                        setState(() {
                                          _testListIndex += 1;
                                          _testPracticeListIndex =
                                              _getPracticeFullForm.indexWhere(
                                                  (note) => note.startsWith(
                                                      _getPairFullForm[
                                                          _testListIndex]));
                                          _testIndex = _testPracticeListIndex;
                                        });
                                        _ttsStop();
                                        sttStopListening();
                                        getPracticeWord();
                                      }),
                                )),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: PageTheme.app_theme_blue,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(8),
                        child: Text.rich(
                          TextSpan(
                            text: '',
                            style: const TextStyle(
                              fontSize: 20,
                              color: PageTheme.app_theme_blue,
                            ),
                            children: _replyTextWidget,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text: '',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                              children: _questionTextWidget,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text: '',
                              style: const TextStyle(
                                fontSize: 18,
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
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: CircleAvatar(
                                      backgroundColor: PageTheme.app_theme_blue,
                                      radius: 25.0,
                                      child: IconButton(
                                        icon: Icon((_allowTouchButtons[
                                                    'reListenButton']! &&
                                                !speechToText.isListening)
                                            ? (isPlaying
                                                ? Icons.volume_up
                                                : Icons.volume_up_outlined)
                                            : Icons.volume_off_outlined),
                                        color: (_allowTouchButtons[
                                                    'reListenButton']! &&
                                                !speechToText.isListening)
                                            ? Colors.white
                                            : Colors.grey,
                                        onPressed: () async {
                                          if (_allowTouchButtons[
                                                  'reListenButton']! &&
                                              !speechToText.isListening) {
                                            ttsRateSlow = !ttsRateSlow;
                                            await _ttsSpeak(
                                                _questionText, 'en-US');
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
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                                flex: 1,
                                child: Visibility(
                                  visible: _testIndex != 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              PageTheme.app_theme_blue,
                                          radius: 25.0,
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.navigate_before_outlined),
                                            color: (_allowTouchButtons[
                                                    'nextButton']!)
                                                ? Colors.white
                                                : Colors.grey,
                                            onPressed: () {
                                              if (_allowTouchButtons[
                                                  'nextButton']!) {
                                                setState(() {
                                                  _testIndex -= 1;
                                                  _testListIndex = _getPairFullForm
                                                      .indexWhere((note) =>
                                                          note.startsWith(
                                                              _getPracticeFullForm[
                                                                  _testIndex]));
                                                });
                                                _ttsStop();
                                                sttStopListening();
                                                getPracticeWord();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const AutoSizeText(
                                        '上一題',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Visibility(
                                  visible: _testIndex <
                                      _getPracticeSentence.length - 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              PageTheme.app_theme_blue,
                                          radius: 25.0,
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.navigate_next_outlined),
                                            color: (_allowTouchButtons[
                                                    'nextButton']!)
                                                ? Colors.white
                                                : Colors.grey,
                                            onPressed: () {
                                              if (_allowTouchButtons[
                                                  'nextButton']!) {
                                                setState(() {
                                                  _testIndex += 1;
                                                  _testListIndex = _getPairFullForm
                                                      .indexWhere((note) =>
                                                          note.startsWith(
                                                              _getPracticeFullForm[
                                                                  _testIndex]));
                                                });
                                                _ttsStop();
                                                sttStopListening();
                                                getPracticeWord();
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
                                )),
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
                          child: Text.rich(
                            TextSpan(
                              text: '',
                              style: const TextStyle(
                                fontSize: 24,
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
                          child: Text.rich(
                            TextSpan(
                              text: '',
                              style: const TextStyle(
                                fontSize: 18,
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
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.all(0.0),
                                elevation: 2.0,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 8,
                                            bottom: 8),
                                        child: AutoSizeText(
                                          '在這裡聽看看類似的發音吧',
                                          maxLines: 1,
                                        )),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 32,
                                          bottom: 8),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemCount: _ipaAboutList.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: const Icon(
                                                Icons.hearing_outlined),
                                            title: Text.rich(
                                              TextSpan(
                                                text: _ipaAboutList[index],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              ttsRateSlow = true;
                                              await _ttsSpeak(
                                                  _ipaAboutList[index],
                                                  'en-US');
                                              ttsRateSlow = !ttsRateSlow;
                                              await _ttsSpeak(
                                                  _ipaAboutList[index],
                                                  'en-US');
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
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
                    ]))),
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
                        icon: Icon(
                            (_allowTouchButtons['speakButton']! && !isPlaying)
                                ? (speechToText.isListening
                                    ? Icons.stop
                                    : Icons.mic_none)
                                : Icons.mic_off_outlined,
                            size: 30),
                        color:
                            (_allowTouchButtons['speakButton']! && !isPlaying)
                                ? Colors.white
                                : Colors.grey,
                        onPressed: () {
                          if (_allowTouchButtons['speakButton']! &&
                              !isPlaying) {
                            if (!_sttHasSpeech || speechToText.isListening) {
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
        ],
      ),
    );
  }

  Future<void> initLearningManualMinimalPairContractionPage() async {
    await initApplicationSettingsData();
    await initTts();
    await initSpeechState();
    getPracticeWord();
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

      flutterTts.setContinueHandler(() {
        setState(() {
          //print("Continued");
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
        //print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
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
    //print('Result listener $sttResultListened');
    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
    _handleSubmitted(result.recognizedWords, isFinalResult: result.finalResult);
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
    setState(() {
      _allowTouchButtons['speakButton'] = false;
    });
    await sttStopListening();

    await flutterTts.setLanguage(speakLanguage);
    if (ttsRateSlow) {
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

  void _handleSubmitted(String text, {bool isFinalResult: false}) {
    setState(() {
      _answerText = text;
      _answerTextWidget = [
        TextSpan(text: _answerText),
      ];
      _answerIPATextWidget = [
        const TextSpan(text: ''),
      ];
    });
    if (isFinalResult && _answerText != "") {
      _responseChatBot(_answerText);
    }
  }

  void _responseChatBot(text) async {
    setState(() {
      _replyText = '請稍候......';
      _replyTextWidget = [
        TextSpan(text: _replyText),
      ];
      _allowTouchButtons['reListenButton'] = false;
      _allowTouchButtons['speakButton'] = false;
      _allowTouchButtons['nextButton'] = false;
    });

    String checkSentencesJSON = await APIUtil.checkSentences(
        _questionText, text,
        correctCombo: _correctCombo);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());

    //print(checkSentences['data']['questionError'].toString());
    if (checkSentences['apiStatus'] == 'success') {
      if (checkSentences['data']['ipaTextSimilarity'] == 100) {
        _correctCombo++;
      } else {
        _correctCombo = 0;
      }

      var questionTextArray = checkSentences['data']['questionText'].split(' ');
      List<TextSpan> questionTextWidget = [];

      var questionIPATextArray =
          checkSentences['data']['questionIPAText'].split(' ');
      List<TextSpan> questionIPATextWidget = [];

      questionIPATextWidget.add(TextSpan(text: '['));
      for (var i = 0; i < questionTextArray.length; i++) {
        if (checkSentences['data']['questionError']
            .containsKey(questionTextArray[i])) {
          questionTextWidget.add(TextSpan(
            text: questionTextArray[i] + ' ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                ttsRateSlow = !ttsRateSlow;
                await _ttsSpeak(questionTextArray[i], 'en-US');
              },
          ));
          questionIPATextWidget.add(TextSpan(
            text: questionIPATextArray[i] + ' ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                ttsRateSlow = !ttsRateSlow;
                await _ttsSpeak(questionTextArray[i], 'en-US');
              },
          ));
        } else {
          if (i < questionTextArray.length)
            questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' '));
          if (i < questionIPATextArray.length)
            questionIPATextWidget
                .add(TextSpan(text: questionIPATextArray[i] + ' '));
        }
      }
      questionIPATextWidget.add(const TextSpan(text: ']'));

      var answerTextArray = checkSentences['data']['answerText'].split(' ');
      List<TextSpan> answerTextWidget = [];

      var answerIPATextArray =
          checkSentences['data']['answerIPAText'].split(' ');
      List<TextSpan> answerIPATextWidget = [];

      answerIPATextWidget.add(const TextSpan(text: '['));
      for (var i = 0; i < answerTextArray.length; i++) {
        if (checkSentences['data']['answerError']
            .containsKey(answerTextArray[i])) {
          answerTextWidget.add(TextSpan(
            text: answerTextArray[i] + ' ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                ttsRateSlow = !ttsRateSlow;
                await _ttsSpeak(answerTextArray[i], 'en-US');
              },
          ));
          answerIPATextWidget.add(TextSpan(
            text: answerIPATextArray[i] + ' ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                ttsRateSlow = !ttsRateSlow;
                await _ttsSpeak(answerTextArray[i], 'en-US');
              },
          ));
        } else {
          answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' '));
          answerIPATextWidget.add(TextSpan(text: answerIPATextArray[i] + ' '));
        }
      }
      answerIPATextWidget.add(const TextSpan(text: ']'));

      List<TextSpan> replyTextWidget = [];
      replyTextWidget.add(
          TextSpan(text: checkSentences['data']['scoreComment']['text'] + ' '));
      replyTextWidget.add(const TextSpan(text: ' '));
      replyTextWidget
          .add(TextSpan(text: checkSentences['data']['scoreComment']['emoji']));
//
      List<String> ipaAboutList = [];

      checkSentences['data']['questionError'].forEach((key, value) {
        String text = '';
        value['ipaAbout'].forEach((key, value) {
          text = text + value['word'] + ' ';
        });
        text =
            value['word'] + ': [ ' + text.trim().replaceAll(' ', ', ') + ' ]';
        ipaAboutList.add(text);
      });
      checkSentences['data']['answerError'].forEach((key, value) {
        String text = '';
        value['ipaAbout'].forEach((key, value) {
          text = text + value['word'] + ' ';
        });
        text =
            value['word'] + ': [ ' + text.trim().replaceAll(' ', ', ') + ' ]';
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
      await _ttsSpeak(checkSentences['data']['scoreComment']['text'], 'en-US');
//
      setState(() {
        _allowTouchButtons['speakButton'] = false;
      });
    } else {
      //print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      sleep(const Duration(seconds: 1));
      _responseChatBot(text);
    }
  }

  Future<void> getPracticeWord(
      {String questionText = '',
      String questionIPAText = '',
      String aboutWord = ''}) async {
    if (questionText == '') {
      setState(() {
        _replyText = '請稍候......';
        _replyTextWidget = [
          TextSpan(text: _replyText),
        ];
        _questionText = '';
        _questionIPAText = '';
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
    }

    setState(() {
      _replyText = 'Repeat after me: ';
      _replyTextWidget = [
        TextSpan(text: _replyText),
      ];

      String testSentence =
          _getPracticeSentence[_testIndex].replaceAll(',', ', ');

      _questionText = testSentence;
      _questionTextWidget = [
        TextSpan(text: _questionText),
      ];

      String testSentenceIPA =
          _getPracticeSentenceIPA[_testIndex].replaceAll(',', ', ');

      _questionIPAText = testSentenceIPA;
      _questionIPATextWidget = [
        TextSpan(text: '[' + _questionIPAText + ']'),
      ];
      ttsRateSlow = false;
      _allowTouchButtons['reListenButton'] = true;
      _allowTouchButtons['speakButton'] = true;
      _allowTouchButtons['nextButton'] = true;
    });
    await _ttsSpeak('Repeat after me', 'en-US');
    await _ttsSpeak(_questionText, 'en-US');

    await sttStartListening();
    return;
  }
}
