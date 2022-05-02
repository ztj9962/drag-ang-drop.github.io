

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SyllablePracticeWordPage extends StatefulWidget {
  String searchWordController = '';

  SyllablePracticeWordPage(String searchWordController){
    this.searchWordController = searchWordController;
  }

  @override
  _SyllablePracticeWordPage createState() => _SyllablePracticeWordPage(searchWordController);
}

enum TtsState { playing, stopped, paused, continued }

class _SyllablePracticeWordPage extends State<SyllablePracticeWordPage> {
  //final searchWordController = TextEditingController();
  String _searchWordController = '';

  List<int> _sstIndex = [0, 0];

  final List<List<String>> _questionTextList = [
    [
      'aa11, bb11', 'aa12, bb12'
    ],
    [
      'aa21, bb21', 'aa22, bb22'
    ],
    [
      'aa31, bb31', 'aa32, bb32'
    ]
  ];
  final List<List<String>> _questionIPATextList = [['aa11, bb11', 'aa12, bb12'], ['aa21, bb21', 'aa22, bb22'], ['aa31, bb31', 'aa32, bb32']];
  final List<List<String>> _answerTextList = [['aa11, bb11', 'aa12, bb12'], ['aa21, bb21', 'aa22, bb22'], ['aa31, bb31', 'aa32, bb32']];
  final List<List<String>> _answerIPATextList = [['aa11, bb11', 'aa12, bb12'], ['aa21, bb21', 'aa22, bb22'], ['aa31, bb31', 'aa32, bb32']];
  final List<List<List<TextSpan>>> _questionTextWidgetList = [
    [
      [const TextSpan(text: ''), const TextSpan(text: '')],
      [const TextSpan(text: ''), const TextSpan(text: '')],
      [const TextSpan(text: ''), const TextSpan(text: '')],
    ],
    [
      [const TextSpan(text: ''), const TextSpan(text: '')],
      [const TextSpan(text: ''), const TextSpan(text: '')],
      [const TextSpan(text: ''), const TextSpan(text: '')],
    ],
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ]
  ];
  final List<List<List<TextSpan>>> _questionIPATextWidgetList = [
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ],
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ],
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ]
  ];
  final List<List<List<TextSpan>>> _answerTextWidgetList = [
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ],
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ],
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ]
  ];
  final List<List<List<TextSpan>>> _answerIPATextWidgetList = [
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ],
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ],
    [
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
      [TextSpan(text: ''), TextSpan(text: '')],
    ]
  ];


  _SyllablePracticeWordPage(String searchWordController){
    this._searchWordController = searchWordController;
  }

  final _allowTouchButtons = {
    'reListenButton' : false,
    'speakButton' : false,
    'nextButton' : false,
  };

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
  bool ttsRateSlow = true;
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
    initSyllablePracticeLearnPage();
  }

  @override
  void dispose() {
    super.dispose();
    //searchWordController.dispose();
    EasyLoading.dismiss();
    speechToText.stop();
    flutterTts.stop();
  }

  initSyllablePracticeLearnPage() async {
    initApplicationSettingsData();
    initTts();
    initSpeechState();
    await updateWordList(0);
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

  int animationController = 100;
  int animation = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('尋找單詞相似詞'),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                          flex: 6,
                          child: SingleChildScrollView(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8, top: 8),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            '${_searchWordController} 相似詞練習',
                                            style: const TextStyle(
                                              fontSize: 16 ,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Visibility(
                                            visible: _searchWordController.isNotEmpty,
                                            child: IconButton(
                                              color: Colors.grey,
                                              iconSize: 25,
                                              icon: Icon(Icons.refresh_outlined),
                                              onPressed: () {
                                                updateWordList(0);
                                              },
                                            ),
                                          ),
                                          /*
                                              IconButton(
                                                color: Colors.grey,
                                                iconSize: 25,
                                                icon: Icon(Icons.refresh_outlined),
                                                onPressed: () {
                                                  updateIPAAboutList(0);
                                                },
                                              ),
                                              */
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 5,
                                      thickness: 1,
                                    ),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Visibility(
                                            visible: _questionTextList[0].isEmpty,
                                            child: const Text(
                                              'No minimal pair match',
                                              style: TextStyle(
                                                fontSize: 16 ,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: _searchWordController != '',
                                            child: ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemExtent: 180,
                                              itemCount: _questionTextList[0].length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  color: const Color(0xff62B1F9),
                                                  child: Card(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Flexible(
                                                          flex: 8,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Flexible(
                                                                flex: 1,
                                                                child:Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: Column(
                                                                    children: [
                                                                      Flexible(
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                            text: '',
                                                                            style: const TextStyle(
                                                                              fontSize: 20,
                                                                              color: Color(0xFF2633C5),
                                                                            ),
                                                                            children: _questionTextWidgetList[0][index],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                            text: '',
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xFF2633C5),
                                                                            ),
                                                                            children: _questionIPATextWidgetList[0][index],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const Divider(
                                                                height: 0,
                                                                thickness: 1,
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child:Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  //color:Colors.grey,
                                                                  child: Column(
                                                                    children: [
                                                                      Flexible(
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                            text: '',
                                                                            style: const TextStyle(
                                                                              fontSize: 20,
                                                                              color: Color(0xFF2633C5),
                                                                            ),
                                                                            children: _answerTextWidgetList[0][index],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                            text: '',
                                                                            style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xFF2633C5),
                                                                            ),
                                                                            children: _answerIPATextWidgetList[0][index],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 2,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Visibility(
                                                                visible: _searchWordController != '',
                                                                child: Expanded(
                                                                  child: Center(
                                                                    child: AvatarGlow(
                                                                      animate: true,
                                                                      glowColor: Theme.of(context).primaryColor,
                                                                      endRadius: 30.0,
                                                                      duration: const Duration(milliseconds: 2000),
                                                                      repeat: true,
                                                                      showTwoGlows: true,
                                                                      repeatPauseDuration: const Duration(milliseconds: 100),
                                                                      child: Material(     // Replace this child with your own
                                                                        elevation: 8.0,
                                                                        shape: const CircleBorder(),
                                                                        child: CircleAvatar(
                                                                          backgroundColor: Theme.of(context).primaryColor,
                                                                          radius: 20.0,
                                                                          child: IconButton(
                                                                            iconSize: 15.0,
                                                                            icon: Icon((_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                            color: Colors.white,
                                                                            onPressed: () async {
                                                                              print('Click!');
                                                                              if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                                ttsRateSlow = !ttsRateSlow;
                                                                                await _ttsSpeak(_questionTextList[0][index], 'en-US');
                                                                              }
                                                                              sttStartListening(0, index);
                                                                              //print('Click!');
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]
                              ),
                          ),
                      ),
                    ],
                  )
              ),
            ]
        )
    );
  }

  /*
  speech_to_text
   */
  Future<void> sttStartListening(index1, index2) async {

    setState(() {
      _sstIndex = [index1, index2];
    });
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
        listenMode: ListenMode.confirmation
    );
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

  void _handleSubmitted(String text, {bool isFinalResult:false}) {

    setState(() {
      //_answerTextList[_sstIndex[0]][_sstIndex[1]] = text;
      //_answerTextWidgetList[0][1] = [ TextSpan(text: text), ];
      //_answerIPATextWidgetList[_sstIndex[0]][_sstIndex[1]] = [ TextSpan(text: ''), ];
    });
    if(isFinalResult){
      _responseChatBot(text);
    }
  }

  void _responseChatBot(text) async {
    setState(() {
      _allowTouchButtons['reListenButton'] = false;
      _allowTouchButtons['speakButton'] = false;
      _allowTouchButtons['nextButton'] = false;
    });

    String checkSentencesJSON = await APIUtil.checkSentences(_questionTextList[_sstIndex[0]][_sstIndex[1]], text, correctCombo:_correctCombo);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());

    //print(checkSentences['data']['questionError'].toString());
    if(checkSentences['apiStatus'] == 'success'){

      if(checkSentences['data']['ipaTextSimilarity'] == 100){
        _correctCombo++;
      } else {
        _correctCombo = 0;
      }

      var questionIPATextCheckedArray = checkSentences['data']['checkPronunciation']['questionCheckedArray'];
      var answerIPATextCheckedArray = checkSentences['data']['checkPronunciation']['answerCheckedArray'];

      print('XXXXX');
      print(checkSentences['data']['checkPronunciation']['questionCheckedArray']);

      List<TextSpan> questionIPATextWidget = [];
      List<TextSpan> answerIPATextWidget = [];

      questionIPATextWidget.add(TextSpan(text: '['));
      answerIPATextWidget.add(TextSpan(text: '['));
      for (var i = 0; i < questionIPATextCheckedArray.length; i++) {
        if(questionIPATextCheckedArray[i] != answerIPATextCheckedArray[i]){
          questionIPATextWidget.add(
              TextSpan(
                text: questionIPATextCheckedArray[i],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
          );
          answerIPATextWidget.add(
              TextSpan(
                text: answerIPATextCheckedArray[i],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
          );
        } else {
          questionIPATextWidget.add(TextSpan(text: questionIPATextCheckedArray[i]));
          answerIPATextWidget.add(TextSpan(text: answerIPATextCheckedArray[i]));
        }
      }
      questionIPATextWidget.add(TextSpan(text: ']'));
      answerIPATextWidget.add(TextSpan(text: ']'));

      setState(() {
        _questionIPATextWidgetList[_sstIndex[0]][_sstIndex[1]] = questionIPATextWidget;
        _answerTextWidgetList[_sstIndex[0]][_sstIndex[1]] = [ TextSpan(text: text), TextSpan(text: '') ];
        _answerIPATextWidgetList[_sstIndex[0]][_sstIndex[1]] = answerIPATextWidget;

        ttsRateSlow = false;
        _allowTouchButtons['reListenButton'] = true;
        _allowTouchButtons['speakButton'] = true;
        _allowTouchButtons['nextButton'] = true;
      });

      await _ttsSpeak(checkSentences['data']['scoreComment']['text'] , 'en-US');

      setState(() {
        ttsRateSlow = true;
        _allowTouchButtons['speakButton'] = true;
      });

    } else {
      print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      sleep(Duration(seconds:1));
      _responseChatBot(text);
    }
  }

  Future<void> updateWordList(index) async {
    print('Run Run Run!!!');
    String word1 = _searchWordController.trim();

    if(word1 == '') {
      EasyLoading.dismiss();
      return;
    }

    setState(() {
      _allowTouchButtons['reListenButton'] = false;
      _allowTouchButtons['speakButton'] = false;
      _allowTouchButtons['nextButton'] = false;
    });

    EasyLoading.show(status: '正在讀取資料，請稍候......');

    var minimalPairWordFinder;
    do {
      String minimalPairWordFinderJSON = await APIUtil.minimalPairWordFinder(word1);
      minimalPairWordFinder = jsonDecode(minimalPairWordFinderJSON.toString());
      print('minimalPairWordFinder 1 apiStatus:' + minimalPairWordFinder['apiStatus'] + ' apiMessage:' + minimalPairWordFinder['apiMessage']);
      if(minimalPairWordFinder['apiStatus'] != 'success') {
        await Future.delayed(const Duration(seconds: 1));
      }
    } while (minimalPairWordFinder['apiStatus'] != 'success');

    print(minimalPairWordFinder['data']);

    List<String> questionTextList = [];
    List<String> questionIPATextList = [];
    List<List<TextSpan>> questionTextWidgetList = [];
    List<List<TextSpan>> questionIPATextWidgetList = [];
    List<List<TextSpan>> answerTextWidget = [];
    List<List<TextSpan>> answerIPATextWidgetList = [];

    minimalPairWordFinder['data'].forEach((element) {
      questionTextList.add('${element['leftWord']}, ${element['rightWord']}');
      questionIPATextList.add('${element['leftIPA']}, ${element['rightIPA']}');
      questionTextWidgetList.add([TextSpan(text: '${element['leftWord']}, ${element['rightWord']}')]);
      questionIPATextWidgetList.add([TextSpan(text: '[${element['leftIPA']}, ${element['rightIPA']}]')]);
      answerTextWidget.add([ TextSpan(text: ''), TextSpan(text: '') ]);
      answerIPATextWidgetList.add([ TextSpan(text: ''), TextSpan(text: '') ]);
    });

    setState(() {
      _questionTextList[0] = questionTextList;
      _questionIPATextList[0] = questionIPATextList;
      _questionTextWidgetList[0] = questionTextWidgetList;
      _questionIPATextWidgetList[0] = questionIPATextWidgetList;
      _answerTextList[0] = [''];
      _answerIPATextList[0] = [''];
      _answerTextWidgetList[0] = answerTextWidget;
      _answerIPATextWidgetList[0] = answerIPATextWidgetList;
      _allowTouchButtons['reListenButton'] = true;
      _allowTouchButtons['speakButton'] = true;
      _allowTouchButtons['nextButton'] = true;
    });

    print('Run Run Over!');
    EasyLoading.dismiss();
    return;
  }
}