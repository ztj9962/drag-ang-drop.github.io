
import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/api_util.dart';

class VocabularyPracticeWordIndexPage extends StatefulWidget {
  const VocabularyPracticeWordIndexPage({Key? key}) : super(key: key);

  @override
  _VocabularyPracticeWordIndexPageState createState() => _VocabularyPracticeWordIndexPageState();
}

class _VocabularyPracticeWordIndexPageState extends State<VocabularyPracticeWordIndexPage> {

  TextEditingController _editingController = TextEditingController();
  int _rowIndexSliderMin = 1;
  int _rowIndexSliderMax = 10000;
  int _rowIndexSliderIndex = 1;
  int _amountSliderIndex = 5;
  int _dataLimit = 5;
  String _sliderEducationLevel = '國小';

  List<dynamic> _vocabularyList = [];

  @override
  void initState() {
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
                titleTxt: '1. 選擇詞彙級別或直接搜尋單字',
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
                      max: _rowIndexSliderMax.toDouble() - _dataLimit.toDouble() + 1,
                      activeColor: PageTheme.app_theme_blue,
                      inactiveColor: Colors.lightBlue,
                      divisions: (_rowIndexSliderMax - _dataLimit - _rowIndexSliderMin),
                      //value: _applicationSettingsDataTtsRate,
                      value: _rowIndexSliderIndex.toDouble(),
                      //label: 'Ranking ${_rowIndexSliderIndex * 10 - 9} ~ ${_rowIndexSliderIndex * 10}',
                      label: '${_rowIndexSliderIndex} ~ ${_rowIndexSliderIndex + _dataLimit - 1}',
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
                              )
                          ),
                          Expanded(
                              flex: 3,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor: PageTheme.app_theme_blue,
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
                                        backgroundColor: PageTheme.app_theme_blue,
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
                              )
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: TextEditingController(text: _rowIndexSliderIndex.toString()),
                              onSubmitted: (value) {
                                if (int.tryParse(value) != null) {
                                  _adjustRowIndexSliderIndex(int.tryParse(value)! - _rowIndexSliderIndex);
                                }
                              },
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0))
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) async {
                  await _searchVocabularyRowIndex(value);
                },
                controller: _editingController,
                decoration: const InputDecoration(
                    labelText: "搜尋單詞",
                    hintText: "搜尋單詞",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: TitleView(
                titleTxt: '2. 選擇練習字數',
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
                          _amountSliderIndex = value.toInt();
                        });
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          _amountSliderIndex = value.toInt();
                        });
                        _adjustDataLimit(_amountSliderIndex);
                      },
                      min: 5,
                      max: 10,
                      activeColor: PageTheme.app_theme_blue,
                      inactiveColor: Colors.lightBlue,
                      divisions: 15,
                      //value: _applicationSettingsDataTtsRate,
                      value: _amountSliderIndex.toDouble(),
                      label: '${_amountSliderIndex}',
                      //label: '${_rowIndexSliderIndex} ~ ${_rowIndexSliderIndex + _dataLimit - 1}',
                    ),
                    AutoSizeText(
                      '${_amountSliderIndex} 個',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: PageTheme.app_theme_blue,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),
            Container(
              width: 350,
              child: ElevatedButton(
                  child: const AutoSizeText(
                    '開啟詞彙列表',
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
                    await _getVocabularyList();
                    AutoRouter.of(context).push(VocabularyPracticeWordListRoute(vocabularyList:_vocabularyList));
                  }
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
    try{
      int doLimit = 1;
      List<dynamic> vocabularyList;
      do {
        String responseJSON = await APIUtil.vocabularyGetList(_rowIndexSliderIndex.toString(), dataLimit: _dataLimit.toString());
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if(responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3) throw Exception('API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds:1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      vocabularyList = responseJSONDecode['data'];
      setState(() {
        _vocabularyList = vocabularyList;
      });
    } catch(e) {
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
    try{
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.vocabularyGetRowIndex(word);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if(responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1) throw Exception('API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds:1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');

      if (int.tryParse(responseJSONDecode['data']['index'].toString()) != null) {
        _adjustRowIndexSliderIndex(int.tryParse(responseJSONDecode['data']['index'].toString())! - _rowIndexSliderIndex);
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode['apiStatus'] == 'success';
  }


  void _adjustRowIndexSliderIndex(int value) {
    int sliderIndex = _rowIndexSliderIndex + value;
    if( (sliderIndex >= _rowIndexSliderMin) && (sliderIndex <= (_rowIndexSliderMax - _dataLimit + 1)) ){
      setState(() => _rowIndexSliderIndex = sliderIndex);
    } else {
      if (sliderIndex < _rowIndexSliderMin) {
        setState(() => _rowIndexSliderIndex = _rowIndexSliderMin);
      }
      if (sliderIndex > (_rowIndexSliderMax - _dataLimit + 1)) {
        setState(() => _rowIndexSliderIndex = (_rowIndexSliderMax - _dataLimit + 1));
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

  void _adjustDataLimit(int value) {
    setState(() {
      _dataLimit = value;
    });
    if (_rowIndexSliderIndex > (_rowIndexSliderMax - _dataLimit + 1)) {
      setState(() => _rowIndexSliderIndex = (_rowIndexSliderMax - _dataLimit + 1));
    }
  }

}