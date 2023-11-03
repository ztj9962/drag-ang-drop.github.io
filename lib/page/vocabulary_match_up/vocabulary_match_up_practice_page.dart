import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
  late int _minRank;
  late int _maxRank;
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
  var _draggableNow = true;

  //滑鼠跟蹤特效
  Offset _mouseStart = Offset.zero;
  Offset _mouseCurrent = Offset.zero;
  //結算數據
  int _resultNoConnect = 0;
  int _resultWrong = 0;
  int _resultRight = 0;
  //特效判斷
  var _waitUserConnect = true;
  var _userConnecting = false;

  Offset dragAnchorStrategy(
      Draggable<Object> d, BuildContext context, Offset point) {
    return Offset(d.feedbackOffset.dx + 5, d.feedbackOffset.dy + 5);
  }

  @override
  void initState() {
    _minRank = widget.minRank;
    _maxRank = widget.maxRank;
    super.initState();
    awaitInit();
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
          child: CustomPaint(
            painter: MouseTracker(_mouseStart,_mouseCurrent),
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
                                                color: HexColor('#BDD6FF'),
                                                border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(16.0)),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                      _questionList[index].toString(),style: TextStyle(fontSize: 30),),
                                                ),
                                              ),
                                            ),
                                          ),
                                          //Dragable
                                          Container(
                                            height: 40,
                                            width: 40,
                                            color: Colors.transparent,
                                            child:
                                                Draggable(
                                                  key: _globalQuestion[index],
                                                  dragAnchorStrategy: dragAnchorStrategy,
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        border: Border.all(color: Colors.transparent),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(30))),
                                                    child: Center(
                                                      child: AvatarGlow(
                                                        glowColor: Colors.blue,
                                                        endRadius: (_waitUserConnect) ? 60.0 : 5,
                                                        duration: Duration(milliseconds: 2000),
                                                        repeat: true,
                                                        showTwoGlows: false,
                                                        repeatPauseDuration: Duration(milliseconds: 200),
                                                        child: Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration: BoxDecoration(
                                                              color: (_draggableNow) ? PageTheme.app_theme_blue : Colors.grey,
                                                              border: Border.all(),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(30))),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  feedback: Center(
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                          color: (_draggableNow) ? PageTheme.app_theme_blue : Colors.grey,
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
                                                          color: (_draggableNow) ? Colors.yellow : Colors.grey,
                                                          border: Border.all(),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(30))),
                                                    ),
                                                  ),
                                                  data: index,
                                                  onDragStarted: (){
                                                    RenderBox renderBox = _globalQuestion[index]?.currentContext?.findRenderObject() as RenderBox;
                                                    Offset dragOffset = renderBox.localToGlobal(Offset.zero);
                                                    setState(() {
                                                      _mouseStart = dragOffset;
                                                      _mouseCurrent = dragOffset;
                                                      _waitUserConnect = false;
                                                    });
                                                  },
                                                  onDragUpdate: (detail){
                                                    setState(() {
                                                      _mouseCurrent = detail.localPosition;
                                                      _waitUserConnect = false;
                                                    });
                                                  },
                                                  onDragEnd: (detail){
                                                    setState(() {
                                                      _mouseStart = Offset.zero;
                                                      _mouseCurrent = Offset.zero;
                                                      _waitUserConnect = true;
                                                    });
                                                  },
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
                                                  child: AvatarGlow(
                                                    glowColor: Colors.green,
                                                    endRadius: (_waitUserConnect) ? 5 : 90.0,
                                                    duration: Duration(milliseconds: 2000),
                                                    repeat: true,
                                                    showTwoGlows: false,
                                                    repeatPauseDuration: Duration(milliseconds: 100),
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                          color: (_draggableNow) ? Colors.greenAccent : Colors.grey,
                                                          border: Border.all(),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(30))),
                                                    ),
                                                  ),
                                                );
                                              },
                                              onWillAccept: (condition) {
                                                return _draggableNow;
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
                                                color:  HexColor('#A9DAAB'),
                                                border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1,
                                                ),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(16.0)),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                      _answerList[index].toString(),style: TextStyle(fontSize: 30),),
                                                ),
                                              ),
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
                    Padding(padding: EdgeInsets.all(20)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(20)),
                          Expanded(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  PageTheme.app_theme_blue,
                                  radius: 30.0,
                                  child: IconButton(
                                    icon: Icon(
                                        Icons.fact_check_outlined,
                                        size: 30),
                                    color: Colors.white,
                                    onPressed: () {
                                      for(String question in _questionList){
                                        if(_connectStatusQAMap[question] == null){
                                          setState(() {
                                            _resultNoConnect++;
                                          });
                                        }else if(_connectStatusQAMap[question] != _pairedAnswerMap[question]){
                                          setState(() {
                                            _resultWrong++;
                                            _connectedStatusResultMap[question] = false;
                                          });
                                        }else{
                                          setState(() {
                                            _resultRight++;
                                            _connectedStatusResultMap[question] = true;
                                          });
                                        }
                                      }
                                      setState(() {
                                        _draggableNow = false;
                                        _waitUserConnect = false;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(child: AutoSizeText('提交'))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  PageTheme.app_theme_blue,
                                  radius: 30.0,
                                  child: IconButton(
                                    icon: Icon(
                                        Icons.restart_alt,
                                        size: 30),
                                    color: Colors.white,
                                    onPressed: () {
                                        resetQuestion();
                                    },
                                  ),
                                ),
                                Expanded(child: AutoSizeText('重新作答'))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  PageTheme.app_theme_blue,
                                  radius: 30.0,
                                  child: IconButton(
                                    icon: Icon(
                                        Icons.skip_next,
                                        size: 30),
                                    color: Colors.white,
                                    onPressed: () {
                                      awaitInit();
                                    },
                                  ),
                                ),
                                Expanded(child: AutoSizeText('下一題'))
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(20)),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    Divider(thickness: 1,color: PageTheme.app_theme_blue,),

                    AutoSizeText('回答正確:${_resultRight}'),
                    AutoSizeText('回答錯誤:${_resultWrong}'),
                    AutoSizeText('未連接:${_resultNoConnect}'),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
  void awaitInit() async {
    await initVocabularyMatchUpPracticePage(_minRank, _maxRank);
  }

  void resetQuestion () {
    setState(() {
  _connectedStatusResultMap = {};
  _connectedStatusGlobalKeyMap = {};
  _draggableNow = true;
  _resultRight = 0;
  _resultWrong = 0;
  _resultNoConnect = 0;
  _waitUserConnect = true;
    });
}

  Future<void> initVocabularyMatchUpPracticePage(
      int minRank, int maxRank) async {
      EasyLoading.show(status: '正在讀取資料，請稍候......',maskType: EasyLoadingMaskType.black,);
      var jsonFormatted;
      do {
        String jsonString = await APIUtil.getMatchUpQuestion(_minRank.toString(),_maxRank.toString(),'10');
        jsonFormatted = jsonDecode(jsonString.toString());
        if (jsonFormatted['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (jsonFormatted['apiStatus'] != 'success');

      EasyLoading.dismiss();

      setState(() {
        _resultRight = 0;
        _resultWrong = 0;
        _resultNoConnect = 0;
        _connectedStatusResultMap = {};
        _connectedStatusGlobalKeyMap = {};
        _draggableNow = true;
        _questionList = (jsonFormatted['data']['questionShuffledEnglishList'] as List).map((item) => item as String).toList();
        _answerList = (jsonFormatted['data']['questionShuffledChineseList'] as List).map((item) => item as String).toList();
        _pairedAnswerMap =( jsonFormatted['data']['originQuestionDict'] as Map).map((key, value) => MapEntry(key.toString(), value.toString()));
      });
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

class MouseTracker extends CustomPainter {
  final Offset dragOffset;
  final Offset targetOffset;

  MouseTracker(this.dragOffset, this.targetOffset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(dragOffset.dx + 20, dragOffset.dy - 35),
      Offset(targetOffset.dx , targetOffset.dy - 55),
      Paint()..color = Colors.black45..strokeWidth = 8.0,
    );
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
