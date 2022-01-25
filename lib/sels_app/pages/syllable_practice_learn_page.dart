

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sels_app/sels_app/utils/api_util.dart';
import 'package:sels_app/sels_app/utils/shared_preferences_util.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SyllablePracticeLearnPage extends StatefulWidget {
  List<String> selectSyllableList = const [];

  SyllablePracticeLearnPage(List<String> selectSyllableList){
    this.selectSyllableList = selectSyllableList;
  }

  @override
  _SyllablePracticeLearnPage createState() => _SyllablePracticeLearnPage(selectSyllableList);
}

enum TtsState { playing, stopped, paused, continued }

class _SyllablePracticeLearnPage extends State<SyllablePracticeLearnPage> {


  //List<List<List<TextSpan>>> _answerTextWidget = [[[ TextSpan(text: ''), ], [ TextSpan(text: ''), ]], [], []];
  //List<List<String>> _ipaAboutList = [['aa11, bb11', 'aa12, bb12'], ['aa21, bb21', 'aa22, bb22'], ['aa31, bb31', 'aa32, bb32']];
  List<String> _selectSyllableList = const [];

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




  _SyllablePracticeLearnPage(List<String> selectSyllableList){
    this._selectSyllableList = selectSyllableList;
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
    EasyLoading.dismiss();
    flutterTts.stop();
    speechToText.stop();
  }

  initSyllablePracticeLearnPage() async {
    initApplicationSettingsData();
    initTts();
    initSpeechState();
    await updateIPAAboutList(0);
    await updateIPAAboutList(1);
    await updateIPAAboutList(2);
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



  int animationController = 100;
  int animation = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('learn page${_selectSyllableList}' ),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 6,
                      child: Container(
                        //color: Colors.green,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Visibility(
                                visible: !((_selectSyllableList[0] == '' ) || (_selectSyllableList[1] == '' )),
                                child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(0.0),
                                  elevation: 2.0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                '${_selectSyllableList[0]}/${_selectSyllableList[1]} 音節練習',
                                                style: const TextStyle(
                                                  fontSize: 16 ,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Visibility(
                                                visible: _selectSyllableList[3] == "3",
                                                child: IconButton(
                                                  color: Colors.grey,
                                                  iconSize: 25,
                                                  icon: Icon(Icons.refresh_outlined),
                                                  onPressed: () {
                                                    updateIPAAboutList(0);
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
                                          height: 20,
                                          thickness: 1,
                                        ),
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
                                        Container(
                                          child: ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemExtent: 180,
                                            //itemCount: _questionTextList[0].length,
                                            itemCount: int.parse(_selectSyllableList[3]),
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
                                                      Visibility(
                                                        visible: _selectSyllableList[3] == '3',
                                                        child: Flexible(
                                                          flex: 2,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Visibility(
                                                                visible: _selectSyllableList[3] == '3',
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
                                                                              icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                              //icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                              color: Colors.white,
                                                                              //color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                              onPressed: () async {
                                                                                if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                                  ttsRateSlow = !ttsRateSlow;
                                                                                  await _ttsSpeak(_questionTextList[0][index], 'en-US');
                                                                                }
                                                                                sttStartListening(0, index);
                                                                              },
                                                                              /*
                                                                          iconSize: 15,
                                                                          icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                          color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                          onPressed: () async {
                                                                            if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                              ttsRateSlow = !ttsRateSlow;
                                                                              await _ttsSpeak(_questionTextList[1][index], 'en-US');
                                                                              sttStartListening(1, index);
                                                                            }
                                                                          },
                                                                          */
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                ),
                                                              ),
                                                              /*
                                                            Center(
                                                              child: AvatarGlow(
                                                                animate: true,
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
                                                                      iconSize: 15,
                                                                      //icon: Icon(Icons.volume_off_outlined ),
                                                                      icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                      color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () async {
                                                                        if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                          ttsRateSlow = !ttsRateSlow;
                                                                          await _ttsSpeak(_questionTextList[0][index], 'en-US');
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            Expanded(
                                                                child: Center(
                                                                  child: AvatarGlow(
                                                                    animate: true,
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
                                                                          iconSize: 15,
                                                                          icon: Icon( (_allowTouchButtons['speakButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.mic : Icons.mic_none) : Icons.mic_off_outlined ),
                                                                          color: (_allowTouchButtons['speakButton']! && !isPlaying ) ? Colors.white : Colors.grey ,
                                                                          onPressed: () {
                                                                            if(_allowTouchButtons['speakButton']! && !isPlaying ){
                                                                              if( !_sttHasSpeech || speechToText.isListening ){
                                                                                sttStopListening();
                                                                              } else {
                                                                                sttStartListening(0 ,index);
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ),
                                                            */
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(
                                                visible: _selectSyllableList[3] == '1',
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Center(
                                                              child: AvatarGlow(
                                                                animate: true,
                                                                glowColor: Theme.of(context).primaryColor,
                                                                endRadius: 30.0,
                                                                duration: const Duration(milliseconds: 2000),
                                                                repeat: true,
                                                                showTwoGlows: true,
                                                                repeatPauseDuration: const Duration(milliseconds: 100),
                                                                child: Material(
                                                                  elevation: 8.0,
                                                                  shape: CircleBorder(),
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Theme.of(context).primaryColor,
                                                                    radius: 20.0,
                                                                    child: IconButton(
                                                                      icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                      //icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                      color: Colors.white,
                                                                      //color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () async {
                                                                        if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                          ttsRateSlow = !ttsRateSlow;
                                                                          await _ttsSpeak(_questionTextList[0][0], 'en-US');
                                                                        }
                                                                        sttStartListening(0, 0);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              '測試聽說',
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
                                                          children: <Widget>[
                                                            Center(
                                                              child: AvatarGlow(
                                                                animate: false,
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
                                                                      icon: const Icon(Icons.navigate_next_outlined),
                                                                      color: (_allowTouchButtons['nextButton']! ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () {
                                                                        updateIPAAboutList(0);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              '下一題',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        /*
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              /*
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
                                                                iconSize: 15,
                                                                //icon: Icon(Icons.volume_off_outlined ),
                                                                icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                onPressed: () async {
                                                                  if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                    ttsRateSlow = !ttsRateSlow;
                                                                    await _ttsSpeak(_questionTextList[0][0], 'en-US');
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
                                                    children: <Widget>[
                                                      Center(
                                                        child: AvatarGlow(
                                                          //animate: true,
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
                                                                iconSize: 15,
                                                                icon: Icon( (_allowTouchButtons['speakButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.mic : Icons.mic_none) : Icons.mic_off_outlined ),
                                                                color: (_allowTouchButtons['speakButton']! && !isPlaying ) ? Colors.white : Colors.grey ,
                                                                onPressed: () {
                                                                  if(_allowTouchButtons['speakButton']! && !isPlaying ){
                                                                    if( !_sttHasSpeech || speechToText.isListening ){
                                                                      sttStopListening();
                                                                    } else {
                                                                      sttStartListening(0 ,0);
                                                                    }
                                                                  }
                                                                },
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
                                                  ),
                                              ),

                                               */
                                              Expanded(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Center(
                                                        child: AvatarGlow(
                                                          animate: true,
                                                          glowColor: Theme.of(context).primaryColor,
                                                          endRadius: 30.0,
                                                          duration: Duration(milliseconds: 2000),
                                                          repeat: true,
                                                          showTwoGlows: true,
                                                          repeatPauseDuration: Duration(milliseconds: 100),
                                                          child: Material(
                                                            elevation: 8.0,
                                                            shape: CircleBorder(),
                                                            child: CircleAvatar(
                                                              backgroundColor: Theme.of(context).primaryColor,
                                                              radius: 20.0,
                                                              child: IconButton(
                                                                icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                //icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                color: Colors.white,
                                                                //color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                onPressed: () async {
                                                                  if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                    ttsRateSlow = !ttsRateSlow;
                                                                    await _ttsSpeak(_questionTextList[0][0], 'en-US');
                                                                  }
                                                                  sttStartListening(0, 0);
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        '測試聽說',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(
                                                  child: Column(
                                                    children: <Widget>[
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
                                                                icon: const Icon(Icons.navigate_next_outlined),
                                                                color: (_allowTouchButtons['nextButton']! ) ? Colors.white : Colors.grey ,
                                                                onPressed: () {
                                                                  updateIPAAboutList(0);
                                                                  },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        '下一題',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        )
                                        */
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                              Visibility(
                                visible: !((_selectSyllableList[0] == '' ) || (_selectSyllableList[2] == '' )),
                                child: Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.all(0.0),
                                  elevation: 2.0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                '${_selectSyllableList[0]}/${_selectSyllableList[2]} 音節練習',
                                                style: const TextStyle(
                                                  fontSize: 16 ,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Visibility(
                                                visible: _selectSyllableList[3] == '3',
                                                child: IconButton(
                                                  color: Colors.grey,
                                                  iconSize: 25,
                                                  icon: const Icon(Icons.refresh_outlined),
                                                  onPressed: () {
                                                    updateIPAAboutList(1);
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        const Divider(
                                          height: 20,
                                          thickness: 1,
                                        ),
                                        Visibility(
                                          visible: (_questionTextList[1].length == 0),
                                          child: const Text(
                                            'No minimal pair match',
                                            style: TextStyle(
                                              fontSize: 16 ,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: ListView.builder(
                                            physics: new NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemExtent: 180,
                                            //itemCount: _questionTextList[1].length,
                                            itemCount: int.parse(_selectSyllableList[3]),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                color: Color(0xff62B1F9),
                                                child: Card(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 9,
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
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            color: Color(0xFF2633C5),
                                                                          ),
                                                                          children: _questionTextWidgetList[1][index],
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
                                                                          children: _questionIPATextWidgetList[1][index],
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
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            color: Color(0xFF2633C5),
                                                                          ),
                                                                          children: _answerTextWidgetList[1][index],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child: RichText(
                                                                        text: TextSpan(
                                                                          text: '',
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            color: Color(0xFF2633C5),
                                                                          ),
                                                                          children: _answerIPATextWidgetList[1][index],
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
                                                      Visibility(
                                                        visible: _selectSyllableList[3] == '3',
                                                        child: Flexible(
                                                          flex: 2,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Visibility(
                                                                visible: _selectSyllableList[3] == '3',
                                                                child: Expanded(
                                                                    child: Center(
                                                                      child: AvatarGlow(
                                                                        animate: true,
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
                                                                              iconSize: 15.0,
                                                                              icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                              //icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                              color: Colors.white,
                                                                              //color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                              onPressed: () async {
                                                                                if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                                  ttsRateSlow = !ttsRateSlow;
                                                                                  await _ttsSpeak(_questionTextList[1][index], 'en-US');
                                                                                }
                                                                                sttStartListening(1, index);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      /*
                                                      Flexible(
                                                        flex: 1,
                                                        child: Column(
                                                          children: <Widget>[
                                                            /*
                                                            Center(
                                                              child: AvatarGlow(
                                                                animate: true,
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
                                                                      iconSize: 15,
                                                                      icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                      color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () async {
                                                                        if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                          ttsRateSlow = !ttsRateSlow;
                                                                          await _ttsSpeak(_questionTextList[1][index], 'en-US');
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Center(
                                                                  child: AvatarGlow(
                                                                    animate: true,
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
                                                                          iconSize: 15,
                                                                          icon: Icon( (_allowTouchButtons['speakButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.mic : Icons.mic_none) : Icons.mic_off_outlined ),
                                                                          color: (_allowTouchButtons['speakButton']! && !isPlaying ) ? Colors.white : Colors.grey ,
                                                                          onPressed: () {
                                                                            if(_allowTouchButtons['speakButton']! && !isPlaying ){
                                                                              if( !_sttHasSpeech || speechToText.isListening ){
                                                                                sttStopListening();
                                                                              } else {
                                                                                sttStartListening(1 ,index);
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ),
                                                             */
                                                            Expanded(
                                                                child: Center(
                                                                  child: AvatarGlow(
                                                                    animate: true,
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
                                                                          iconSize: 15.0,
                                                                          icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                          //icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                          color: Colors.white,
                                                                          //color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                          onPressed: () async {
                                                                            if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                              ttsRateSlow = !ttsRateSlow;
                                                                              await _ttsSpeak(_questionTextList[1][index], 'en-US');
                                                                            }
                                                                            sttStartListening(1, index);
                                                                          },
                                                                          /*
                                                                          iconSize: 15,
                                                                          icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                          color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                          onPressed: () async {
                                                                            if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                              ttsRateSlow = !ttsRateSlow;
                                                                              await _ttsSpeak(_questionTextList[1][index], 'en-US');
                                                                              sttStartListening(1, index);
                                                                            }
                                                                          },
                                                                          */
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      */
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(
                                                visible: _selectSyllableList[3] == '1',
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Center(
                                                              child: AvatarGlow(
                                                                animate: true,
                                                                glowColor: Theme.of(context).primaryColor,
                                                                endRadius: 30.0,
                                                                duration: Duration(milliseconds: 2000),
                                                                repeat: true,
                                                                showTwoGlows: true,
                                                                repeatPauseDuration: Duration(milliseconds: 100),
                                                                child: Material(
                                                                  elevation: 8.0,
                                                                  shape: CircleBorder(),
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Theme.of(context).primaryColor,
                                                                    radius: 20.0,
                                                                    child: IconButton(
                                                                      icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                      //icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                      color: Colors.white,
                                                                      //color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () async {
                                                                        if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                          ttsRateSlow = !ttsRateSlow;
                                                                          await _ttsSpeak(_questionTextList[1][0], 'en-US');
                                                                        }
                                                                        sttStartListening(1, 0);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              '測試聽說',
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
                                                          children: <Widget>[
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
                                                                      icon: const Icon(Icons.navigate_next_outlined),
                                                                      color: (_allowTouchButtons['nextButton']! ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () {
                                                                        updateIPAAboutList(1);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              '下一題',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),

                              Visibility(
                                visible: !((_selectSyllableList[1] == '' ) || (_selectSyllableList[2] == '' )),
                                child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(0.0),
                                  elevation: 2.0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                '${_selectSyllableList[1]}/${_selectSyllableList[2]} 音節練習',
                                                style: const TextStyle(
                                                  fontSize: 16 ,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Visibility(
                                                visible: _selectSyllableList[3] == '3',
                                                child: IconButton(
                                                  color: Colors.grey,
                                                  iconSize: 25,
                                                  icon: const Icon(Icons.refresh_outlined),
                                                  onPressed: () {
                                                    updateIPAAboutList(2);
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        const Divider(
                                          height: 20,
                                          thickness: 1,
                                        ),
                                        Visibility(
                                          visible: _questionTextList[2].isEmpty,
                                          child: const Text(
                                            'No minimal pair match',
                                            style: TextStyle(
                                              fontSize: 16 ,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemExtent: 180,
                                            //itemCount: _questionTextList[2].length,
                                            itemCount: int.parse(_selectSyllableList[3]),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                color: const Color(0xff62B1F9),
                                                child: Card(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 9,
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
                                                                          children: _questionTextWidgetList[2][index],
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
                                                                          children: _questionIPATextWidgetList[2][index],
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
                                                                          children: _answerTextWidgetList[2][index],
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
                                                                          children: _answerIPATextWidgetList[2][index],
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
                                                      Visibility(
                                                        visible: _selectSyllableList[3] == '3',
                                                        child: Flexible(
                                                          flex: 2,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Visibility(
                                                                visible: _selectSyllableList[3] == '3',
                                                                child: Expanded(
                                                                    child: Center(
                                                                      child: AvatarGlow(
                                                                        animate: true,
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
                                                                              iconSize: 15.0,
                                                                              icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                              //icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                              color: Colors.white,
                                                                              //color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                              onPressed: () async {
                                                                                if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                                  ttsRateSlow = !ttsRateSlow;
                                                                                  await _ttsSpeak(_questionTextList[2][index], 'en-US');
                                                                                }
                                                                                sttStartListening(2, index);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(
                                                visible: _selectSyllableList[3] == '1',
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Center(
                                                              child: AvatarGlow(
                                                                animate: true,
                                                                glowColor: Theme.of(context).primaryColor,
                                                                endRadius: 30.0,
                                                                duration: const Duration(milliseconds: 2000),
                                                                repeat: true,
                                                                showTwoGlows: true,
                                                                repeatPauseDuration: const Duration(milliseconds: 100),
                                                                child: Material(
                                                                  elevation: 8.0,
                                                                  shape: CircleBorder(),
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Theme.of(context).primaryColor,
                                                                    radius: 20.0,
                                                                    child: IconButton(
                                                                      icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening) ? (Icons.volume_up) : Icons.mic),
                                                                      //icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                      color: Colors.white,
                                                                      //color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () async {
                                                                        if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                          ttsRateSlow = !ttsRateSlow;
                                                                          await _ttsSpeak(_questionTextList[2][0], 'en-US');
                                                                        }
                                                                        sttStartListening(2, 0);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              '測試聽說',
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
                                                          children: <Widget>[
                                                            Center(
                                                              child: AvatarGlow(
                                                                animate: false,
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
                                                                      icon: const Icon(Icons.navigate_next_outlined),
                                                                      color: (_allowTouchButtons['nextButton']! ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () {
                                                                        updateIPAAboutList(2);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              '下一題',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),




                      /*
                      Container(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: SELSAppTheme.white,
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Divider(
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ),

                                ],
                            ),
                          ),

                          /*
                          Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(0.0),
                            elevation: 2.0,
                            child: Container(
                              child: ListView.builder(
                                  itemExtent: 80,
                                  itemCount: _ipaAboutList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Card(

                                        child: ListTile(
                                          title: Text('${_ipaAboutList[index]}'),
                                          leading: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CircularProgressIndicator(
                                                    backgroundColor: Colors.grey[200],
                                                    valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                                    value: 70/100,
                                                  ),
                                                ),
                                                Text(
                                                    '70%'
                                                )
                                              ],
                                          ),
                                          trailing: PopupMenuButton(
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  value: '開始學習',
                                                  child: Text('開始學習'),
                                                ),
                                                PopupMenuItem(
                                                  value: '複習',
                                                  child: Text('複習'),
                                                ),
                                                PopupMenuItem(
                                                  value: '測驗',
                                                  child: Text('測驗'),
                                                ),
                                              ];
                                            },
                                            onSelected: (String value){
                                              print('You Click on po up menu item' + value);
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            )
                          ),*/
                        ),
                      ),

                       */
                    ),
                  ],
                )
              ),
              Visibility(
                visible: false,
                child: Stack(
                    children: <Widget>[
                      Dismissible(
                          key: ValueKey('GrammarCheckPage_Introduce_03'),
                          onDismissed: (DismissDirection direction){
                            //setState(() => _applicationSettingsGrammarCheckPageIntroduce = false);
                            //SharedPreferencesUtil.saveData<bool>('applicationSettingsGrammarCheckPageIntroduce', _applicationSettingsGrammarCheckPageIntroduce);
                            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //  content: Text('讓我們開始吧！'),
                            //));
                          },
                          child: ConstrainedBox(
                            child: Image.asset(
                              'assets/sels_app/GrammarCheckPage/GrammarCheckPage_Introduce_03.png',
                              fit: BoxFit.fill,
                            ),
                            constraints: new BoxConstraints.expand(),
                          )
                      ),
                      Dismissible(
                          key: ValueKey('GrammarCheckPage_Introduce_02'),
                          child: ConstrainedBox(
                            child: Image.asset(
                              'assets/sels_app/GrammarCheckPage/GrammarCheckPage_Introduce_02.png',
                              fit: BoxFit.fill,
                            ),
                            constraints: new BoxConstraints.expand(),
                          )
                      ),
                      Dismissible(
                          key: ValueKey('GrammarCheckPage_Introduce_01'),
                          child: ConstrainedBox(
                            child: Image.asset(
                              'assets/sels_app/GrammarCheckPage/GrammarCheckPage_Introduce_01.png',
                              fit: BoxFit.fill,
                            ),
                            constraints: new BoxConstraints.expand(),
                          )
                      ),
                    ]
                ),

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
        listenMode: ListenMode.confirmation);
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

  Future<void> updateIPAAboutList(index) async {

    String ipa1 = '';
    String ipa2 = '';

    switch(index) {
      case 0:
        ipa1 = _selectSyllableList[0];
        ipa2 = _selectSyllableList[1];
        break;
      case 1:
        ipa1 = _selectSyllableList[0];
        ipa2 = _selectSyllableList[2];
        break;
      case 2:
        ipa1 = _selectSyllableList[1];
        ipa2 = _selectSyllableList[2];
        break;
      default :
        break;
    }

    if( ( ipa1 == '' ) || (ipa2 == '' ) ) {
      EasyLoading.dismiss();
      return;
    }

    setState(() {
      _allowTouchButtons['reListenButton'] = false;
      _allowTouchButtons['speakButton'] = false;
      _allowTouchButtons['nextButton'] = false;
    });

    EasyLoading.show(status: '正在讀取資料，請稍候......');
    



    var minimalPairTwoFinder;
    do {
      String minimalPairTwoFinderJSON = await APIUtil.minimalPairTwoFinder(ipa1, ipa2);
      minimalPairTwoFinder = jsonDecode(minimalPairTwoFinderJSON.toString());
      print('minimalPairOneFinder 1 apiStatus:' + minimalPairTwoFinder['apiStatus'] + ' apiMessage:' + minimalPairTwoFinder['apiMessage']);
      if(minimalPairTwoFinder['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (minimalPairTwoFinder['apiStatus'] != 'success');

    print(_selectSyllableList[index]);
    print(minimalPairTwoFinder['data']);

    //questionsData.addAll(minimalPairOneFinder['data']);

    List<String> questionTextList = [];
    List<String> questionIPATextList = [];
    List<List<TextSpan>> questionTextWidgetList = [];
    List<List<TextSpan>> questionIPATextWidgetList = [];
    List<List<TextSpan>> answerTextWidget = [];
    List<List<TextSpan>> answerIPATextWidgetList = [];


    minimalPairTwoFinder['data'].forEach((element) {
      questionTextList.add('${element['leftWord']}, ${element['rightWord']}');
      questionIPATextList.add('${element['leftIPA']}, ${element['rightIPA']}');
      questionTextWidgetList.add([TextSpan(text: '${element['leftWord']}, ${element['rightWord']}')]);
      questionIPATextWidgetList.add([TextSpan(text: '[${element['leftIPA']}, ${element['rightIPA']}]')]);
      answerTextWidget.add([ TextSpan(text: ''), TextSpan(text: '') ]);
      answerIPATextWidgetList.add([ TextSpan(text: ''), TextSpan(text: '') ]);
    });
    setState(() {
      _questionTextList[index] = questionTextList;
      _questionIPATextList[index] = questionIPATextList;
      _questionTextWidgetList[index] = questionTextWidgetList;
      _questionIPATextWidgetList[index] = questionIPATextWidgetList;
      _answerTextList[index] = [''];
      _answerIPATextList[index] = [''];
      _answerTextWidgetList[index] = answerTextWidget;
      _answerIPATextWidgetList[index] = answerIPATextWidgetList;
      _allowTouchButtons['reListenButton'] = true;
      _allowTouchButtons['speakButton'] = true;
      _allowTouchButtons['nextButton'] = true;
    });

    EasyLoading.dismiss();
    return;
  }
}