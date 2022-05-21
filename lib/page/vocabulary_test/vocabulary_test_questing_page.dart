import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VocabularyTestQuestingPage extends StatefulWidget {
  final List<dynamic> vocabularyTestQuestionList;
  const VocabularyTestQuestingPage ({ Key? key, required this.vocabularyTestQuestionList }): super(key: key);

  @override
  _VocabularyTestQuestingPage createState() =>
      _VocabularyTestQuestingPage();
}

class _VocabularyTestQuestingPage extends State<VocabularyTestQuestingPage> {
  late List<dynamic> _vocabularyTestQuestionList;

  int _part = 0;
  List<String> _chooseAnswerList = [];


  List<Widget> listViews = <Widget>[];
  List<String> text = ['A', 'B', 'C', 'D', 'E'];

  @override
  void initState() {
    _vocabularyTestQuestionList = widget.vocabularyTestQuestionList;
    super.initState();
    _initVocabularyTestQuestingPage();
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
            child: Column(
                children: <Widget>[
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
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: Column(
                              children: <Widget>[
                                AutoSizeText(
                                  '${_part + 1}/${_vocabularyTestQuestionList.length}',
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
                                    '題目：\n${_vocabularyTestQuestionList[_part]['content']}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      //color: PageTheme.app_theme_blue,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: AutoSizeText(
                                            '${_vocabularyTestQuestionList[_part]['id']}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              //color: PageTheme.app_theme_blue,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                          )
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: AutoSizeText(
                                            '${_vocabularyTestQuestionList[_part]['source']}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              //color: PageTheme.app_theme_blue,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                          )
                                      ),
                                    ]
                                ),
                              ]
                          )
                      )
                  ),

                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                      side: BorderSide(color: Colors.red))
                              ),
                              side: MaterialStateProperty.all(BorderSide(
                                //color: Colors.blue,
                                  width: 2.0,
                                  style: BorderStyle.solid)
                              ),
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: AutoSizeText(
                                        'A.',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: AutoSizeText(
                                        '${_vocabularyTestQuestionList[_part]['selectionList'][0]}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                ]
                            ),
                          ),
                          onPressed: () {
                            _chooseAnswer(_vocabularyTestQuestionList[_part]['selectionList'][0]);
                          },
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                    side: BorderSide(color: Colors.red))
                            ),
                            side: MaterialStateProperty.all(BorderSide(
                              //color: Colors.blue,
                                width: 2.0,
                                style: BorderStyle.solid)
                            ),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: AutoSizeText(
                                        'B.',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: AutoSizeText(
                                        '${_vocabularyTestQuestionList[_part]['selectionList'][1]}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                ]
                            ),
                          ),
                          onPressed: () {
                            _chooseAnswer(_vocabularyTestQuestionList[_part]['selectionList'][1]);
                          },
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                    side: BorderSide(color: Colors.red))
                            ),
                            side: MaterialStateProperty.all(BorderSide(
                              //color: Colors.blue,
                                width: 2.0,
                                style: BorderStyle.solid)
                            ),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: AutoSizeText(
                                        'C.',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: AutoSizeText(
                                        '${_vocabularyTestQuestionList[_part]['selectionList'][2]}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                ]
                            ),
                          ),
                          onPressed: () {
                            _chooseAnswer(_vocabularyTestQuestionList[_part]['selectionList'][2]);
                          },
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                    side: BorderSide(color: Colors.red))
                            ),
                            side: MaterialStateProperty.all(BorderSide(
                              //color: Colors.blue,
                                width: 2.0,
                                style: BorderStyle.solid)
                            ),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: AutoSizeText(
                                        'D.',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: AutoSizeText(
                                        '${_vocabularyTestQuestionList[_part]['selectionList'][3]}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                ]
                            ),
                          ),
                          onPressed: () {
                            _chooseAnswer(_vocabularyTestQuestionList[_part]['selectionList'][3]);
                          },
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                    side: BorderSide(color: Colors.red))
                            ),
                            side: MaterialStateProperty.all(BorderSide(
                              //color: Colors.blue,
                                width: 2.0,
                                style: BorderStyle.solid)
                            ),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: AutoSizeText(
                                        'E.',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: AutoSizeText(
                                        '不知道',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          //color: PageTheme.app_theme_blue,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      )
                                  ),
                                ]
                            ),
                          ),
                          onPressed: () {
                            _chooseAnswer('不知道');
                          },
                        ),
                      )
                  ),

                ]
            )
        )
    );
  }


  void _initVocabularyTestQuestingPage() {
    print(_vocabularyTestQuestionList);
  }

  void _chooseAnswer(chooseAnswer) {
    _chooseAnswerList.add(chooseAnswer);
    if (_chooseAnswerList.length == _vocabularyTestQuestionList.length) {
      print(_chooseAnswerList);
      AutoRouter.of(context).replace(VocabularyTestReportRoute(vocabularyTestQuestionList: _vocabularyTestQuestionList, chooseAnswerList: _chooseAnswerList));

      return;
    }

    setState(() {
      _part += 1;
    });
  }


}

