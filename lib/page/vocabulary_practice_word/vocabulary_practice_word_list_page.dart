import 'dart:convert';
import 'dart:io';

import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VocabularyPracticeWordListPage extends StatefulWidget {
  final List<dynamic> vocabularyList;
  const VocabularyPracticeWordListPage ({ Key? key, required this.vocabularyList }): super(key: key);

  @override
  _VocabularyPracticeWordListPageState createState() => _VocabularyPracticeWordListPageState();
}

class _VocabularyPracticeWordListPageState extends State<VocabularyPracticeWordListPage> {
  late List<dynamic> _vocabularyList;
  List<dynamic> _vocabularySentenceList = [];
  var _wordTextSizeGroup = AutoSizeGroup();
  var _wordIPATextSizeGroup = AutoSizeGroup();
  var _wordMeaningTextSizeGroup = AutoSizeGroup();



  TextEditingController _editingController = TextEditingController();
  List<Widget> listViews = <Widget>[];
  int _sliderMin = 1;
  int _sliderMax = 10000;
  int _sliderIndex = 1;
  int _dataLimit = 10;
  String _sliderEducationLevel = '國小';

  Map<String, dynamic> _wordSetData = {
    'wordSetClassification': '',
    'learningClassificationName': '',
    'wordSetTotal': 1,
    'averageScore': 0,
    'wordSetArray': [],
  };

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
                      '選擇以下單字練習模式',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        color: PageTheme.app_theme_blue,
                      ),
                      maxLines: 1,
                    ),
                    Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  child: const AutoSizeText(
                                    '自動練習',
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

                                    await _getVocabularySentenceList();

                                    List<String> contentList = [];
                                    List<String> ipaList = [];
                                    List<String> translateList = [];
                                    //print(_vocabularyList);
                                    for (final vocabularyData in _vocabularySentenceList) {
                                      print(vocabularyData);
                                      //return;
                                      for (final sentence in vocabularyData!['sentenceList']!) {
                                        contentList.add(sentence['sentenceContent']);
                                        ipaList.add(sentence['sentenceIPA']);
                                        translateList.add(sentence['sentenceChinese']);
                                      }
                                    }
                                    AutoRouter.of(context).push(LearningAutoGenericRoute(contentList: contentList, ipaList: ipaList, translateList: translateList));
                                  }
                              ),
                            ),
                          ),Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  child: const AutoSizeText(
                                    '手動練習',
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
                                    await _getVocabularySentenceList();
                                    AutoRouter.of(context).push(LearningManualVocabularyPraticeWordRoute(vocabularyList: _vocabularyList, vocabularySentenceList: _vocabularySentenceList));
                                  }
                              ),
                            ),
                          ),
                        ]
                    ),
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
                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
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
                              itemCount: _vocabularyList[index]['wordMeaningList'].length,
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
                              }
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index){
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

  Future<void> _getVocabularySentenceList() async {
    if (_vocabularySentenceList.length == _vocabularyList.length) return;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try{
      var responseJSONDecode;
      int doLimit = 1;
      List<dynamic> vocabularySentenceList;
      do {
        String responseJSON = await APIUtil.vocabularyGetSentenceList(_vocabularyList[0]['rowIndex'].toString(), dataLimit: _vocabularyList.length.toString());
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if(responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3) throw Exception('API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          sleep(Duration(seconds:1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      print(responseJSONDecode);
      vocabularySentenceList = responseJSONDecode['data'];

      setState(() {
        _vocabularySentenceList = vocabularySentenceList;
      });

    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
  }

}