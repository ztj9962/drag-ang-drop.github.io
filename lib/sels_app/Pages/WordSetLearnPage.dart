

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';
import 'package:sels_app/sels_app/Utils/SharedPreferencesUtil.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WordSetLearnPage extends StatefulWidget {

  String learningClassification = '';
  String learningPhase = '';

  WordSetLearnPage({String learningClassification:'', String learningPhase:''}) {
    this.learningClassification = learningClassification;
    this.learningPhase = learningPhase;
  }

  @override
  _WordSetLearnPage createState() => _WordSetLearnPage(learningClassification: learningClassification, learningPhase: learningPhase);
}


enum TtsState { playing, stopped, paused, continued }

class _WordSetLearnPage extends State<WordSetLearnPage> {

  _WordSetLearnPage({String learningClassification:'', String learningPhase:''}) {
    this._learningClassification = learningClassification;
    this._learningPhase = learningPhase;
  }


  List<int> _sstIndex = [0, 0];

  List<String> _ipaAboutList = ['我要不要帶點東西參加派對\nShall I bring anything to the party?','This is a sentance on here.','This is a sentance la.'];

  String _learningClassification = '';
  String _learningPhase = '';
  late double _progress;
  List _wordData = [
    {
      "wordRanking": 101,
      "word": " a",
      "wordType": "None",
      "wordLevel": "None",
      "wordIPA": "ə",
      "wordMeaningList": []
    },
  ];


  List<String> _questionIPATextList = ['aa31, bb31', 'aa32, bb32'];
  List<String> _questionChineseTextList = ['aa31, bb31', 'aa32, bb32'];
  List<String> _answerTextList = ['aa31, bb31', 'aa32, bb32'];
  List<String> _answerIPATextList = ['aa31, bb31', 'aa32, bb32'];
  List<String> _questionTextList = ['aa11, bb11', 'aa12, bb12'];
  List<List<TextSpan>> _questionTextWidgetList = [
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
  ];
  List<List<TextSpan>> _questionIPATextWidgetList = [
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
  ];
  List<List<TextSpan>> _questionChineseTextWidgetList = [
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
  ];
  List<List<TextSpan>> _answerTextWidgetList = [
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
  ];
  List<List<TextSpan>> _answerIPATextWidgetList = [
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
    [TextSpan(text: ''), TextSpan(text: '')],
  ];


  int _wordIndex = 0;


  var _allowTouchButtons = {
    'reListenButton' : true,
    'speakButton' : true,
    'arrowButton' : true,
    'updateSentanceButton' : true,
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
    initWordSetLearnPage();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    flutterTts.stop();
    speechToText.stop();
  }

  Future<void> initWordSetLearnPage() async {
    initApplicationSettingsData();
    initTts();
    initSpeechState();
    await initWordData();
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

  Future<void> initWordData() async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');

    try {
      List wordData = [];
      _progress = 0;

      var getWordLearning;
      do {
        String getWordLearningJSON = await APIUtil.getWordLearning(_learningClassification, _learningPhase);
        getWordLearning = jsonDecode(getWordLearningJSON.toString());
        print('getWordLearning 6 apiStatus:' + getWordLearning['apiStatus'] + ' apiMessage:' + getWordLearning['apiMessage']);
        await Future.delayed(Duration(seconds: 1));
      } while (getWordLearning['apiStatus'] != 'success');
      wordData.addAll(getWordLearning['data']);

      setState(() {
        _wordData = wordData;
      });
      updateSentanceList();

    } catch(e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('連線發生錯誤，請稍候再重試'),
      ));
    }

    EasyLoading.dismiss();
    return;


  }






  int animationController = 100;
  int animation = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('第${_learningPhase}集，${_wordIndex + 1}/${_wordData.length}' ),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 4,
                      child: Container(
                        //color: Colors.pink,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(0.0),
                            elevation: 2.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 32, right: 32,top: 16,bottom: 16),
                                  child: Column(
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          //text: _wordData[_wordIndex]['word'].toString(),
                                          text: _wordData[_wordIndex]['word'].toString(),
                                          style: TextStyle(
                                            fontSize: 40 ,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Divider(
                                          height: 1,
                                          thickness: 1,
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: '[${_wordData[_wordIndex]['wordIPA']}]',
                                          style: TextStyle(
                                            fontSize: 16 ,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Divider(
                                          height: 1,
                                          thickness: 1,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            //text: 'A1級\n[v.] 帶來',
                                            //text: '${_wordData[_wordIndex]['wordLevel']} 級\n${_wordData[_wordIndex]['wordMeaningList'][0]['pos']}',
                                            text: (_wordData[_wordIndex]['wordMeaningList'].length > 0 ) ? '${_wordData[_wordIndex]['wordLevel']} 級\n[${_wordData[_wordIndex]['wordMeaningList'][0]['pos']}] ${_wordData[_wordIndex]['wordMeaningList'][0]['meaning']}': 'NO Data',
                                            style: TextStyle(
                                              fontSize: 16 ,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Visibility(
                                  visible: ( (_wordIndex-1) >= 0 ),
                                  child: Positioned(
                                    left: 0,
                                    width: 50,
                                    height: 50,
                                    child: IconButton(
                                      color: Colors.grey,
                                      iconSize: 25,
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () async {
                                        if(_allowTouchButtons['arrowButton']!){
                                          changeWordIndex('Previous');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: ( (_wordIndex+1) < _wordData.length ),
                                  //visible: true,
                                  child: Positioned(
                                    right: 0,
                                    width: 50,
                                    height: 50,
                                    child: IconButton(
                                      color: Colors.grey,
                                      iconSize: 25,
                                      icon: Icon(Icons.arrow_forward),
                                      onPressed: () async {
                                        if(_allowTouchButtons['arrowButton']!) {
                                          changeWordIndex('Next');
                                        }
                                      },
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Container(
                        //color: Colors.green,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              /*
                            Card(
                              color: Colors.white,
                                margin: EdgeInsets.all(0.0),
                                elevation: 2.0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: SELSAppTheme.white,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Explanation 解釋: ',
                                        style: TextStyle(
                                          fontSize: 16 ,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      Text(
                                        'Come to lace with (someone or something)',
                                        style: TextStyle(
                                          fontSize: 20 ,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                               */

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                              Card(
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
                                              'Sentance 句子練習: ',
                                              style: TextStyle(
                                                fontSize: 16 ,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              color: Colors.grey,
                                              iconSize: 25,
                                              icon: Icon(Icons.refresh_outlined),
                                              onPressed: () {
                                                if(_allowTouchButtons['updateSentanceButton']!){
                                                  updateSentanceList();
                                                }
                                              },
                                            ),
                                            Visibility(
                                              visible: (_questionTextList.length == 0),
                                              child: Text(
                                                'No sentance found',
                                                style: TextStyle(
                                                  fontSize: 14 ,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Divider(
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      Container(
                                        child: ListView.builder(
                                          physics: new NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemExtent: 250,
                                          itemCount: _questionTextList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: Card(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 9,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.all(4),
                                                              child: RichText(
                                                                  text: TextSpan(
                                                                    text: '',
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                      color: Color(0xFF2633C5),
                                                                    ),
                                                                    children: _questionTextWidgetList[index],
                                                                  ),
                                                                ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child:Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.all(4),
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: '',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Color(0xFF2633C5),
                                                                  ),
                                                                  children: _questionChineseTextWidgetList[index],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.all(4),
                                                              child: RichText(
                                                                      text: TextSpan(
                                                                        text: '',
                                                                        style: TextStyle(
                                                                          fontSize: 16,
                                                                          color: Color(0xFF2633C5),
                                                                        ),
                                                                        children: _questionIPATextWidgetList[index],
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 0,
                                                            thickness: 1,
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.all(4),
                                                              //color:Colors.grey,
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: '',
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Color(0xFF2633C5),
                                                                  ),
                                                                  children: _answerTextWidgetList[index],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.all(4),
                                                              //color:Colors.grey,
                                                              child: RichText(
                                                                      text: TextSpan(
                                                                        text: '',
                                                                        style: TextStyle(
                                                                          fontSize: 16,
                                                                          color: Color(0xFF2633C5),
                                                                        ),
                                                                        children: _answerIPATextWidgetList[index],
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 3,
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
                                                                      //icon: Icon(Icons.volume_off_outlined ),
                                                                      icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                                      color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                                      onPressed: () async {
                                                                        if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                                          ttsRateSlow = !ttsRateSlow;
                                                                          await _ttsSpeak(_questionTextList[index], 'en-US');
                                                                        }},
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
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
                                                              )
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
                                      )
                                    ],
                                  ),
                                ),
                              ),

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
      _allowTouchButtons['arrowButton'] = false;
      _allowTouchButtons['updateSentanceButton'] = false;
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
      _allowTouchButtons['arrowButton'] = true;
      _allowTouchButtons['updateSentanceButton'] = true;
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


  void changeWordIndex(String type){

    int wordIndex = _wordIndex;

    switch(type){
      case 'Previous':
        ( (wordIndex-1) >= 0 )? wordIndex-- : null;
        setState(() {
          _wordIndex = wordIndex;
        });
        break;
      case 'Next':
        ( (wordIndex+1) < _wordData.length )? wordIndex++ : null;
        setState(() {
          _wordIndex = wordIndex;
        });
        break;
    }
    updateSentanceList();
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
      _allowTouchButtons['arrowButton'] = false;
      _allowTouchButtons['updateSentanceButton'] = false;
    });

    String checkSentencesJSON = await APIUtil.checkSentences(_questionTextList[_sstIndex[1]], text, correctCombo:_correctCombo);
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
        _questionIPATextWidgetList[_sstIndex[1]] = questionIPATextWidget;
        _answerTextWidgetList[_sstIndex[1]] = [ TextSpan(text: text), TextSpan(text: '') ];
        _answerIPATextWidgetList[_sstIndex[1]] = answerIPATextWidget;

        ttsRateSlow = false;
        _allowTouchButtons['reListenButton'] = true;
        _allowTouchButtons['speakButton'] = true;
        _allowTouchButtons['arrowButton'] = true;
        _allowTouchButtons['updateSentanceButton'] = true;
      });

      await _ttsSpeak(checkSentences['data']['scoreComment']['text'] , 'en-US');

      setState(() {
        _allowTouchButtons['speakButton'] = true;
      });

    } else {
      print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      sleep(Duration(seconds:1));
      _responseChatBot(text);
    }

  }




  Future<void> updateSentanceList() async {
    setState(() {
      _allowTouchButtons['updateSentanceButton'] = false;
      _allowTouchButtons['arrowButton'] = false;
      _questionTextList = [];
    });
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try{
      var getSentences;
      do {
        String getSentencesJSON = await APIUtil.getSentences(sentenceRankingLocking:_wordData[_wordIndex]['wordRanking'].toString(), sentenceMaxLength:'12', dataLimit:'3');
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('updateSentanceList 1 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        if(getSentences['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getSentences['apiStatus'] != 'success');

      List<String> questionTextList = [];
      List<String> questionIPATextList = [];
      List<String> questionChineseTextList = [];
      List<List<TextSpan>> questionTextWidgetList = [];
      List<List<TextSpan>> questionIPATextWidgetList = [];
      List<List<TextSpan>> questionChineseTextWidgetList = [];
      List<List<TextSpan>> answerTextWidget = [];
      List<List<TextSpan>> answerIPATextWidgetList = [];


      getSentences['data'].forEach((element) {
        questionTextList.add('${element['sentenceContent']}');
        questionIPATextList.add('${element['sentenceIPA']}');
        questionChineseTextList.add('${element['sentenceChinese']}');
        questionTextWidgetList.add([TextSpan(text: '${element['sentenceContent']}')]);
        questionIPATextWidgetList.add([TextSpan(text: '[${element['sentenceIPA']}]')]);
        questionChineseTextWidgetList.add([TextSpan(text: '${element['sentenceChinese']}')]);
        answerTextWidget.add([ TextSpan(text: ''), TextSpan(text: '') ]);
        answerIPATextWidgetList.add([ TextSpan(text: ''), TextSpan(text: '') ]);
      });


      setState(() {

        _questionTextList = questionTextList;
        _questionIPATextList = questionIPATextList;
        _questionChineseTextList = questionChineseTextList;
        _questionTextWidgetList = questionTextWidgetList;
        _questionIPATextWidgetList = questionIPATextWidgetList;
        _questionChineseTextWidgetList = questionChineseTextWidgetList;
        _answerTextList = [''];
        _answerIPATextList = [''];
        _answerTextWidgetList = answerTextWidget;
        _answerIPATextWidgetList = answerIPATextWidgetList;
      });
    } catch(e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('連線發生錯誤，請稍候再重試'),
      ));
    }
    EasyLoading.dismiss();
    setState(() {
      _allowTouchButtons['updateSentanceButton'] = true;
      _allowTouchButtons['arrowButton'] = true;
    });
    return;
  }

}