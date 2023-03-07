import 'package:alicsnet_app/page/page_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VocabularyTestReportPage extends StatefulWidget {
  final List<dynamic> vocabularyTestQuestionList;
  final List<String> chooseAnswerList;

  const VocabularyTestReportPage(
      {Key? key,
      required this.vocabularyTestQuestionList,
      required this.chooseAnswerList})
      : super(key: key);

  @override
  _VocabularyTestReportPage createState() => _VocabularyTestReportPage();
}

class _VocabularyTestReportPage extends State<VocabularyTestReportPage> {
  late List<dynamic> _vocabularyTestQuestionList;
  late List<String> _chooseAnswerList;
  int _correctCount = 0;
  int _mistakeCount = 0;

  @override
  void initState() {
    _vocabularyTestQuestionList = widget.vocabularyTestQuestionList;
    _chooseAnswerList = widget.chooseAnswerList;
    super.initState();
    _initVocabularyTestReportPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PageTheme.index_bar_background,
          title: AutoSizeText(
            '',
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
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          //color: PageTheme.app_theme_blue,
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Column(children: <Widget>[
                        AutoSizeText(
                          '正確題數：${_correctCount}題',
                          style: const TextStyle(
                            fontSize: 24,
                            //color: PageTheme.app_theme_blue,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          '錯誤題數：${_mistakeCount}題',
                          style: const TextStyle(
                            fontSize: 24,
                            //color: PageTheme.app_theme_blue,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          '未回答題數：${_vocabularyTestQuestionList.length - _correctCount - _mistakeCount}題',
                          style: const TextStyle(
                            fontSize: 24,
                            //color: PageTheme.app_theme_blue,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                        ),
                        Row(children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                '正確率\n${_correctCount / _vocabularyTestQuestionList.length * 100}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  //color: PageTheme.app_theme_blue,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                              )),
                          Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                '錯誤率\n${_mistakeCount / _vocabularyTestQuestionList.length * 100}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  //color: PageTheme.app_theme_blue,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                              )),
                          Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                '未答率\n${(_vocabularyTestQuestionList.length - _correctCount - _mistakeCount) / _vocabularyTestQuestionList.length * 100}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  //color: PageTheme.app_theme_blue,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                              )),
                        ]),
                      ]))),
              Container(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: _vocabularyTestQuestionList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                //color: PageTheme.app_theme_blue,
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Column(children: <Widget>[
                              AutoSizeText(
                                '${index + 1}/${_vocabularyTestQuestionList.length}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  //color: PageTheme.app_theme_blue,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: AutoSizeText(
                                  '題目：\n${_vocabularyTestQuestionList[index]['content']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    //color: PageTheme.app_theme_blue,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: AutoSizeText(
                                      '${_vocabularyTestQuestionList[index]['id']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        //color: PageTheme.app_theme_blue,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: AutoSizeText(
                                      '${_vocabularyTestQuestionList[index]['source']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        //color: PageTheme.app_theme_blue,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                    )),
                              ]),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: AutoSizeText(
                                  '正確答案：${_vocabularyTestQuestionList[index]['answer']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    //color: PageTheme.app_theme_blue,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: AutoSizeText(
                                  '您的回答：${_chooseAnswerList[index]}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    //color: PageTheme.app_theme_blue,
                                    color: (_chooseAnswerList[index] ==
                                            _vocabularyTestQuestionList[index]
                                                ['answer'])
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ])));
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(padding: const EdgeInsets.all(8.0));
                  },
                ),
              ),
            ])));
  }

  void _initVocabularyTestReportPage() {
    //print(_vocabularyTestQuestionList);
    //print(_chooseAnswerList);
    for (int i = 0; i < _vocabularyTestQuestionList.length; i++) {
      if (_vocabularyTestQuestionList[i]['answer'] == _chooseAnswerList[i]) {
        setState(() {
          _correctCount += 1;
        });
      } else if (_chooseAnswerList[i] != '不知道') {
        setState(() {
          _mistakeCount += 1;
        });
      }
    }
  }
}
