import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:alicsnet_app/view/button_square_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class VocabularyPracticeWordIndexPage extends StatefulWidget {
  const VocabularyPracticeWordIndexPage({Key? key}) : super(key: key);

  @override
  _VocabularyPracticeWordIndexPageState createState() =>
      _VocabularyPracticeWordIndexPageState();
}

class _VocabularyPracticeWordIndexPageState
    extends State<VocabularyPracticeWordIndexPage> {
  List<Widget> _listViews = <Widget>[];

  bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    initVocabularyPracticeWordIndexPage();
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
            '選擇難度級別',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: ListView.builder(
              padding: EdgeInsets.only(
                top: 24,
                bottom: 62,
              ),
              itemCount: _listViews.length,
              itemBuilder: (BuildContext context, int index) {
                return _listViews[index];
              }),
        ));
  }

  initVocabularyPracticeWordIndexPage() async {
    await initLevelList();
  }

  Future<bool> initLevelList() async {
    var responseJSONDecode;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.get10kLevelData();
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');

      List<Widget> listViews = <Widget>[];

      List<String> categoryStringList = [
        'educationLevel',
        'proficiencyTestLevel'
      ];

      for (String cateStr in categoryStringList) {
        List dataList = responseJSONDecode['data'][cateStr];
        //print(key);
        //print(value);
        switch (cateStr) {
          case 'educationLevel':
            listViews.add(
              Container(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(8)),
                    TitleView(
                      titleTxt: 'Education Level\n教育程度檢定',
                      titleColor: Colors.black,
                      centerAlign: true,
                    ),
                    Divider(
                      thickness: 1,
                    ),

                  ],
                ),
              ),
            );
            listViews.add(Container(
              decoration: BoxDecoration(
                color: HexColor('#EEF2F8'),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(8)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(Icons.book),
                          Padding(padding: EdgeInsets.all(10)),
                          Column(
                            children: [
                              AutoSizeText(
                                '教育等級',
                                style: TextStyle(color: PageTheme.vocabulary_practice_index_text, fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              AutoSizeText(
                                  "Education level"
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 2,
                        children: List.generate(dataList!.length, (index) {
                          //if (index == 0) return Container();
                          //return Text(value['title'][index]);
                          //print(value['title'][index]);
                          return Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: ButtonSquareView(
                                      mainText: '${dataList[index]['displayLevel']}',
                                      subTextBottomRight: '',
                                      subTextBottomLeft: 'Rank ${dataList[index]['minWordRank']}~${dataList[index]['maxWordRank']}',
                                      onTapFunction: () {
                                        AutoRouter.of(context).push(
                                            VocabularyPracticeWordListRoute(
                                                rangeMin: dataList[index]
                                                ['minWordRank'],
                                                rangeMax: dataList[index]
                                                ['maxWordRank'],
                                                displayLevel: dataList[index]
                                                ['displayLevel'],
                                                cateType: cateStr,
                                                wordLevel: ''));
                                      },
                                      widgetColor: HexColor('#FDFEFB'),
                                      borderColor: Colors.transparent,
                                      //widgetColor: PageTheme.app_theme_blue.withOpacity(
                                      //    0.2 + index * (0.8 / dataList!.length)),
                                    ),
                                  ),
                              ),
                            ],
                          );
                        })),
                  ),
                  Padding(padding: EdgeInsets.all(20))
                ],
              ),
            ));
            break;
          case 'proficiencyTestLevel':
            listViews.add(
              Container(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(8)),
                    TitleView(
                      titleTxt: 'Proficiency Test Level\n英文能力檢定',
                      titleColor: Colors.black,
                      centerAlign: true,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    AutoSizeText(
                      '*CEFR等級的斜線後中文字等級表對應之全民英檢等級\n(A1/初級一): CERF A1 對應全民英檢初級',
                      style: TextStyle(color: PageTheme.grey),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                  ],
                ),
              ),
            );
            for (var wherelistGroupData in dataList) {
              //每個單字集群組的標頭與方形按鈕
              List groupListData = wherelistGroupData['groupListData'];
              listViews.add(
                Container(
                  decoration: BoxDecoration(
                    color: HexColor('#EEF2F8'),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(8)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Icon(Icons.book),
                                Padding(padding: EdgeInsets.all(10)),
                                Column(
                                  children: [
                                    AutoSizeText(
                                      wherelistGroupData['groupDescribe'],
                                      style: TextStyle(color: PageTheme.vocabulary_practice_index_text, fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    AutoSizeText(
                                        "${wherelistGroupData['groupTitle']}"
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 2,
                            children: List.generate(groupListData!.length, (index) {
                              //if (index == 0) return Container();
                              //return Text(value['title'][index]);
                              //print(value['title'][index]);
                              return Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      width: 400,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                      ),
                                      child: ButtonSquareView(
                                          mainText:
                                          '${groupListData[index]['describe']}',
                                          subTextBottomRight:
                                          ('單字量${groupListData[index]['wordCount']}'),
                                          subTextBottomLeft:
                                          ('${groupListData[index]['displayLevel']}'),
                                          onTapFunction: () {
                                            AutoRouter.of(context).push(
                                                VocabularyPracticeWordListRoute(
                                                    rangeMin: 1,
                                                    rangeMax: groupListData[index]
                                                    ['wordCount'],
                                                    displayLevel: groupListData[index]
                                                    ['displayLevel'],
                                                    cateType: cateStr,
                                                    wordLevel: groupListData[index]
                                                    ['wordLevel']));
                                          },
                                          widgetColor: HexColor('#FDFEFB'), borderColor: Colors.transparent
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            })),
                      ),
                      Padding(padding: EdgeInsets.all(15)),
                    ],
                  ),
                ),
              );
            listViews.add(
              Padding(padding: EdgeInsets.all(8))
            );
            }
            break;
        }
      }


      setState(() {
        _listViews = listViews;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode['apiStatus'] == 'success';
  }
}
