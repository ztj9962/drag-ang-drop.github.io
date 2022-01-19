

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

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:sels_app/sels_app/pages/syllable_practice_learn_page.dart';
import 'package:sels_app/sels_app/pages/syllable_practice_word_page.dart';

class SyllablePracticeWordPage extends StatefulWidget {
  @override
  _SyllablePracticeWordPage createState() => _SyllablePracticeWordPage();
}

class _SyllablePracticeWordPage extends State<SyllablePracticeWordPage> {
  final searchWordController = TextEditingController();

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


  final List<bool> isSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchWordController.dispose();
    super.dispose();
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
                          flex: 3,
                          child: SingleChildScrollView(
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
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: '尋找相似的單詞',
                                          hintText: '請輸入要尋找相似的單詞',
                                        ),
                                        controller: searchWordController,
                                      ),
                                    ),
                                    Divider(
                                      height: 20,
                                      thickness: 1,
                                    ),
                                  ]
                              )
                          )
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
                            child: Container(
                              margin: EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.6),
                                    blurRadius: 8,
                                    offset: const Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    updateWordList(3);
                                  },
                                  child: const Center(
                                    //child: Icon(Icons.save),
                                    child: Text('開始尋找單詞相似字'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: Container(
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
                                    children: _questionTextWidgetList[0][0],
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
                                    children: _questionIPATextWidgetList[0][0],
                                  ),
                                ),
                              ),
                              Padding(padding: const EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16)),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: '',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF2633C5),
                                    ),
                                    children: _questionTextWidgetList[0][1],
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
                                    children: _questionIPATextWidgetList[0][1],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ]
        )
    );
  }

  Future<void> updateWordList(index) async {
    String word1 = searchWordController.text;

    if(word1 == '') {
      EasyLoading.dismiss();
      return;
    }

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
    });

    EasyLoading.dismiss();
    return;
  }
}