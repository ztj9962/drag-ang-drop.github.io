

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sels_app/sels_app/utils/APIUtil.dart';
import 'package:sels_app/sels_app/utils/SharedPreferencesUtil.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class GrammarCheckPage extends StatefulWidget {
  @override
  _GrammarCheckPage createState() => _GrammarCheckPage();
}

enum TtsState { playing, stopped, paused, continued }

class _GrammarCheckPage extends State<GrammarCheckPage> {
  final TextEditingController _textInputController = new TextEditingController();

  List<TextSpan> _sentenceTextCheckedWidget = [ TextSpan(text: ''), ];
  bool _applicationSettingsGrammarCheckPageIntroduce = true;
  String _sentenceTextOriginal = '';
  String _sentenceTextChecked = '';
  bool _viewAPIResult = false;


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
    initApplicationSettingsData();
    initTts();
    initSpeechState();
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
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsVolume').then((value) {
      setState(() => ttsVolume = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsPitch').then((value) {
      setState(() => ttsPitch = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsRate').then((value) {
      setState(() => ttsRate = value!);
    });
    SharedPreferencesUtil.getData<bool>('applicationSettingsGrammarCheckPageIntroduce').then((value) {
      setState(() => _applicationSettingsGrammarCheckPageIntroduce = value!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('文法校正' ),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                            child: Card(
                              color: Colors.white,
                              margin: EdgeInsets.all(0.0),
                              elevation: 2.0,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
                                        child: TextField(
                                          autofocus: true,
                                          maxLines: 10,
                                          decoration: InputDecoration(
                                              border:InputBorder.none,
                                              hintText: '請在這輸入要進行文法校正的句子......'
                                          ),
                                          controller: _textInputController,
                                          onChanged: (String value) {
                                            _handleSubmitted(value, isFinalResult:true);
                                          },
                                          //onEditingComplete: (){print('onEditingComplete');},
                                          //onSubmitted: (String value){print('onSubmitted');},
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        width: 50,
                                        height: 50,
                                        child: Visibility(
                                          visible: (_textInputController.text != ""),
                                          child: IconButton(
                                            color: Colors.grey,
                                            iconSize: 25,
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                _sentenceTextCheckedWidget = [ TextSpan(text: ''), ];
                                                _viewAPIResult = false;
                                                _textInputController..text = "";
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        width: 50,
                                        height: 50,
                                        child: IconButton(
                                          color: Colors.grey,
                                          iconSize: 25,
                                          icon: Icon( (_allowTouchButtons['voiceInputButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.mic : Icons.mic_none) : Icons.mic_off_outlined ),
                                          onPressed: () {
                                            if(_allowTouchButtons['voiceInputButton']! && !isPlaying ){
                                              if( !_sttHasSpeech || speechToText.isListening ){
                                                sttStopListening();
                                              } else {
                                                sttStartListening();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _viewAPIResult,
                      child: Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(0.0),
                            elevation: 2.0,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: '這裡是建議的結果：\n',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF2633C5),
                                                ),
                                                children: _sentenceTextCheckedWidget,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            width: 50,
                                            height: 50,
                                            child: IconButton(
                                              color: Colors.grey,
                                              iconSize: 25,
                                              icon: Icon( (_allowTouchButtons['listenResultButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                              onPressed: () async {
                                                if(_allowTouchButtons['listenResultButton']! && !speechToText.isListening ){
                                                  ttsRateSlow = false;
                                                  await _ttsSpeak(_sentenceTextChecked, 'en-US');
                                                }
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            width: 50,
                                            height: 50,
                                            child: IconButton(
                                              color: Colors.grey,
                                              iconSize: 25,
                                              icon: Icon(Icons.content_copy_outlined),
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(text: _sentenceTextChecked));
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('複製成功！'),
                                                ));
                                              },
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: _applicationSettingsGrammarCheckPageIntroduce,
                child: Stack(
                    children: <Widget>[
                      Dismissible(
                          key: ValueKey('GrammarCheckPage_Introduce_01'),
                          onDismissed: (DismissDirection direction){
                            setState(() => _applicationSettingsGrammarCheckPageIntroduce = false);
                            SharedPreferencesUtil.saveData<bool>('applicationSettingsGrammarCheckPageIntroduce', _applicationSettingsGrammarCheckPageIntroduce);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('讓我們開始吧！'),
                            ));
                          },
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

    _textInputController..text = result.recognizedWords;
    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
      //print(sttLastWords);
      _viewAPIResult = false;
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

  void _handleSubmitted(String text, {bool isFinalResult:false}) {
    if(isFinalResult){
      //print('submit: '+text);
      _responseAPI(text);
    } else {
      _textInputController..text = text;
    }
  }


  void _responseAPI(text) async {

    String checkGrammarJSON = await APIUtil.checkGrammar(text);
    var checkGrammar = jsonDecode(checkGrammarJSON.toString());

    //print(checkGrammarJSON);

    if(checkGrammar['apiStatus'] == 'success'){

      var sentenceTextOriginalArray = checkGrammar['data']['sentenceTextOriginalArray'];
      var sentenceTextCheckedArray = checkGrammar['data']['sentenceTextCheckedArray'];

      List<TextSpan> sentenceTextCheckedWidget = [];
      for (var i = 0; i < sentenceTextCheckedArray.length; i++) {
        if(sentenceTextOriginalArray[i] != sentenceTextCheckedArray[i]){
          sentenceTextCheckedWidget.add(
              TextSpan(
                text: sentenceTextOriginalArray[i],
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              )
          );
          sentenceTextCheckedWidget.add(
              TextSpan(
                text: sentenceTextCheckedArray[i],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
          );
        } else {
          sentenceTextCheckedWidget.add(TextSpan(text: sentenceTextCheckedArray[i]));
        }
      }


      setState(() {
        _allowTouchButtons['listenResultButton'] = true;
        _sentenceTextCheckedWidget = sentenceTextCheckedWidget;
        _sentenceTextOriginal = checkGrammar['data']['sentenceTextOriginal'];
        _sentenceTextChecked = checkGrammar['data']['sentenceTextChecked'];
        _viewAPIResult = true;
      });

    } else {
      print('_responseAPI Error apiStatus:' + checkGrammar['apiStatus'] + ' apiMessage:' + checkGrammar['apiMessage']);
      //sleep(Duration(seconds:1));
      //_responseAPI(text);
    }



  }


}
