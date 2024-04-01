import 'dart:convert';
import 'dart:io';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VocabularydragangdroppPracticePage extends StatefulWidget {
  const VocabularydragangdroppPracticePage(
      {Key? key, required this.minRank, required this.maxRank, required this.value})
      : super(key: key);
  final int minRank;
  final int maxRank;
  final int value;
  @override
  _VocabularydragangdroppPracticePageState createState() => _VocabularydragangdroppPracticePageState();
}


class _VocabularydragangdroppPracticePageState
    extends State<VocabularydragangdroppPracticePage> {

  late int _minRank;
  late int _maxRank;
  late int _value;
  int page=1;
  Map<int, List<String>> _questionList = {};
  Map<int, List<String>> _answerList = {};
  Map<int, Map<String,String>> _pairedAnswerMap = {};
  Map<int, Map<String,String?>> _connectStatusQAMap ={};
  
  Map<int, Map> _info= {};
  Map<int, Map> _color={};
  Map<int, Map> _color1={};
  //判斷用變數
  Map<int, bool> _inQuiz={};
  Map<int, bool> _waitUserConnect={};
  Map<int, bool> _draggableNow={};
  //結算數據
  Map _resultNoConnect={};
  Map _resultWrong={};
  Map _result={};
  bool initial=true;
  int total1=0;
  int total2=0;
  int total3=0;


  Map _connectStatusQAMaptedStatusResultMap = {};
  Map<GlobalKey, GlobalKey> _connectStatusQAMaptedStatusGlobalKeyMap = {};
  List<GlobalKey> _globalQuestion = [];
  List<GlobalKey> _globalAnswer = [];

  double _scrolledOffset = 0.0;

  //滑鼠跟蹤特效
  Offset _mouseStart = Offset.zero;
  Offset _mouseCurrent = Offset.zero;

  //螢幕尺寸判斷
  GlobalKey _mainContainerKey = GlobalKey();
  Offset _parentOffset = Offset.zero;

  ScrollController _scrollController = ScrollController();

  Offset dragAnchorStrategy(
      Draggable<Object> d, BuildContext context, Offset point) {
    return Offset(d.feedbackOffset.dx + 210, d.feedbackOffset.dy + 25);
  }

  @override
  void initState() {
    super.initState();
    _minRank = widget.minRank;
    _maxRank = widget.maxRank;
    _value = widget.value;
    _scrollController.addListener(() {
      setState(() {
        _scrolledOffset = _scrollController.offset;
      });
    });
    super.initState();
    //初始化座標偏移
    WidgetsBinding.instance

        .addPostFrameCallback((_) {
      //RenderBox parentRender = _mainContainerKey?.currentContext?.findRenderObject() as RenderBox;
      //Offset parentOffset = parentRender.localToGlobal(Offset.zero);
      setState((){
        //_parentOffset = parentOffset;
      });
    });
    Nextpage();

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
            'drag ang drop',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: CustomPaint(
            //painter: MouseTracker(_mouseStart,_mouseCurrent,_scrolledOffset,_parentOffset),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                //height: 1000,
                child: Column(
                  children: [
                    Container(
                      key: _mainContainerKey,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: PageTheme.app_theme_blue,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: CustomPaint(
                        //painter: LineDrawer(_globalQuestion, _connectStatusQAMaptedStatusGlobalKeyMap, _connectStatusQAMaptedStatusResultMap, _questionListList,_scrolledOffset,_parentOffset),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Container(
                                  width: 200,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _questionList[page]?.length??0,
                                    itemBuilder: (context, index) {
                                      _globalQuestion.add(GlobalKey());
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Draggable(
                                              key: _globalQuestion[index],
                                              dragAnchorStrategy: dragAnchorStrategy,
                                              child: Container(
                                                height: 50,

                                                decoration: BoxDecoration(
                                                  color:_color1[page]![index] != null
                                                      ?_color1[page]![index]
                                                      :HexColor('#BDD6FF'),
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
                                                      _questionList[page]![index].toString(),style: TextStyle(fontSize: 30),maxLines: 1,),

                                                  ),
                                                ),
                                              ),

                                              feedback: Center(
                                                child: Container(
                                                  height: 50,
                                                  width: 470,
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
                                                        _questionList[page]![index].toString(),style: TextStyle(fontSize: 30),maxLines: 1,),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                              childWhenDragging: Center(
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#EEEEEE'),
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
                                                        _questionList[page]![index].toString(),style: TextStyle(fontSize: 30),maxLines: 1,),
                                                    ),
                                                  ),
                                                ),
                                              ),



                                              data: index,
                                              onDragStarted: (){
                                                RenderBox renderBox = _globalQuestion[index]?.currentContext?.findRenderObject() as RenderBox;
                                                Offset dragOffset = renderBox.localToGlobal(Offset.zero);
                                                setState(() {
                                                  _mouseStart = dragOffset;
                                                  _mouseCurrent = dragOffset;
                                                  _waitUserConnect[page] = false;

                                                });
                                              },
                                              onDragUpdate: (detail){
                                                setState(() {
                                                  _mouseCurrent = detail.localPosition;
                                                  _waitUserConnect[page] = false;
                                                });
                                              },
                                              onDragEnd: (detail){
                                                setState(() {
                                                  _mouseStart = Offset.zero;
                                                  _mouseCurrent = Offset.zero;
                                                  _waitUserConnect[page] = true;


                                                });
                                              },
                                            ),
                                            ),
                                      Container(
                                        height: 50,
                                        //width: 440,
                                      )
                                        ],
                                      );
                                    },

                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const Padding(
                                          padding: EdgeInsets.all(12));
                                    },
                                  ),
                                ),
                              ),
                            ),


                            Padding(padding: EdgeInsets.all(16)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Container(
                                  width: 400,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _answerList[page]?.length??0,

                                    itemBuilder: (context, index) {
                                      _globalAnswer.add(GlobalKey());

                                      return Row(
                                        children: [
                                          //DragTarget
                                          Container(
                                            height: 50,
                                            //width: 400,
                                          ),
                                          Expanded(

                                            child: DragTarget(
                                              key: _globalAnswer[index],
                                              builder: (context, candidateData, rejectedData) {
                                                return Center(
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                  child: Container(
                                                      height: 50,
                                                      width: 870,
                                                      decoration: BoxDecoration(
                                                        color:_color[page]![index] != null
                                                            ?_color[page]![index]
                                                            :HexColor('#A9DAAB'),

                                                        border: Border.all(
                                                          color: Colors.transparent,
                                                          width: 1,
                                                        ),
                                                        borderRadius: const BorderRadius.all(
                                                            Radius.circular(16.0)),
                                                      ),
                                                      child: Center(
                                                        child: _info[page]![index] != null
                                                            ? AutoSizeText(
                                                          _info[page]![index].toString()+" :"+_answerList[page]![index].toString(), style: TextStyle(fontSize: 30,),maxLines: 1,
                                                        ) : AutoSizeText(
                                                          _answerList[page]![index].toString(),style: TextStyle(fontSize: 30),maxLines: 2,minFontSize: 20,),
                                                      )
                                                  ),
                                                  ),
                                                );

                                              },
                                              onWillAccept: (condition) {
                                                return _draggableNow[page]!;
                                              },
                                              onAccept: (int dragIndex ) {
                                                setState(() {
                                                  _connectStatusQAMaptedStatusGlobalKeyMap[_globalQuestion[dragIndex]] = _globalAnswer[index];

                                                  _connectStatusQAMap[page]![_questionList[page]![dragIndex]] = _answerList[page]![index];
                                                  for(int i=0;i<_questionList[page]!.length;i++){
                                                    if(_connectStatusQAMap[page]![_questionList[page]![i]]==_connectStatusQAMap[page]![_questionList[page]![dragIndex]] && i!=dragIndex){
                                                      _connectStatusQAMap[page]![_questionList[page]![i]] = null;
                                                    }
                                                  }

                                                  for(int i=0;i<_questionList[page]!.length;i++) {
                                                    if (_questionList[page]![i]==_info[page]![index]) {
                                                      _color1[page]![i] = null;
                                                    }
                                                  }
                                                  for(int i=0;i<_answerList[page]!.length;i++){
                                                    if(_info[page]![i]==_questionList[page]![dragIndex] && i!=index){
                                                      _info[page]![i]= null ;
                                                      _color[page]![i] = null ;

                                                    }else{
                                                      _info[page]![index]=_questionList[page]![dragIndex];
                                                      _color[page]![index] = HexColor('#00FFFF');
                                                      _color1[page]![dragIndex] = HexColor('#EEEEEE');
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          //Expanded(),
                                        ],
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const Padding(
                                          padding: EdgeInsets.all(4));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    Row(
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
                                      Icons.skip_previous,
                                      size: 25),
                                  color: Colors.white,
                                  onPressed: () {
                                    Previouspage();
                                  },
                                ),
                              ),
                              AutoSizeText('上一頁')
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
                                  disabledColor: CupertinoColors.secondaryLabel,
                                  icon: Icon(
                                      Icons.fact_check_outlined,
                                      size: 25),
                                  color: Colors.white,
                                  onPressed: (!(_inQuiz[page]??false)) ? null : () {
                                    for(int i=0;i<_answerList[page]!.length;i++){
                                      if(_connectStatusQAMap[page]![_info[page]![i]] == null){
                                        _color[page]![i] = null;
                                      }else if(_connectStatusQAMap[page]![_info[page]![i]] != _pairedAnswerMap[page]![_info[page]![i]]){
                                        _color[page]![i] = Colors.red;
                                      }else if(_connectStatusQAMap[page]![_info[page]![i]] == _pairedAnswerMap[page]![_info[page]![i]]){
                                        _color[page]![i] = Colors.green;
                                      }
                                    }
                                    for(String question in _questionList[page]!){

                                      print('${question}:${_connectStatusQAMap[page]![question]}');

                                      if(_connectStatusQAMap[page]![question] == null){
                                        setState(() {
                                          _resultNoConnect[page]++;
                                        });
                                      }else if(_connectStatusQAMap[page]![question] != _pairedAnswerMap[page]![question]){
                                        setState(() {

                                          _resultWrong[page]++;

                                          _connectStatusQAMaptedStatusResultMap[question] = false;
                                        });
                                      }else{
                                        setState(() {
                                          _result[page]++;
                                          _connectStatusQAMaptedStatusResultMap[question] = true;
                                        });
                                      }
                                    }
                                    setState(() {
                                      _draggableNow[page] = false;
                                      _waitUserConnect[page] = false;
                                      _inQuiz[page] = false;
                                      for(int i=1;i<=_value;i++) {
                                        total1 = _result[i] + total1;
                                        total2 = _resultWrong[i] + total2;
                                        total3 = _resultNoConnect[i] + total3;
                                      }
                                    });
                                  },

                                ),
                              ),
                              AutoSizeText('提交')
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
                                  child:AutoSizeText('${page}/${_value}')
                              ),

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
                                      size: 25),
                                  color: Colors.white,
                                  onPressed: () {
                                      resetQuestion();

                                  },
                                ),
                              ),

                              AutoSizeText('重新作答')
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
                                      size: 25),
                                  color: Colors.white,
                                  onPressed: () {
                                    Nextpage();
                                  },
                                ),
                              ),
                              AutoSizeText('下一頁')
                            ],
                          ),
                        ),

                        Padding(padding: EdgeInsets.all(20)),
                      ],
                    ),
                    //Padding(padding: EdgeInsets.all(5)),
                    Divider(thickness: 1,color: PageTheme.app_theme_blue,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check,color: Colors.greenAccent,),
                        AutoSizeText('回答正確:${total1}'),
                        Padding(padding: EdgeInsets.all(20)),
                        Icon(Icons.cancel_outlined,color: Colors.redAccent,),
                        AutoSizeText('回答錯誤:${total2}'),
                        Padding(padding: EdgeInsets.all(20)),
                        Icon(Icons.cable,color: Colors.redAccent,),
                        AutoSizeText('未作答:${total3}'),
                        Padding(padding: EdgeInsets.all(20)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          ));
  }

  void Nextpage() async {
    if(initial) {
      await initVocabularydragangdroppPracticePage(_minRank, _maxRank);
    }else {
      if(page<_value) {
        setState(() {
          page++;
        });
      }
    }
  }
  void Previouspage() async {
    if(page>1) {
      setState(() {
        page--;
      });
    }
  }

  void resetQuestion () {
    setState(() {
  _connectStatusQAMaptedStatusResultMap = {};
  _connectStatusQAMaptedStatusGlobalKeyMap = {};
  _connectStatusQAMap[page] ={};
  _info[page]= {};
  _color[page]= {};
  _color1[page]= {};
  _inQuiz[page]= true;
  _waitUserConnect[page]= true;
  _draggableNow[page]= true;
  _resultNoConnect[page]=0;
  _resultWrong[page]=0;
  _result[page]=0;
  total1=0;
  total2=0;
  total3=0;
  for(int i=1;i<=_value;i++) {
    total1 = _result[i] + total1;
    total2 = _resultWrong[i] + total2;
    total3 = _resultNoConnect[i] + total3;
  }


    });
}
  Future<void> initVocabularydragangdroppPracticePage(int minRank, int maxRank,) async {
    initial=false;
    EasyLoading.show(status: '正在讀取資料，請稍候......',maskType: EasyLoadingMaskType.black,);
    if(_value==0){_value=1;};
    for(int i=1;i<=_value;i++) {

      var jsonFormatted;
      do {
        String jsonString = await APIUtil.getMatchUpQuestion(
            _minRank.toString(), _maxRank.toString(), '');
        jsonFormatted = jsonDecode(jsonString.toString());
        if (jsonFormatted['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (jsonFormatted['apiStatus'] != 'success');

      if(i==_value){EasyLoading.dismiss();};
      setState(() {

        _connectStatusQAMap[i] ={};
        _info[i]= {};
        _color[i]= {};
        _color1[i]= {};
        _inQuiz[i]= true;
        _waitUserConnect[i]= true;
        _draggableNow[i]= true;
        _resultNoConnect[i]=0;
        _resultWrong[i]=0;
        _result[i]=0;
        _questionList[i] =
            (jsonFormatted['data']['questionShuffledEnglishList'] as List).map((
                item) => item as String).toList();
        _answerList[i] =
            (jsonFormatted['data']['questionShuffledChineseList'] as List).map((
                item) => item as String).toList();
        _pairedAnswerMap[i] =
            (jsonFormatted['data']['originQuestionDict'] as Map).map((key,
                value) => MapEntry(key.toString(), value.toString()));

      });

    }

  }
}


class LineDrawer extends CustomPainter {
  final List<GlobalKey> dragGlobalKeyList;
  final Map<GlobalKey, GlobalKey> _connectStatusQAMaptedStatusGlobalKeyMap;
  final Map _connectStatusQAMaptedStatusResultMap;
  final List<String> questionList;
  final double scrolledOffset;
  final Offset parentOffset;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  LineDrawer(
    this.dragGlobalKeyList,
    this._connectStatusQAMaptedStatusGlobalKeyMap,
    this._connectStatusQAMaptedStatusResultMap,
    this.questionList,
    this.scrolledOffset,
    this.parentOffset,
  );

  @override
  void paint(Canvas canvas, Size size) {
    int index = 0;
    for(GlobalKey key in dragGlobalKeyList){
      if (_connectStatusQAMaptedStatusGlobalKeyMap[key] != null) {
        RenderBox renderBoxQuestion = key.currentContext?.findRenderObject() as RenderBox;
        RenderBox renderBoxAnswer = _connectStatusQAMaptedStatusGlobalKeyMap[key]?.currentContext?.findRenderObject() as RenderBox;

        Offset dragOffset = renderBoxQuestion.localToGlobal(Offset.zero);
        Offset targetOffset = renderBoxAnswer.localToGlobal(Offset.zero);

        Paint pan = Paint()..color = Colors.black45..strokeWidth = 8.0;
        switch(_connectStatusQAMaptedStatusResultMap[questionList[index]]){
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
        if(isWeb){
          canvas.drawLine(
            Offset(dragOffset.dx + 2, dragOffset.dy + scrolledOffset - 54),
            Offset(targetOffset.dx + 2, targetOffset.dy + scrolledOffset - 59),
            pan,
          );
        }else{
          canvas.drawLine(
            Offset(dragOffset.dx + 2, dragOffset.dy + scrolledOffset - parentOffset.dy + 20),
            Offset(targetOffset.dx + 2, targetOffset.dy + scrolledOffset - parentOffset.dy + 14),
            pan,
          );
        }
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
  final double scrolledOffset;
  final Offset parentOffset;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  MouseTracker(this.dragOffset, this.targetOffset, this.scrolledOffset, this.parentOffset);

  @override
  void paint(Canvas canvas, Size size) {
    if(isWeb){
      canvas.drawLine(
        Offset(dragOffset.dx + 19, dragOffset.dy + scrolledOffset - 35),
        Offset(targetOffset.dx , targetOffset.dy + scrolledOffset - 55),
        Paint()..color = Colors.black45..strokeWidth = 8.0,
      );
    }else{
      canvas.drawLine(
        Offset(dragOffset.dx + 19, dragOffset.dy + scrolledOffset - parentOffset.dy + 35),
        Offset(targetOffset.dx, targetOffset.dy + scrolledOffset - parentOffset.dy + 15),
        Paint()..color = Colors.black45..strokeWidth = 8.0,
      );
    }
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
