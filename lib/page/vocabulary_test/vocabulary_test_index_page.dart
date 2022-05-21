import 'dart:convert';
import 'dart:io';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VocabularyTestIndexPage extends StatefulWidget {
  const VocabularyTestIndexPage({Key? key}) : super(key: key);

  @override
  _VocabularyTestIndexPage createState() => _VocabularyTestIndexPage();
}

class _VocabularyTestIndexPage extends State<VocabularyTestIndexPage> {
  List<dynamic> _vocabularyTestQuestionList = [];
  List<Widget> _listViews = <Widget>[];

  @override
  void initState() {
    _addAllListData();
    super.initState();
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
            '詞彙測驗',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: ListView.builder(
            padding: EdgeInsets.only(
              top: 24,
              bottom: 62,
            ),
            itemCount: _listViews.length,
            itemBuilder:  (BuildContext context, int index) {
              return _listViews[index];
            }
        )
    );
  }


  void _addAllListData() {

    var titleTextSizeGroup = AutoSizeGroup();

    _listViews.add(
      const Padding(
          padding: EdgeInsets.all(8),
          child: AutoSizeText('選擇您的測試級別',
            style: PageTheme.index_vocabulary_test_index_text,maxLines: 1,)),
    );

    _listViews.add(
      const Padding(
          padding: EdgeInsets.all(8),
          child: AutoSizeText('Please select your test level．',
            style: PageTheme.index_vocabulary_test_index_text,maxLines: 1,)),
    );

    _listViews.add(
      const Padding(
          padding: EdgeInsets.all(8),
          child: AutoSizeText('友情提示:為確保結果的準確性，不會的請點擊選項E。',maxLines: 2,
              style: PageTheme.index_vocabulary_test_index_text)),
    );
    _listViews.add(
        Container(
          margin: EdgeInsets.all(10),
          child: OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red))),
                side: MaterialStateProperty.all(BorderSide(
                  //color: Colors.blue,
                    width: 2.0,
                    style: BorderStyle.solid)),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 24))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 9,
                      child: AutoSizeText(
                          '1. 常用單字 1~300 字 詞彙測驗',
                          group: titleTextSizeGroup,
                          maxLines: 1
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Icon(
                          Icons.play_arrow,
                          size: 30
                      )
                  ),
                ],
              ),
            ),
            onPressed: () {
              _jumpQuestingPage(1, 300);
            },
          ),
        )
    );

    _listViews.add(
        Container(
          margin: EdgeInsets.all(10),
          child: OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red))),
                side: MaterialStateProperty.all(BorderSide(
                  //color: Colors.blue,
                    width: 2.0,
                    style: BorderStyle.solid)),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 24))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 9,
                      child: AutoSizeText(
                          '2. 常用單字 301~500 字 詞彙測驗',
                          group: titleTextSizeGroup,
                          maxLines: 1
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Icon(
                          Icons.play_arrow,
                          size: 30
                      )
                  ),
                ],
              ),
            ),
            onPressed: () {
              _jumpQuestingPage(301, 500);
            },
          ),
        )
    );

  }


  Future<void> _jumpQuestingPage(int indexMin, int indexMax) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try{
      List<dynamic> vocabularyTestQuestionList;
      var responseJSONDecode;
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.vocabularyTestGetQuestion(indexMin: indexMin.toString(), indexMax: indexMax.toString(), dataLimit: '25');
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if(responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1) throw Exception('API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          sleep(Duration(seconds:1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      vocabularyTestQuestionList = responseJSONDecode['data'];

      setState(() {
        _vocabularyTestQuestionList = vocabularyTestQuestionList;
      });
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    //print(_vocabularyTestQuestionList);
    AutoRouter.of(context).push(VocabularyTestQuestingRoute(vocabularyTestQuestionList: _vocabularyTestQuestionList));
  }

}
