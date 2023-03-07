import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:alicsnet_app/page/login/fade_animation.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class SentenceAnalysisIndexPage extends StatefulWidget {
  final String analysisor;

  const SentenceAnalysisIndexPage({Key? key, required this.analysisor})
      : super(key: key);

  @override
  _SentenceAnalysisIndexPage createState() => _SentenceAnalysisIndexPage();
}

class _SentenceAnalysisIndexPage extends State<SentenceAnalysisIndexPage> {
  late String _analysisor;
  final _regex = RegExp(r'[a-zA-Z]+');

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _controller = new TextEditingController();
  String? _dropdownValue1;
  String _text = "";
  int _maxLength = 500;
  List<String>? _exampleList = [
    'My friends are at the library.',
    'Marc was in the bathroom.',
    'She has been sad since you left.',
    'John is tall.',
    "The monster was ready.",
    'This book is rather terrible.',
    'Mr. James has been a teacher for forty years.',
    'My mother appeared sad.',
    'The Swiss cheese has gone bad.',
    'Dawn seems happy.',
    'Miles went mad.',
    'Mary looks like her mother.',
    'Joan becomes a professional foot ball player.',
    'Rooney played superbly.',
    'John sat up.',
    'The small child cried very loudly.',
    'My charming son was hovering rather sheepishly.',
    'She would behave so bravely.',
    'My friend left that evening.',
    'The boy ran two miles.',
    'Your fourth cousin sang this afternoon.',
    'Ravi shouted that morning.',
    'The monster lives under the bed.',
    'Sarah lives in America.',
    'Helen’s brother played after his dinner.',
    'Robert ran to the door.',
    'The ball was bouncing on the pitch.',
    'Sarah and Micheal disappeared.',
    'My mother is drilling.',
    'Anila kicked.',
    'John laugh.',
    'The researcher participated.',
    'The monster roared.',
    'She changed her dress.',
    'The boy hugged the dog.',
    'My mother is drilling a hole.',
    'Sara is throwing a ball.',
    'Anila kicked the ball.',
    'John kissed Jane.',
    'The teacher taught the student.',
    'The monster threw the table.',
    'Your friend was opening the door.',
    'My dad washed his car.',
    'I bought Fred a ticket.',
    'Most people consider Jacobson a loyal friend they crowned him king.',
    'John gave Jane a present.',
    'The monster gave me a fright.',
    'She gave her the wrong package.',
    'I gave them our address.',
    'Mr. Smith gave student a raise.',
    'The teacher taught the student English.',
    'They elected Adams president.',
    'They crowned him king.',
    'The jury found the defendant guilty.',
    'John made Jane angry.',
    'The monster made the wall crumble.',
    'The ride made me dizzy.',
    'I bought a ticket for Fred.',
    'I gave our address to them.',
    'The boy hugged the dog gently.',
    'I put the book on the table.',
    'John put the bag down.',
    'The monster threw my friend out of the window.',
    'I will lay your coats on the bed upstairs.',
    'The boy ate an apple in the kitchen.',
    'She put her hand in the pocket.',
  ];
  List<String>? _sentenceTypeList = [
    '[SVA]',
    '[SVA]',
    '[SVC]',
    '[SVC]',
    "[SVC]",
    '[SVC]',
    '[SVC]',
    '[SVC]',
    '[SVC]',
    '[SVC]',
    '[SVC]',
    '[SVC]',
    '[SVC]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SV]',
    '[SVO]',
    '[SVO]',
    '[SVO]',
    '[SVO]',
    '[SVO]',
    '[SVO]',
    '[SVO]',
    '[SVO]',
    '[SVO]',
    '[SVO]',
    '[SVOO]',
    '[SVOC]',
    '[SVOO]',
    '[SVOO]',
    '[SVOO]',
    '[SVOO]',
    '[SVOO]',
    '[SVOO]',
    '[SVOC]',
    '[SVOC]',
    '[SVOC]',
    '[SVOC]',
    '[SVOC]',
    '[SVOC]',
    '[SVOA]',
    '[SVOA]',
    '[SVOA]',
    '[SVOA]',
    '[SVOA]',
    '[SVOA]',
    '[SVOA]',
    '[SVOA]',
    '[SVOA]',
  ];
  bool _isloading = false;
  int _inputWordCount = 0;
  Uint8List _spacyTree = Uint8List.fromList([]);

  //Uint8List displacy = Uint8List.fromList([]);
  List<TableRow> _tableArray = <TableRow>[];

  @override
  void initState() {
    print(_exampleList?.length);
    print(_sentenceTypeList?.length);
    _analysisor = widget.analysisor;
    if (_analysisor.isNotEmpty) {
      _controller.text = _analysisor;
      refreshResult();
    }
    super.initState();
  }

  @override
  void dispose() {
    //SystemChannels._textInput.invokeMethod('_textInput.hide');
    super.dispose();
  }

  //創建topiWidget

  //將輸入文章做作文法校正、分句、文章分析
  void addGraphics() async {
    _tableArray = [];
    print(_controller.text);
    setState(() {
      _isloading = true;
    });
    try {
      if (_controller.text != "" && _inputWordCount > 0) {
        //_spacyTree
        var spacyTreeResponse = await APIUtil.getSpacyTreeByString(
            _controller.text.replaceAll("\n", " "));
        if (spacyTreeResponse['apiStatus'] == 'success') {
          _spacyTree = base64.decode(spacyTreeResponse['data']);
          setState(() {
            _isloading = false;
          });
        } else {
          setState(() {
            _isloading = false;
          });
          final _text = "文章內容包含除英文之外的字元";
          final snackbar = SnackBar(
            content: Text(_text),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }

        //Displacy
        /*
        String DisplacyApi = await APIUtil.getDisplayByString(
            _controller.text.replaceAll("\n", " "));
        var DisplacyResponse = jsonDecode(DisplacyApi);
        if (DisplacyResponse['apiStatus'] == 'success') {
          displacy = base64.decode(DisplacyResponse['data']);
          setState(() {
            _isloading = false;
          });
        } else {
          setState(() {
            _isloading = false;
          });
          final _text = "文章內容包含除英文之外的字元";
          final snackbar = SnackBar(
            content: Text(_text),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }*/

        //句型分析表
        var clauseTableApi = await APIUtil.getClauseTableByString(
            _controller.text.replaceAll("\n", " "));

        //var clauseTableResponse = jsonDecode(clauseTableApi);

        print(_controller.text.replaceAll("\n", " "));
        if (clauseTableApi['apiStatus'] == 'success') {
          List tableData = clauseTableApi['data'] as List;
          _tableArray.add(TableRow(
            decoration: BoxDecoration(
                color: PageTheme.cutom_article_practice_background
                    .withOpacity(0.5)),
            children: [
              Center(child: AutoSizeText('單字', maxLines: 1)),
              Center(child: AutoSizeText('原型', maxLines: 1)),
              Center(child: AutoSizeText('POS', maxLines: 1)),
              //Center(child: AutoSizeText('POS中文',maxLines: 1)),
              Center(child: AutoSizeText('Dependency', maxLines: 1)),
              //Center(child: AutoSizeText('Dependency中文',maxLines: 1)),
              Center(
                  child: AutoSizeText(
                '片語/子句',
                maxLines: 1,
              )),
            ],
          ));
          for (int i = 0; i < tableData.length; i++) {
            List<Widget> tableList = [
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 3, child: AutoSizeText(' [' + i.toString() + ']')),
                  Expanded(
                      flex: 5,
                      child: AutoSizeText(tableData[i]['Word'] +
                          '\n' +
                          tableData[i]['twnWord'])),
                ],
              )),
              Center(child: AutoSizeText(tableData[i]['lemma'])),
              Center(
                  child: AutoSizeText(
                      tableData[i]['POS'] + '\n' + tableData[i]['twnPOS'])),
              //Center(child: AutoSizeText(tableData[i]['twnPOS'])),
              Center(
                  child: AutoSizeText(
                      tableData[i]['DEP'] + '\n' + tableData[i]['twnDEP'])),
              //Center(child: AutoSizeText(tableData[i]['twnDEP'])),
              Center(child: AutoSizeText(tableData[i]['Word/Phrase/Clause'])),
            ];
            _tableArray.add(TableRow(
              decoration: i % 2 == 0
                  ? BoxDecoration(color: Colors.white)
                  : BoxDecoration(color: Colors.black12),
              children: tableList,
            ));
          }
          setState(() {
            _isloading = false;
          });
        } else {
          setState(() {
            _isloading = false;
          });
          final _text = "文章內容包含除英文之外的字元";
          final snackbar = SnackBar(
            content: Text(_text),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        setState(() {
          _isloading = false;
        });
        final _text = "請輸入文章";
        final snackbar = SnackBar(
          content: Text(_text),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (error) {
      setState(() {
        _isloading = false;
      });
      print(error);
      final _text = "發生異常";
      final snackbar = SnackBar(
        content: Text(_text),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }
  }

  void refreshResult() {
    setState(() {
      String article = _controller.text.replaceAll("\n", " ");
      int count = 0;
      String pastText = "";
      for (var i = 0; i < article.split(" ").length; i++) {
        if (_regex.hasMatch(article.split(' ')[i])) {
          count += 1;
        }
      }
      if (count <= _maxLength) {
        setState(() {
          _inputWordCount = count;
        });
        _text = article;
      } else {
        for (var i = 0; i < 500; i++) {
          pastText += article.split(' ')[i] + " ";
        }
        _controller.text = pastText;
        setState(() {
          _inputWordCount = 500;
        });
        _controller.value = new TextEditingValue(
            text: _text,
            selection: new TextSelection(
                baseOffset: _maxLength,
                extentOffset: _maxLength,
                affinity: TextAffinity.downstream,
                isDirectional: false),
            composing: new TextRange(start: 0, end: _maxLength));
        _controller.text = _text;
      }
      addGraphics();
      //_IPA2List = _IPAMap[_dropdownValue1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white, //Color(0xffffdef5),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PageTheme.app_theme_black,
          title: AutoSizeText(
            '句型分析',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(
            top: 16,
            bottom: 62,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text("Sentence Analysis",
                      style: TextStyle(
                          color: PageTheme.cutom_article_practice_background,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text("句型分析",
                      style: TextStyle(
                          color: PageTheme.cutom_article_practice_background
                              .withOpacity(0.8),
                          fontSize: 14,
                          height: 1.0,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 3,
                  margin: EdgeInsets.only(right: 10, left: 10, top: 5),
                  decoration: BoxDecoration(
                      color: PageTheme.cutom_article_practice_background,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),
            Container(
              margin:
                  const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
              decoration: BoxDecoration(
                border: Border.all(
                    color: PageTheme.cutom_article_practice_background
                        .withOpacity(0.5),
                    width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton(
                value: _dropdownValue1,
                //style: TextStyle(fontSize: 20),
                isExpanded: true,
                iconSize: 40,
                hint: AutoSizeText(
                  '   請選擇一個例句',
                  style: TextStyle(
                      color: PageTheme.cutom_article_practice_background
                          .withOpacity(0.5)),
                  maxLines: 1,
                ),
                items:
                    _exampleList?.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      height: 30,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: AutoSizeText(
                              '   ${_sentenceTypeList![_exampleList!.indexOf(value)]}',
                              style: TextStyle(
                                  color: PageTheme
                                      .cutom_article_practice_background),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: AutoSizeText(
                              '   ${value}',
                              style: TextStyle(
                                  color: PageTheme
                                      .cutom_article_practice_background),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  _dropdownValue1 = value!;
                  _controller.text = value;
                  refreshResult();
                },
                underline: Container(
                  height: 0,
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 5),
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 2,
                    color: PageTheme.cutom_article_practice_background
                        .withOpacity(0.5),
                  ),
                ),
                child: ListView(
                  children: [
                    TextField(
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "請輸入一段文章",
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        minLines: 1,
                        controller: _controller,
                        onChanged: (String newVal) {
                          String article = newVal.replaceAll("\n", " ");
                          int count = 0;
                          String pastText = "";
                          for (var i = 0; i < article.split(" ").length; i++) {
                            if (_regex.hasMatch(article.split(' ')[i])) {
                              count += 1;
                            }
                          }
                          if (count <= _maxLength) {
                            setState(() {
                              _inputWordCount = count;
                            });
                            _text = article;
                          } else {
                            for (var i = 0; i < 500; i++) {
                              pastText += article.split(' ')[i] + " ";
                            }
                            _controller.text = pastText;
                            setState(() {
                              _inputWordCount = 500;
                            });
                            _controller.value = new TextEditingValue(
                                text: _text,
                                selection: new TextSelection(
                                    baseOffset: _maxLength,
                                    extentOffset: _maxLength,
                                    affinity: TextAffinity.downstream,
                                    isDirectional: false),
                                composing:
                                    new TextRange(start: 0, end: _maxLength));
                            _controller.text = _text;
                          }
                        })
                  ],
                )),
            Row(
              children: [
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    '${_inputWordCount}/500',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20, bottom: 30),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  _isloading
                      ? Container(
                          padding: EdgeInsets.all(3),
                          height: 40,
                          width: 100,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: PageTheme.cutom_article_practice_background,
                            strokeWidth: 4.0,
                          )))
                      : GestureDetector(
                          onTap: () {
                            addGraphics();
                            SystemChannels.textInput
                                .invokeMethod('_textInput.hide');
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color:
                                    PageTheme.cutom_article_practice_background,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: const Offset(0, 1),
                                  ),
                                ]),
                            child: Center(
                                child: Text(
                              "送出",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                ],
              ),
            ),
            //if (sentencelist.length >= 1 && !_isloading)

            //for (var i = 0; i < sentencelist.length; i++)
            //顯示圖片片片
            if (_spacyTree.isNotEmpty)
              FadeAnimation(
                1.0,
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Text("句型分析樹狀圖",
                          style: TextStyle(
                              color: PageTheme.cutom_article_practice_background
                                  .withOpacity(0.8),
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 5),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: PageTheme.cutom_article_practice_background
                                .withOpacity(0.5),
                          ),
                        ),
                        child: Image.memory(_spacyTree)),
                    Divider(
                      height: 16,
                      color: PageTheme.grey.withAlpha(50),
                    ),
                  ],
                ),
              ),
            /*
            if (_spacyTree.isNotEmpty)
              FadeAnimation(
                1.0,
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Text("句型分析模型",
                          style: TextStyle(
                              color: PageTheme.cutom_article_practice_background
                                  .withOpacity(0.8),
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 5),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: PageTheme.cutom_article_practice_background
                                .withOpacity(0.5),
                          ),
                        ),
                        child: Image.memory(displacy)),
                    Divider(
                      height: 16,
                      color: PageTheme.grey.withAlpha(50),
                    ),
                  ],
                ),
              ),
            */

            if (_spacyTree.isNotEmpty)
              FadeAnimation(
                1.0,
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Text("句型分析表格",
                          style: TextStyle(
                              color: PageTheme.cutom_article_practice_background
                                  .withOpacity(0.8),
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 5),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: PageTheme.cutom_article_practice_background
                                .withOpacity(0.5),
                          ),
                        ),
                        child: Table(
                          border: TableBorder(
                              borderRadius: BorderRadius.circular(15),
                              left: BorderSide(
                                  width: 2,
                                  color: PageTheme
                                      .cutom_article_practice_background
                                      .withOpacity(0.5),
                                  style: BorderStyle.solid),
                              right: BorderSide(
                                  width: 2,
                                  color: PageTheme
                                      .cutom_article_practice_background
                                      .withOpacity(0.5),
                                  style: BorderStyle.solid),
                              horizontalInside: BorderSide(
                                  width: 1,
                                  color: PageTheme.lightText,
                                  style: BorderStyle.solid),
                              verticalInside: BorderSide(
                                  width: 1,
                                  color: PageTheme.lightText,
                                  style: BorderStyle.solid)),
                          children: _tableArray,
                        )),
                  ],
                ),
              ),
          ],
        ));
  }
}

//文章分析說明dialog
class CustomAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          //overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 420,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: Column(
                  children: [
                    Text(
                      '文章分析',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '此功能是在分析您輸入的文章分別由哪些單字等級所組成',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Divider(
                      color: Colors.black54,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Alics各等級單字分配如下\n',
                        style: TextStyle(color: Colors.black54, height: 1.5),
                        children: [
                          TextSpan(
                              text: '◎ 國小：11.74%，共1087個\n',
                              style: TextStyle(height: 2)),
                          TextSpan(
                              text: '◎ 國中：13.55%，共1255個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 高中(1)：22.76%，共2117個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 高中(2)：23.28%，共2156個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 全民英檢：4.78%，共443個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 多益：11.56%，共1071個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 托福：12.22%，共1132個\n',
                              style: TextStyle(height: 1.5)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                      style: ElevatedButton.styleFrom(
                          primary: PageTheme.cutom_article_practice_background),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -30,
                child: CircleAvatar(
                  backgroundColor: PageTheme.cutom_article_practice_background,
                  radius: 30,
                  child: Icon(
                    Icons.question_mark,
                    color: Colors.white,
                    size: 18,
                  ),
                )),
          ],
        ));
  }
}
