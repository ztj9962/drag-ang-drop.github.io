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

class VocabularyMatchUpIndexPage extends StatefulWidget {
  const VocabularyMatchUpIndexPage({Key? key}) : super(key: key);

  @override
  _VocabularyMatchUpIndexPageState createState() =>
      _VocabularyMatchUpIndexPageState();
}

class _VocabularyMatchUpIndexPageState
    extends State<VocabularyMatchUpIndexPage> {
  List<Widget> _listViews = <Widget>[];

  bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    initVocabularyMatchUpIndexPage();
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

  initVocabularyMatchUpIndexPage() async {
    List<Widget> listViews = <Widget>[];
    List<String> mainStringList = [
      '簡單',
      '中等',
      '困難',
    ];
    List<String> subStringList = [
      'Rank 1~1000',
      'Rank 1000~3000',
      'Rank 3000~10000',
    ];

    listViews.add(
      Container(
        width: double.infinity,
        child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 2,
            children: List.generate(3, (index) {
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
                        mainText: mainStringList[index],
                        subTextBottomRight: '',
                        subTextBottomLeft: subStringList[index],
                        onTapFunction: () {
                          AutoRouter.of(context).push(
                              VocabularyMatchUpPracticeRoute(minRank: 1, maxRank: 1000
                               ));
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
    );

    setState(() {
      _listViews = listViews;
    });
  }
}
