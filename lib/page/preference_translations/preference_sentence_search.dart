import 'dart:async';
import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/api_util.dart';

class PreferenceTranslationSearchPage extends StatefulWidget {
  const PreferenceTranslationSearchPage({Key? key}) : super(key: key);

  @override
  _PreferenceTranslationSearchPageState createState() =>
      _PreferenceTranslationSearchPageState();
}

class _PreferenceTranslationSearchPageState
    extends State<PreferenceTranslationSearchPage> {
  TextEditingController _editingController = TextEditingController();
  int _rowIndexSliderMin = 1;
  int _rowIndexSliderMax = 10000;
  int _rowIndexSliderIndex = 1;
  int initMode = 0;
  String sentenceSearched = '';
  bool _checkCase = false;
  bool _searchAsVocabulary = false;

  int _dataLimit = 5;
  String _sliderEducationLevel = '國小';

  List<Widget> listViews = <Widget>[];
  Map _sentenceInfoList = {};

  @override
  void initState() {
    listViews.add(
      Center(
          child: AutoSizeText('現在還沒有任何搜尋結果，趕快來試試看吧!',
              style: TextStyle(color: PageTheme.app_theme_blue))),
    );
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
          '推薦翻譯系統',
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
                titleTxt: '1. 選擇詞彙級別或直接搜尋句子',
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
                        _adjustSliderEducationLevel();
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          _rowIndexSliderIndex = value.toInt();
                        });
                        //initWordList();
                        _adjustSliderEducationLevel();
                      },
                      min: _rowIndexSliderMin.toDouble(),
                      max: _rowIndexSliderMax.toDouble() -
                          _dataLimit.toDouble() +
                          1,
                      activeColor: PageTheme.app_theme_blue,
                      inactiveColor: Colors.lightBlue,
                      divisions: (_rowIndexSliderMax -
                          _dataLimit -
                          _rowIndexSliderMin),
                      //value: _applicationSettingsDataTtsRate,
                      value: _rowIndexSliderIndex.toDouble(),
                      //label: 'Ranking ${_rowIndexSliderIndex * 10 - 9} ~ ${_rowIndexSliderIndex * 10}',
                      label:
                          '${_rowIndexSliderIndex} ~ ${_rowIndexSliderIndex + _dataLimit - 1}',
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                '${_sliderEducationLevel}\n(${_rowIndexSliderIndex} ~ ${_rowIndexSliderIndex + _dataLimit - 1})',
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
                                          icon: Icon(Icons.remove),
                                          color: Colors.white,
                                          onPressed: () async {
                                            _adjustRowIndexSliderIndex(-1);
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
                                          icon: Icon(Icons.add),
                                          color: Colors.white,
                                          onPressed: () async {
                                            _adjustRowIndexSliderIndex(1);
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
                              onSubmitted: (value) {
                                if (int.tryParse(value) != null) {
                                  _adjustRowIndexSliderIndex(
                                      int.tryParse(value)! -
                                          _rowIndexSliderIndex);
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
            Padding(padding: EdgeInsets.all(15)),
            Container(
              width: 350,
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AutoSizeText(
                        '通過排行搜尋句子',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.search)
                    ],
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
                    initMode = 0;
                    await _getSentenceByRank(_rowIndexSliderIndex.toString());
                    listInit(0);
                  }),
            ),
            Padding(padding: EdgeInsets.all(15)),
            AutoSizeText(
              '或',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PageTheme.app_theme_blue,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onSubmitted: (value) async {
                          initMode = 1;
                          sentenceSearched = value;
                          await _getSentenceByRank(value);
                          listInit(1);
                        },
                        controller: _editingController,
                        decoration: const InputDecoration(
                            labelText: "搜尋句子或單字",
                            hintText: "搜尋句子或單字",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ),
                    /*
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Checkbox(
                                  onChanged: (bool? value) {
                                    _checkCase = !_checkCase;

                                    setState(() {});
                                  },
                                  value: _checkCase,
                                ),
                                const AutoSizeText(
                                  '忽略大小寫',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 20,color: PageTheme.app_theme_blue),
                                )
                              ],
                            )),
                            Expanded(
                                child: Row(
                              children: [
                                Checkbox(
                                  onChanged: (bool? value) {
                                    _searchAsVocabulary = !_searchAsVocabulary;

                                    setState(() {});
                                  },
                                  value: _searchAsVocabulary,
                                ),
                                const AutoSizeText(
                                  '當作單字查詢',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 20,color: PageTheme.app_theme_blue),
                                )
                              ],
                            )),
                          ],
                        )),*/
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TitleView(
                titleTxt: '2. 顯示句子翻譯',
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
                    children: [
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: listViews.length,
                        //itemExtent: 100.0, //强制高度为50.0

                        itemBuilder: (BuildContext context, int index) {
                          return listViews[index];
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                          height: 16,
                          color: PageTheme.grey,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /*
  other
   */

  void listInit(int mode) {
    List<dynamic> datalist = _sentenceInfoList['data'] as List<dynamic>;
    List _splitedContent = [];
    String _splitedString;
    listViews = [];

    if (datalist.isNotEmpty) {
      for (var i = 0; i < datalist.length; i++) {
        if (mode == 1) {
          _splitedString = _sentenceInfoList['data'][i]['sentenceContent'];
          _splitedContent = _splitedString
              .replaceAll(RegExp(sentenceSearched, caseSensitive: false), ';')
              .split(';');
        }
        listViews.add(
          Container(
            child: OutlinedButton(
                onPressed: () {
                  Map datalist = _sentenceInfoList['data'][i];
                  AutoRouter.of(context)
                      .push(PreferenceTranslationEditRoute(
                          sentenceDataList: datalist))
                      .then(onGoBack);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                              child: AutoSizeText(
                        mode == 0 ? 'RK' : "ID",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: PageTheme.app_theme_blue),
                      ))),
                      Expanded(
                          flex: 3,
                          child: Container(
                              child: AutoSizeText(
                            mode == 0
                                ? _sentenceInfoList['data'][i]['wordRank']
                                    .toString()
                                : _sentenceInfoList['data'][i]['sentenceID']
                                    .toString(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: PageTheme.app_theme_blue),
                          ))),
                      Padding(padding: EdgeInsets.all(8)),
                      Expanded(
                        flex: 7,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              initMode == 1
                                  ? RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: _splitedContent[0],
                                            style: TextStyle(
                                                color:
                                                    PageTheme.app_theme_blue)),
                                        TextSpan(
                                            text: sentenceSearched,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red)),
                                        TextSpan(
                                            text: _splitedContent[1],
                                            style: TextStyle(
                                                color:
                                                    PageTheme.app_theme_blue))
                                      ]),
                                    )
                                  : AutoSizeText(
                                      _sentenceInfoList['data'][i]
                                          ['sentenceContent'],
                                      textAlign: TextAlign.start,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: PageTheme.app_theme_blue),
                                    ),
                              AutoSizeText(
                                _sentenceInfoList['data'][i]['sentenceChinese'],
                                textAlign: TextAlign.start,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: PageTheme.app_theme_blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                //style: OutlinedButton.styleFrom(side: BorderSide(width: 2)),
                ),
          ),
        );
        setState(() {});
      }
    } else {
      listViews.add(
        Center(
            child: AutoSizeText(
          '沒有搜尋結果，請再次嘗試!',
          style: TextStyle(color: PageTheme.app_theme_blue),
        )),
      );
      setState(() {});
    }
  }

  FutureOr onGoBack(dynamic value) {
    listInit(initMode);
    setState(() {});
  }

  //getSentenceByRank
  Future<Map> _getSentenceByRank(String rank) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.getPreferenceSentenceByRank(rank);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        _sentenceInfoList = responseJSONDecode;
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  void _adjustRowIndexSliderIndex(int value) {
    int sliderIndex = _rowIndexSliderIndex + value;
    if ((sliderIndex >= _rowIndexSliderMin) &&
        (sliderIndex <= (_rowIndexSliderMax - _dataLimit + 1))) {
      setState(() => _rowIndexSliderIndex = sliderIndex);
    } else {
      if (sliderIndex < _rowIndexSliderMin) {
        setState(() => _rowIndexSliderIndex = _rowIndexSliderMin);
      }
      if (sliderIndex > (_rowIndexSliderMax - _dataLimit + 1)) {
        setState(
            () => _rowIndexSliderIndex = (_rowIndexSliderMax - _dataLimit + 1));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opps: 目標 ${sliderIndex} 已超出範圍'),
      ));
    }
    _adjustSliderEducationLevel();
  }

  void _adjustSliderEducationLevel() {
    String sliderEducationLevel = '國小';
    if (_rowIndexSliderIndex > 6000) {
      sliderEducationLevel = '大學';
    } else if (_rowIndexSliderIndex > 2000) {
      sliderEducationLevel = '高中';
    } else if (_rowIndexSliderIndex > 900) {
      sliderEducationLevel = '國中';
    }
    setState(() => _sliderEducationLevel = sliderEducationLevel);
  }

/*void _adjustDataLimit(int value) {
    setState(() {
      _dataLimit = value;
    });
    if (_rowIndexSliderIndex > (_rowIndexSliderMax - _dataLimit + 1)) {
      setState(
          () => _rowIndexSliderIndex = (_rowIndexSliderMax - _dataLimit + 1));
    }
  }*/
}
