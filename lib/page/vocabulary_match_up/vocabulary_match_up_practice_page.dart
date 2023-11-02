import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VocabularyMatchUpPracticePage extends StatefulWidget {
  const VocabularyMatchUpPracticePage({Key? key, required this.minRank, required this.maxRank}) : super(key: key);
  final int minRank;
  final int maxRank;

  @override
  _VocabularyMatchUpPracticePageState createState() => _VocabularyMatchUpPracticePageState();
}

class _VocabularyMatchUpPracticePageState extends State<VocabularyMatchUpPracticePage> {
  late int _minRange;
  late int _maxRange;
  List<String> _questionEnglish = [
  'walk',
  'choice',
  'market',
  'those',
  'shake',
  'window',
  'toy',
  'cookie',
  'wise',
  'health',
];
  List<String> _questionChinese = [
  '走路',
  '上等的,精選的;挑三揀四的',
  '市場',
  '那些的;那;',
  '搖動;奶昔',
  '窗戶',
  '玩具',
  '餅乾',
  '有智慧的',
  '健康',
  ];
  @override
  void initState() {
    _minRange = widget.minRank;
    _maxRange = widget.maxRank;
    super.initState();
    initVocabularyMatchUpPracticePage(_minRange,_maxRange);
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
          backgroundColor: PageTheme.app_theme_black,
          centerTitle: true,
          title: AutoSizeText(
            '單字連連看',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 800,
              decoration: BoxDecoration(
                border: Border.all(
                  color: PageTheme.app_theme_blue,
                  width: 1,
                ),
                borderRadius:
                const BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount:
                          _questionEnglish.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: PageTheme.app_theme_blue,
                                        width: 1,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(16.0)),
                                    ),
                                    child: AutoSizeText(_questionEnglish[index].toString()),
                                  ),
                                ),
                                //Dragable
                                Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.red,
                                ),
                              ],
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                            return const Padding(padding: EdgeInsets.all(16));
                        },
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(16)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount:
                          _questionChinese.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                //DragTarget
                                Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.red,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: PageTheme.app_theme_blue,
                                        width: 1,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(16.0)),
                                    ),
                                    child: AutoSizeText(_questionChinese[index].toString()),
                                  ),
                                ),
                              ],
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                          return const Padding(padding: EdgeInsets.all(16));
                        },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> initVocabularyMatchUpPracticePage(int minRank, int maxRank) async {
    /*
      EasyLoading.show(status: '正在讀取資料，請稍候......');
      var jsonFormatted;
      do {
        String jsonString = await APIUtil.getMatchUpQuestion(_minRange.toString(),_maxRange.toString(),'10');
        jsonFormatted = jsonDecode(jsonString.toString());
        if (jsonFormatted['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (jsonFormatted['apiStatus'] != 'success');

      EasyLoading.dismiss();

      setState(() {

      });*/
  }
}
