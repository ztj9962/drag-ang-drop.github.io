import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:alicsnet_app/view/button_square_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

        listViews.add(
          Container(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(8)),
                TitleView(
                  titleTxt: (cateStr == 'educationLevel')
                      ? 'Education Level\n教育程度檢定'
                      : 'Proficiency Test Level\n英文能力檢定',
                  titleColor: Colors.black,
                  centerAlign: true,
                ),
                Divider(
                  thickness: 1,
                ),
                AutoSizeText(
                  (cateStr == 'proficiencyTestLevel')
                      ? '*CEFR等級的斜線後中文字等級表對應之全民英檢等級'
                      : '',
                  style: TextStyle(color: PageTheme.grey),
                )
              ],
            ),
          ),
        );

        listViews.add(Wrap(
            alignment: WrapAlignment.center,
            spacing: 2,
            children: List.generate(dataList!.length, (index) {
              //if (index == 0) return Container();
              //return Text(value['title'][index]);
              //print(value['title'][index]);
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 4, right: 4, bottom: 4),
                        child: ButtonSquareView(
                          mainText: (dataList[index]['pageMechanismType'] ==
                              'educationLevel')
                              ? '${dataList[index]['displayLevel']}'
                              : '${dataList[index]['wordLevel']}',
                          subTextBottomRight: (dataList[index]
                          ['pageMechanismType'] ==
                              'educationLevel')
                              ? 'Rank \n${dataList[index]['minWordRank']}~${dataList[index]['maxWordRank']}'
                              : '單字量${dataList[index]['wordCount']}',
                          subTextBottomLeft: (dataList[index]
                          ['pageMechanismType'] ==
                              'educationLevel')
                              ? ''
                              : '${dataList[index]['displayLevel']}',
                          onTapFunction: () {
                            AutoRouter.of(context).push(
                                VocabularyPracticeWordListRoute(
                                    rangeMin: (dataList[index]
                                    ['pageMechanismType'] ==
                                        'proficiencyTestLevel')
                                        ? 1
                                        : dataList[index]['minWordRank'],
                                    rangeMax: (dataList[index]
                                    ['pageMechanismType'] ==
                                        'proficiencyTestLevel')
                                        ? dataList[index]['wordCount']
                                        : dataList[index]['maxWordRank'],
                                    displayLevel: dataList[index]
                                    ['displayLevel'],
                                    cateType: dataList[index]
                                    ['pageMechanismType'],
                                    wordLevel: (dataList[index]
                                    ['pageMechanismType'] ==
                                        'proficiencyTestLevel')
                                        ? dataList[index]['wordLevel']
                                        : ''));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            })));
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
