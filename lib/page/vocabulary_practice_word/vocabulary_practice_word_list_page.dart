import 'dart:convert';

import 'package:alicsnet_app/page/login/fade_animation.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/api_util.dart';

class VocabularyPracticeWordListPage extends StatefulWidget {
  final int rangeMin;
  final int rangeMax;
  final String displayLevel;
  final String wordLevel;
  final String cateType;

  const VocabularyPracticeWordListPage(
      {Key? key,
      required this.rangeMin,
      required this.rangeMax,
      required this.displayLevel,
      required this.cateType,
      required this.wordLevel})
      : super(key: key);

  @override
  _VocabularyPracticeWordListPageState createState() =>
      _VocabularyPracticeWordListPageState();
}

class _VocabularyPracticeWordListPageState
    extends State<VocabularyPracticeWordListPage> {
  late String _cateType;
  TextEditingController _editingController = TextEditingController();
  int _rowIndexSliderMin = 2000;
  int _rowIndexSliderMax = 10000;
  int _rowIndexSliderIndex = 2000;
  int _dataLimit = 5;
  int _previousFifthIndex = 1;
  String _sliderEducationLevel = '國小';
  var _wordTextSizeGroup = AutoSizeGroup();
  var _wordIPATextSizeGroup = AutoSizeGroup();
  var _wordMeaningTextSizeGroup = AutoSizeGroup();

  List<dynamic> _vocabularyList = [];
  List<dynamic> _vocabularySentenceList = [];

  @override
  void initState() {
    _cateType = widget.cateType;
    if (_cateType == 'proficiencyTestLevel') {
      _rowIndexSliderMin = 1;
      _rowIndexSliderMax = widget.rangeMax - widget.rangeMin + 1;
    } else {
      _rowIndexSliderMin = widget.rangeMin;
      _rowIndexSliderMax = widget.rangeMax;
    }
    _rowIndexSliderIndex = _rowIndexSliderMin;
    _sliderEducationLevel = widget.displayLevel;

    initVocabularyPracticeWordListPage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  void initVocabularyPracticeWordListPage() async {

    int parsec = (_rowIndexSliderIndex - _rowIndexSliderMin) % 5;
    _previousFifthIndex = _rowIndexSliderIndex - parsec;

    await _getVocabularyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PageTheme.app_theme_black,
        title: AutoSizeText(
          '一萬個最常用的單字和例句',
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
              child: TitleView(
                titleTxt: '選擇詞彙級別或直接搜尋單字',
                titleColor: Colors.black,
              ),
            ),
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
                    Slider(
                      autofocus: false,
                      onChanged: (value) {
                        setState(() {
                          _rowIndexSliderIndex = value.toInt();
                        });
                        //_adjustSliderEducationLevel();
                      },
                      onChangeEnd: (value) async {
                        ///滑條變動結束
                        print(_previousFifthIndex);
                        _adjustRowIndexSliderIndex(0);
                        await _getVocabularyList();
                        setState(() {
                          _rowIndexSliderIndex = value.toInt();
                        });
                        //initWordList();
                        //_adjustSliderEducationLevel();
                      },
                      min: _rowIndexSliderMin.toDouble(),
                      max: _rowIndexSliderMax.toDouble(),
                      activeColor: PageTheme.app_theme_blue,
                      inactiveColor: Colors.lightBlue,
                      divisions: (_rowIndexSliderMax -
                          _dataLimit -
                          _rowIndexSliderMin),
                      //value: _applicationSettingsDataTtsRate,
                      value: _rowIndexSliderIndex.toDouble(),
                      //label: 'Ranking ${_rowIndexSliderIndex * 10 - 9} ~ ${_rowIndexSliderIndex * 10}',
                      label:
                          '${_rowIndexSliderIndex}',
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                (_rowIndexSliderMax - _previousFifthIndex <= 5) ? '${_sliderEducationLevel}\n(${_previousFifthIndex} ~ ${_rowIndexSliderMax})' : '${_sliderEducationLevel}\n(${_previousFifthIndex} ~ ${_previousFifthIndex + 4})',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: PageTheme.app_theme_blue,
                                ),
                                maxLines: 2,
                              )),
                          Expanded(
                              flex: 3,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor:
                                            PageTheme.app_theme_blue,
                                        radius: 20.0,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_back_ios),
                                          color: Colors.white,
                                          onPressed: () async {
                                            if(_rowIndexSliderIndex - _rowIndexSliderMin <= 5){
                                              _adjustRowIndexSliderIndex(-(_rowIndexSliderIndex - _rowIndexSliderMin));
                                            }else {
                                              _adjustRowIndexSliderIndex(-5);
                                            }
                                            await _getVocabularyList();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor:

                                            PageTheme.app_theme_blue,
                                        radius: 20.0,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          color: Colors.white,
                                          onPressed: () async {
                                            if(_rowIndexSliderMax - _previousFifthIndex <= 5){
                                              _adjustRowIndexSliderIndex((_rowIndexSliderMax) - _rowIndexSliderIndex);
                                            }else {
                                              _adjustRowIndexSliderIndex(5);
                                            }
                                            await _getVocabularyList();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: TextEditingController(
                                  text: _rowIndexSliderIndex.toString()),
                              onSubmitted: (value) async {
                                if (int.tryParse(value) != null) {
                                  _adjustRowIndexSliderIndex(
                                      int.tryParse(value)! -
                                          _rowIndexSliderIndex);
                                  await _getVocabularyList();
                                }
                              },
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (_cateType == 'educationLevel')
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onSubmitted: (value) async {
                        await _searchVocabularyRowIndex(value);
                        await _getVocabularyList();
                      },
                      controller: _editingController,
                      decoration: const InputDecoration(
                          labelText: "搜尋單詞",
                          hintText: "搜尋單詞",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  )
                : Container(),
            Padding(padding: EdgeInsets.all(15)),
            if (_vocabularyList.isNotEmpty)
              FadeAnimation(
                1,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text("Vocabulary List Preview",
                                style: TextStyle(
                                    color: PageTheme
                                        .cutom_article_practice_background,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 2,
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text("單字列表預覽",
                          style: TextStyle(
                              color: PageTheme.cutom_article_practice_background
                                  .withOpacity(0.8),
                              fontSize: 14,
                              height: 1.0,
                              fontWeight: FontWeight.bold)),
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
                                  flex: 2,
                                  child: (_cateType == 'proficiencyTestLevel')
                                      ? Container(
                                        child:
                                          AutoSizeText(
                                            (_rowIndexSliderIndex % 5 == 0) ? "${(_rowIndexSliderIndex - 4) + index}\nRk. ${_vocabularyList[index]['ranking'].toInt()}" : "${(_rowIndexSliderIndex - (_rowIndexSliderIndex % 5) + 1) + index}\nRk. ${_vocabularyList[index]['ranking'].toInt()}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: PageTheme.app_theme_blue,
                                                fontSize: 24,
                                              ),
                                              group: _wordTextSizeGroup,
                                              maxLines: 2,
                                            ),
                                      )
                                      : AutoSizeText(
                                    (_previousFifthIndex + index).toString()
                                          ,
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
                                  flex: 3,
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
                                  flex: 3,
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
                                (_vocabularyList[index]['wordMeaningList'] !=
                                        null)
                                    ? Expanded(
                                        flex: 2,
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
                                                  color:
                                                      PageTheme.app_theme_blue,
                                                  fontSize: 16,
                                                ),
                                                group:
                                                    _wordMeaningTextSizeGroup,
                                                maxLines: 2,
                                              );
                                            }),
                                      )
                                    : Container(),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Padding(
                              padding: const EdgeInsets.all(8.0));
                        },
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Row(children: <Widget>[
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
                                          horizontal: 20, vertical: 20),
                                      shadowColor: Colors.black,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  onPressed: () async {
                                    if (!await _getVocabularySentenceList()) {
                                      return;
                                    }

                                    List<String> contentList = [];
                                    List<String> ipaList = [];
                                    List<String> translateList = [];
                                    List<String> idList = [];

                                    for (final vocabularyData
                                        in _vocabularySentenceList) {
                                      //return;
                                      for (final sentence
                                          in vocabularyData!['sentenceList']!) {
                                        //句子題目整理
                                        List disassembleList =
                                            sentence['sentenceDisassembleList'];
                                        for (int i = disassembleList.length - 1;
                                            i >= 0;
                                            i--) {
                                          contentList.add(disassembleList[i]);
                                        }
                                        contentList
                                            .add(sentence['sentenceContent']);
                                        //IPA整理
                                        List disassembleIPAList = sentence[
                                            'sentenceDisassembleIPAList'];
                                        for (int i =
                                                disassembleIPAList.length - 1;
                                            i >= 0;
                                            i--) {
                                          ipaList.add(disassembleIPAList[i]);
                                        }
                                        ipaList.add(sentence['sentenceIPA']);
                                        //翻譯整理
                                        while (contentList.length -
                                                    translateList.length !=
                                                1 &&
                                            translateList.length <
                                                contentList.length) {
                                          translateList.add(
                                              '原句:${sentence['sentenceContent']}');
                                        }
                                        ;
                                        translateList
                                            .add(sentence['sentenceChinese']);
                                        //ID
                                        while (contentList.length -
                                                    idList.length !=
                                                0 &&
                                            idList.length <
                                                contentList.length) {
                                          idList.add(sentence['sentenceId']
                                              .toString());
                                        }
                                        ;
                                      }
                                    }

                                    AutoRouter.of(context).push(
                                        LearningAutoGenericRoute(
                                            contentList: contentList,
                                            ipaList: ipaList,
                                            translateList: translateList,
                                            idList: idList));
                                  }),
                            ),
                          ),
                          Expanded(
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
                                          horizontal: 20, vertical: 20),
                                      shadowColor: Colors.black,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  onPressed: () async {
                                    await _getVocabularySentenceList();
                                    AutoRouter.of(context).push(
                                        LearningManualVocabularyPraticeWordRoute(
                                            vocabularyList: _vocabularyList,
                                            vocabularySentenceList:
                                                _vocabularySentenceList));
                                  }),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(8.0)),
                  ],
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
  Future<bool> _getVocabularyList() async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      List<dynamic> vocabularyList;
      do {
        String responseJSON;
        //responseJSON = await APIUtil.vocabularyGetList(_rowIndexSliderIndex.toString(),dataLimit: _dataLimit.toString());

        if (_cateType == 'proficiencyTestLevel') {
          //responseJSON = await APIUtil.vocabularyGetList((_rowIndexSliderIndex + widget.rangeMin - 1).toString(),dataLimit: _dataLimit.toString());
          responseJSON = await APIUtil.getWordListByWherelistLevel(
              _previousFifthIndex.toString(), widget.wordLevel);
        } else {
          responseJSON = await APIUtil.vocabularyGetList(
              _previousFifthIndex.toString(),
              dataLimit: _dataLimit.toString());
        }

        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      vocabularyList = responseJSONDecode['data'];
      setState(() {
        _vocabularyList = vocabularyList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode['apiStatus'] == 'success';
  }

  Future<bool> _searchVocabularyRowIndex(String word) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.vocabularyGetRowIndex(word);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');

      if (int.tryParse(responseJSONDecode['data']['index'].toString()) !=
          null) {
        _adjustRowIndexSliderIndex(
            int.tryParse(responseJSONDecode['data']['index'].toString())! -
                _rowIndexSliderIndex);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode['apiStatus'] == 'success';
  }

  ///融合過來的功能
  ///
  Future<bool> _getVocabularySentenceList() async {
    if (_vocabularySentenceList.isNotEmpty &&
        _vocabularySentenceList[0]['rowIndex'] ==
            _vocabularyList[0]['rowIndex']) return true;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      List<dynamic> vocabularySentenceList;
      do {
        String responseJSON;
        if (_cateType == 'proficiencyTestLevel') {
          responseJSON = await APIUtil.getSentenceListByWherelistLevel(
              _vocabularyList[0]['rowIndex'].toString(), widget.wordLevel,
              dataLimit: _vocabularyList.length.toString());
        } else {
          responseJSON = await APIUtil.vocabularyGetSentenceList(
              _vocabularyList[0]['rowIndex'].toString(),
              dataLimit: _vocabularyList.length.toString());
        }
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
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

  void _adjustRowIndexSliderIndex(int value) {
    int sliderIndex = _rowIndexSliderIndex + value;

    if ((sliderIndex >= _rowIndexSliderMin) &&
        (sliderIndex <= (_rowIndexSliderMax))) {

      int parsec = (sliderIndex - _rowIndexSliderMin) % 5;
      _previousFifthIndex = sliderIndex - parsec;

      if(_rowIndexSliderMax - _previousFifthIndex <= 5){
        _dataLimit = _rowIndexSliderMax - _previousFifthIndex + 1 ;
      }else{
        _dataLimit = 5;
      }

      setState(() => _rowIndexSliderIndex = sliderIndex);
    } else {
      if (sliderIndex < _rowIndexSliderMin) {
        setState(() => _rowIndexSliderIndex = _rowIndexSliderMin);
      }
      if (sliderIndex > (_rowIndexSliderMax)) {
        setState(
            () => _rowIndexSliderIndex = (_rowIndexSliderMax));
      }
      int parsec = (sliderIndex - _rowIndexSliderMin) % 5;
      _previousFifthIndex = sliderIndex - parsec;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Opps: 您要找的單字位於Rank ${sliderIndex} 不存在${_sliderEducationLevel}範圍'),
      ));
    }
  }
}
