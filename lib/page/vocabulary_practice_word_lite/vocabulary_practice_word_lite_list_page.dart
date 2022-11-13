import 'dart:convert';

import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VocabularyPracticeWordLiteListPage extends StatefulWidget {
  final List<dynamic> vocabularyList;

  const VocabularyPracticeWordLiteListPage({Key? key, required this.vocabularyList})
      : super(key: key);

  @override
  _VocabularyPracticeWordListPageState createState() =>
      _VocabularyPracticeWordListPageState();
}

class _VocabularyPracticeWordListPageState
    extends State<VocabularyPracticeWordLiteListPage> {
  late List<dynamic> _vocabularyList;
  List<dynamic> _vocabularySentenceList = [];
  var _wordTextSizeGroup = AutoSizeGroup();
  var _wordIPATextSizeGroup = AutoSizeGroup();
  var _wordMeaningTextSizeGroup = AutoSizeGroup();

  List<Widget> listViews = <Widget>[];

  List _CompleteSentenceList = [];


  @override
  void initState() {
    _vocabularyList = widget.vocabularyList;
    //print(_vocabularyList);
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
                    color: PageTheme.app_theme_blue,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Column(
                  children: <Widget>[
                    AutoSizeText(
                      '點擊按鈕開始練習',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        color: PageTheme.app_theme_blue,
                      ),
                      maxLines: 1,
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              child: const AutoSizeText(
                                '開始練習',
                                maxLines: 1,
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: PageTheme.app_theme_blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shadowColor: Colors.black,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              onPressed: () async {
                                /*if (!await _botChallenge('_getVocabularySentenceList')) {
                                      return;
                                    }*/

                                /*if (!await _getVocabularySentenceList()) {
                                      return;
                                    }*/
                                await _getVocabularySentenceList();

                                List<String> contentList = [];
                                List<String> ipaList = [];
                                List<String> translateList = [];
                                List<int> idList = [];

                                //print(_vocabularyList);
                                for (final vocabularyData
                                    in _vocabularySentenceList) {
                                  //print(vocabularyData);
                                  //return;
                                  for (final sentence
                                      in vocabularyData!['sentenceList']!) {
                                    contentList
                                        .add(sentence['sentenceContent']);
                                    ipaList.add(sentence['sentenceIPA']);
                                    translateList
                                        .add(sentence['sentenceChinese']);
                                    idList.add(sentence['sentenceId']);
                                  }
                                }

                                List<String> contentNoDupe =
                                    contentList.toSet().toList();
                                List<String> TransNoDupe =
                                    translateList.toSet().toList();

                                List<String> filtedContentList = [];
                                List<String> filtedIPA = [];
                                List<bool> mainCheckList = [];
                                List<String> oriList = [];

                                await _getCompleteSentenceList(contentNoDupe);
                                print('CL: ${_CompleteSentenceList}');

                                for (final filtedContent
                                    in _CompleteSentenceList) {
                                  mainCheckList.add(filtedContent['mainCheck']);
                                  filtedContentList
                                      .add(filtedContent['content']);
                                  filtedIPA.add(filtedContent['IPA']);
                                  oriList.add(filtedContent['originSentence']);
                                }
                                print('HERE: ${filtedContentList}');

                                AutoRouter.of(context)
                                    .push(LearningAutoVocabularyPracticeWordLiteRoute(
                                  contentList: filtedContentList,
                                  ipaList: filtedIPA,
                                  translateList: TransNoDupe,
                                  mainCheckList: mainCheckList,
                                  oriList: oriList,
                                  idList: idList,
                                ));
                              }),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: _vocabularyList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: PageTheme.app_theme_blue,
                        width: 2,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: AutoSizeText(
                            _vocabularyList[index]['word'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: PageTheme.app_theme_blue,
                              fontSize: 24,
                            ),
                            group: _wordTextSizeGroup,
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: AutoSizeText(
                            '[${_vocabularyList[index]['wordIPA']}]',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: PageTheme.app_theme_blue,
                              fontSize: 20,
                            ),
                            group: _wordIPATextSizeGroup,
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: _vocabularyList[index]
                                      ['wordMeaningList']
                                  .length,
                              itemBuilder: (context, index2) {
                                return AutoSizeText(
                                  '[${_vocabularyList[index]['wordMeaningList'][index2]['pos']}] ${_vocabularyList[index]['wordMeaningList'][index2]['meaning']}',
                                  style: TextStyle(
                                    color: PageTheme.app_theme_blue,
                                    fontSize: 16,
                                  ),
                                  group: _wordMeaningTextSizeGroup,
                                  maxLines: 2,
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(padding: const EdgeInsets.all(8.0));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

/*
  other
   */

  Future<bool> _getVocabularySentenceList() async {
    //if (_vocabularySentenceList.length == _vocabularyList.length) return;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      List<dynamic> vocabularySentenceList;
      //print(_vocabularyList);
      do {
        String responseJSON = await APIUtil.vocabularyGetSentenceList(
            _vocabularyList[0]['rowIndex'].toString(),
            dataLimit: _vocabularyList.length.toString());
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      //print(responseJSONDecode);
      vocabularySentenceList = responseJSONDecode['data'];

      setState(() {
        _vocabularySentenceList = vocabularySentenceList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode['apiStatus'] == 'success';
  }

  Future<bool> _getCompleteSentenceList(List content) async {
    //if (_vocabularySentenceList.length == _vocabularyList.length) return;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    var responseJSON;
    try {
      int doLimit = 1;
      var vocabularySentenceList;
      //print(_vocabularyList);
      do {
        responseJSON = await APIUtil.getCompleteSentenceList(content);
        print(responseJSON);
        //responseJSONDecode = jsonDecode(responseJSON.toString());
        //print(responseJSONDecode);
        if (responseJSON['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception('API: ' + responseJSON['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSON['apiStatus'] != 'success');
      //print(responseJSONDecode);
      vocabularySentenceList = responseJSON['data'];

      setState(() {
        _CompleteSentenceList = vocabularySentenceList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSON['apiStatus'] == 'success';
  }
}