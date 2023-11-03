import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VocabularyMatchUpPracticePage extends StatefulWidget {
  const VocabularyMatchUpPracticePage(
      {Key? key, required this.minRank, required this.maxRank})
      : super(key: key);
  final int minRank;
  final int maxRank;

  @override
  _VocabularyMatchUpPracticePageState createState() =>
      _VocabularyMatchUpPracticePageState();
}

class _VocabularyMatchUpPracticePageState
    extends State<VocabularyMatchUpPracticePage> {
  late int _minRange;
  late int _maxRange;
  List<String> _questionList = [
    'walk',
    'choice',
    'market',
    'those',
    'shake',
    'window',
    'toy',
    'cookie',
    'wise',
    'health',
  ];
  List<String> _answerList = [
    '走路',
    '上等的,精選的;挑三揀四的',
    '市場',
    '那些的;那;',
    '搖動;奶昔',
    '窗戶',
    '玩具',
    '餅乾',
    '有智慧的',
    '健康',
  ];
  Map<String, String> _pairedAnswerMap = {
    'walk': '走路',
    'choice': '上等的,精選的;挑三揀四的',
    'market': '市場',
    'those': '那些的;那;',
    'shake': '搖動;奶昔',
    'window': '窗戶',
    'toy': '玩具',
    'cookie': '餅乾',
    'wise': '有智慧的',
    'health': '健康',
  };
  Map<String, String> _connectStatusQAMap = {};
  Map _connectedStatusResultMap = {};
  Map<GlobalKey, GlobalKey> _connectedStatusGlobalKeyMap = {};
  List<GlobalKey> _globalQuestion = [];
  List<GlobalKey> _globalAnswer = [];

  Offset dragAnchorStrategy(
      Draggable<Object> d, BuildContext context, Offset point) {
    return Offset(d.feedbackOffset.dx + 5, d.feedbackOffset.dy + 5);
  }

  @override
  void initState() {
    _minRange = widget.minRank;
    _maxRange = widget.maxRank;
    super.initState();
    initVocabularyMatchUpPracticePage(_minRange, _maxRange);
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PageTheme.app_theme_black,
          centerTitle: true,
          title: AutoSizeText(
            '單字連連看',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: CustomPaint(
          painter: LineDrawer(_globalQuestion, _connectedStatusGlobalKeyMap, _connectedStatusResultMap, _questionList),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 800,
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: PageTheme.app_theme_blue,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 200,
                                child: ListView.separated(
                                  //shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _questionList.length,
                                  itemBuilder: (context, index) {
                                    _globalQuestion.add(GlobalKey());
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: PageTheme.app_theme_blue,
                                                width: 1,
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(16.0)),
                                            ),
                                            child: AutoSizeText(
                                                _questionList[index].toString()),
                                          ),
                                        ),
                                        //Dragable
                                        Container(
                                          height: 40,
                                          width: 40,
                                          color: Colors.transparent,
                                          child: Draggable(
                                            key: _globalQuestion[index],
                                            dragAnchorStrategy: dragAnchorStrategy,
                                            child: Center(
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    color: PageTheme.app_theme_blue,
                                                    border: Border.all(),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(30))),
                                              ),
                                            ),
                                            feedback: Center(
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    color: PageTheme.app_theme_blue,
                                                    border: Border.all(),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(30))),
                                              ),
                                            ),
                                            childWhenDragging: Center(
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow,
                                                    border: Border.all(),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(30))),
                                              ),
                                            ),
                                            data: index,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Padding(
                                        padding: EdgeInsets.all(8));
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(16)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 200,
                                child: ListView.separated(
                                  //shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _answerList.length,
                                  itemBuilder: (context, index) {
                                    _globalAnswer.add(GlobalKey());
                                    return Row(
                                      children: [
                                        //DragTarget
                                        Container(
                                          height: 40,
                                          width: 40,
                                          color: Colors.transparent,
                                          child: DragTarget(
                                            key: _globalAnswer[index],
                                            builder: (context, candidateData,
                                                rejectedData) {
                                              return Center(
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                      color: Colors.greenAccent,
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(30))),
                                                ),
                                              );
                                            },
                                            onWillAccept: (condition) {
                                              return true;
                                            },
                                            onAccept: (int dragIndex) {
                                              setState(() {
                                                _connectedStatusGlobalKeyMap[_globalQuestion[dragIndex]] = _globalAnswer[index];
                                                _connectStatusQAMap[_questionList[dragIndex]] = _answerList[index];
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: PageTheme.app_theme_blue,
                                                width: 1,
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(16.0)),
                                            ),
                                            child: AutoSizeText(
                                                _answerList[index].toString()),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Padding(
                                        padding: EdgeInsets.all(8));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor:
                      PageTheme.app_theme_blue,
                      radius: 30.0,
                      child: IconButton(
                        icon: Icon(
                            Icons.analytics_outlined,
                            size: 30),
                        color: Colors.white,
                        onPressed: () {
                          for(String question in _questionList){
                            if(_connectStatusQAMap[question] == null){
                            }else if(_connectStatusQAMap[question] != _pairedAnswerMap[question]){
                              setState(() {
                                _connectedStatusResultMap[question] = false;
                              });
                            }else{
                              setState(() {
                                _connectedStatusResultMap[question] = true;
                              });
                            }
                          }
                          setState(() {

                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(child: AutoSizeText('提交'))
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> initVocabularyMatchUpPracticePage(
      int minRank, int maxRank) async {
    /*
      EasyLoading.show(status: '正在讀取資料，請稍候......');
      var jsonFormatted;
      do {
        String jsonString = await APIUtil.getMatchUpQuestion(_minRange.toString(),_maxRange.toString(),'10');
        jsonFormatted = jsonDecode(jsonString.toString());
        if (jsonFormatted['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (jsonFormatted['apiStatus'] != 'success');

      EasyLoading.dismiss();

      setState(() {

      });*/
  }
}

class LineDrawer extends CustomPainter {
  final List<GlobalKey> dragGlobalKeyList;
  final Map<GlobalKey, GlobalKey> connectedStatusGlobalKeyMap;
  final Map connectedStatusResultMap;
  final List<String> questionList;

  LineDrawer(
    this.dragGlobalKeyList,
    this.connectedStatusGlobalKeyMap,
    this.connectedStatusResultMap,
    this.questionList,
  );

  @override
  void paint(Canvas canvas, Size size) {
    print(connectedStatusResultMap);
    int index = 0;
    for(GlobalKey key in dragGlobalKeyList){
      if (connectedStatusGlobalKeyMap[key] != null) {
        RenderBox renderBoxQuestion = key.currentContext?.findRenderObject() as RenderBox;
        RenderBox renderBoxAnswer = connectedStatusGlobalKeyMap[key]?.currentContext?.findRenderObject() as RenderBox;
        Offset dragOffset = renderBoxQuestion.localToGlobal(Offset.zero);
        Offset targetOffset = renderBoxAnswer.localToGlobal(Offset.zero);
        Paint pan = Paint()..color = Colors.black45..strokeWidth = 8.0;
        switch(connectedStatusResultMap[questionList[index]]){
          case true:
            pan = Paint()..color = Colors.greenAccent..strokeWidth = 8.0;
            break;
          case false:
            pan = Paint()..color = Colors.redAccent..strokeWidth = 8.0;
            break;
          default:
            pan = Paint()..color = Colors.black45..strokeWidth = 8.0;
            break;
        }
        canvas.drawLine(
          Offset(dragOffset.dx + 20, dragOffset.dy - 35),
          Offset(targetOffset.dx + 20, targetOffset.dy - 35),
          pan,
        );
      }
      index++;
    }
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
