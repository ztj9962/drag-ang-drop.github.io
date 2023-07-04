import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MinimalPairWordIndexPage extends StatefulWidget {
  const MinimalPairWordIndexPage({Key? key}) : super(key: key);

  @override
  _MinimalPairWordIndexPageState createState() =>
      _MinimalPairWordIndexPageState();
}

class _MinimalPairWordIndexPageState extends State<MinimalPairWordIndexPage> {
  List<String> list = [];
  TextEditingController _searchWordController =
      TextEditingController(text: 'test');

  final _allowTouchButtons = {
    'reListenButton': false,
    'speakButton': false,
    'nextButton': true,
  };

  List<String> _leftWord = [];
  List<String> _leftIPA = [];
  List<String> _rightWord = [];
  List<String> _rightIPA = [];

  @override
  void initState() {
    super.initState();
    getMinimalPairWord('test');
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
            '相似單字練習',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        //padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onSubmitted: (value) async {},
                          controller: _searchWordController,
                          decoration: const InputDecoration(
                              labelText: "搜尋單詞",
                              hintText: "搜尋單詞",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  PageTheme.cutom_article_practice_background)
                        ],
                      ),
                      child: TextButton(
                        child: Text(
                          '開始搜尋',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          getMinimalPairWord(_searchWordController.text);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(4)),
              Divider(
                thickness: 1,
                color: PageTheme.syllable_search_background,
              ),
              Container(
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
                      _searchWordController.text,
                      style: TextStyle(
                        color: PageTheme.app_theme_blue,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                    ),
                    Visibility(
                        visible: _leftWord.length == 0,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: AutoSizeText(
                            '沒有這個單字的對應資料',
                            style: TextStyle(
                              color: PageTheme.app_theme_blue,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                          ),
                        )),
                    Container(
                        child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _leftWord.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  '${_leftWord[index]}, ${_rightWord[index]}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '[${_leftIPA[index]}, ${_rightIPA[index]}]',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: PageTheme.syllable_search_background,
                            ),
                          ],
                        );
                      },
                    )),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: PageTheme.app_theme_blue,
                              radius: 25.0,
                              child: IconButton(
                                icon: const Icon(Icons.play_arrow),
                                color: (_allowTouchButtons['nextButton']!)
                                    ? Colors.white
                                    : Colors.grey,
                                onPressed: () {
                                  if (_leftWord.length != 0) {
                                    AutoRouter.of(context).push(
                                        LearningManualMinimalPairRoute(
                                            word: _searchWordController.text));
                                  }
                                },
                              ),
                            ),
                          ),
                          const AutoSizeText(
                            '開始練習',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> getMinimalPairWord(String word) async {
    List<String> leftWord = [];
    List<String> leftIPA = [];
    List<String> rightWord = [];
    List<String> rightIPA = [];

    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var minimalPairWordFinder;
    do {
      String minimalPairWordFinderJSON =
          await APIUtil.minimalPairWordFinder(word, dataLimit: '10');
      minimalPairWordFinder = jsonDecode(minimalPairWordFinderJSON.toString());
      if (minimalPairWordFinder['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (minimalPairWordFinder['apiStatus'] != 'success');

    EasyLoading.dismiss();
    minimalPairWordFinder['data'].forEach((value) {
      leftWord.add(value["leftWord"]);
      leftIPA.add(value["leftIPA"]);
      rightWord.add(value["rightWord"]);
      rightIPA.add(value["rightIPA"]);
    });

    setState(() {
      _leftWord = leftWord;
      _leftIPA = leftIPA;
      _rightWord = rightWord;
      _rightIPA = rightIPA;
    });
  }
}
