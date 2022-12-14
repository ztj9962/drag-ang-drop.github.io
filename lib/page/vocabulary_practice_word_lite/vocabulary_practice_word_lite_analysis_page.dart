import 'dart:convert';

import 'package:alicsnet_app/page/login/fade_animation.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VocabularyPracticeWordLiteAnalysisPage extends StatefulWidget {
  final String originSentence;

  const VocabularyPracticeWordLiteAnalysisPage({Key? key, required this.originSentence})
      : super(key: key);

  @override
  _VocabularyPracticeWordLiteAnalysisPageState createState() =>
      _VocabularyPracticeWordLiteAnalysisPageState();
}

class _VocabularyPracticeWordLiteAnalysisPageState
    extends State<VocabularyPracticeWordLiteAnalysisPage> {
  late String _originSentence;
  List<TableRow> _clauseTableRowList = [];
  List<Widget> _chunksTextList = [];
  List<dynamic> _clauseList = [];
  String _spacyTreeBase64 = "";
  TransformationController _interactController = new TransformationController();
  double _matrixScale = 1.0;
  double _matrixMaxScale = 1.6;
  double _matrixMinScale = 1;

  @override
  void initState() {
    _originSentence = widget.originSentence;
    apiInit();

    super.initState();
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
        centerTitle: true,
        backgroundColor: PageTheme.app_theme_black,
        title: AutoSizeText(
          '句子文法分析與翻譯',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 3.0,
            color: Color(0xFFFEFEFE),
          ),
          maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(8)),
              AutoSizeText('原句',style: TextStyle(
                  color: PageTheme.cutom_article_practice_background.withOpacity(0.8),
                  fontSize: 30,
                  height: 1.0,
                  fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(right: 10, left: 10, top: 5),
                child: Column(
                  children: [
                    AutoSizeText(_originSentence,style: TextStyle(fontSize: 20),),
                    Divider(thickness: 2,color: PageTheme.cutom_article_practice_background.withOpacity(0.8),),
                    //AutoSizeText(data),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              AutoSizeText('句型分析表格',style: TextStyle(
                  color: PageTheme.cutom_article_practice_background.withOpacity(0.8),
                  fontSize: 25,
                  height: 1.0,
                  fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.all(8)),
              Container(
                margin: EdgeInsets.only(right: 5, left: 5, top: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 2,
                    color:
                    PageTheme.cutom_article_practice_background.withOpacity(0.5),
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Table(
                    columnWidths: const <int, TableColumnWidth>{
                      //指定索引及固定列宽
                      /*0: FixedColumnWidth(60.0),
                      1: FixedColumnWidth(50.0),
                      2: FixedColumnWidth(60.0),
                      3: FixedColumnWidth(50.0),
                      4: FixedColumnWidth(50.0),
                      5: FixedColumnWidth(50.0),
                      6: FixedColumnWidth(50.0),*/
                    },
                    //設定表格樣式
                    border: TableBorder(horizontalInside: BorderSide(width: 1, color: PageTheme.app_theme_blue, style: BorderStyle.solid)),
                    children: _clauseTableRowList,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              Divider(thickness: 2,color: PageTheme.cutom_article_practice_background.withOpacity(0.8),),
              Padding(padding: EdgeInsets.all(8)),
              AutoSizeText('句型樹狀圖',style: TextStyle(
                  color: PageTheme.cutom_article_practice_background.withOpacity(0.8),
                  fontSize: 25,
                  height: 1.0,
                  fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.all(8)),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color:
                      PageTheme.cutom_article_practice_background.withOpacity(0.5),
                    )
                ),
                  child: InteractiveViewer(
                      onInteractionUpdate: (detail){
                        if(detail.scale != 1.0){
                          _matrixScale = detail.scale;
                        }
                        print(_matrixScale);
                      },
                      transformationController: _interactController,
                      child: imageFromBase64String(_spacyTreeBase64),
                      boundaryMargin: const EdgeInsets.all(20.0),
                      minScale: 0.1,
                      maxScale: 1.6,
                  ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(8)),
                    ElevatedButton(
                        child: Icon(Icons.zoom_in),
                        style: ElevatedButton.styleFrom(
                            primary: PageTheme.app_theme_blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shadowColor: Colors.black,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: () async {
                          if(_matrixScale < _matrixMaxScale){
                            _matrixScale+=0.1;
                            print(_matrixScale);
                          }
                          _interactController.value = Matrix4.diagonal3Values(_matrixScale, _matrixScale, 1);
                        }
                    ),
                  Padding(padding: EdgeInsets.all(8)),
                    ElevatedButton(
                        child:Icon(Icons.zoom_out),
                        style: ElevatedButton.styleFrom(
                            primary: PageTheme.app_theme_blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shadowColor: Colors.black,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: () async {
                          if(_matrixScale > _matrixMinScale){
                            _matrixScale-=0.1;
                            print(_matrixScale);
                          }
                          _interactController.value = Matrix4.diagonal3Values(_matrixScale, _matrixScale, 1);
                        }
                    ),
                  Padding(padding: EdgeInsets.all(8)),
                ],
              ),
              Padding(padding: EdgeInsets.all(8)),
              Divider(thickness: 2,color: PageTheme.cutom_article_practice_background.withOpacity(0.8),),
              Padding(padding: EdgeInsets.all(8)),
              AutoSizeText('切片翻譯',style: TextStyle(
                  color: PageTheme.cutom_article_practice_background.withOpacity(0.8),
                  fontSize: 25,
                  height: 1.0,
                  fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.all(8)),
                Container(
                  height: _chunksTextList.length * 100,
                  width: 300,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _chunksTextList.length,
                    itemBuilder: (BuildContext context, int index) {return FadeAnimation(1, _chunksTextList[index]);},
                    separatorBuilder: (BuildContext context, int index) {return Padding(padding: EdgeInsets.all(10)); },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Future<bool> _getSpacyTreeByString(String originSentence) async {
    //if (_vocabularySentenceList.length == _vocabularyList.length) return;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode = await APIUtil.getSpacyTreeByString(originSentence);
    try {
      int doLimit = 1;
      do {
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      //print(responseJSONDecode);
      //vocabularySentenceList = responseJSONDecode['data'];

      setState(() {
        _spacyTreeBase64 =  responseJSONDecode['data'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode['apiStatus'] == 'success';
  }
  Future<bool> _getClauseTableByString(String originSentence) async {
    //if (_vocabularySentenceList.length == _vocabularyList.length) return;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode = await APIUtil.getClauseTableByString(originSentence);
    try {
      int doLimit = 1;
      do {
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      //print(responseJSONDecode);
      //vocabularySentenceList = responseJSONDecode['data'];

      setState(() {
        _clauseList =  responseJSONDecode['data'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode['apiStatus'] == 'success';
  }

  void apiInit() async {
    await _getSpacyTreeByString(_originSentence);
    await _getClauseTableByString(_originSentence);
    print(_clauseList);
    dataInit();
  }

  void dataInit(){
    RegExp punctuationFilter = RegExp(r'^[A-Za-z0-9]');
    _clauseTableRowList.add(
        TableRow(
          children: <Widget>[
            TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText('單字',maxLines: 1,)),
            TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText('單字\n中文',)),
            TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText('原型',maxLines: 1,)),
            TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText('POS',)),
            TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText('POS\n中文',)),
            TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText('DEP',)),
            TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText('DEP\n中文',)),
          ],
        )
    );
    for(var clause in _clauseList) {
      _clauseTableRowList.add(
          TableRow(
            children: <Widget>[
              TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText(clause['Word'],maxLines: 1,minFontSize: 8,)),
              TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText(clause['twnWord'],)),
              TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText(clause['lemma'],maxLines: 1,minFontSize: 8)),
              TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText(clause['POS'],)),
              TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText(clause['twnPOS'],)),
              TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText(clause['DEP'],)),
              TableCell(verticalAlignment:TableCellVerticalAlignment.middle,child: AutoSizeText(clause['twnDEP'] != double.nan ? clause['twnDEP'] : '',)),
            ],
          )
      );
      if(punctuationFilter.hasMatch(clause['Word/Phrase/Clause'].toString()) && ' '.allMatches(clause['Word/Phrase/Clause']).length > 0)
      {
        print(clause['Word/Phrase/Clause']);
        _chunksTextList.add(
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: PageTheme.app_theme_blue),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText('${clause['Word/Phrase/Clause']}\n${clause['twnClause']}'),
                ))
        );
      }
    }
  }
/*
  other
   */
}
