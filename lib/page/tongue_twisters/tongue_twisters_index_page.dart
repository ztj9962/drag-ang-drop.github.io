import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TongueTwistersIndexPage extends StatefulWidget {
  const TongueTwistersIndexPage({Key? key}) : super(key: key);

  @override
  _TongueTwistersIndexPage createState() => _TongueTwistersIndexPage();
}

class _TongueTwistersIndexPage extends State<TongueTwistersIndexPage> {
  List<String> _sessionList = [
    'TT1',
    'TT2',
    'TT3',
    'TT4',
    'TT5',
    'TT6',
    'TT7',
    'TT8',
    'TT9'
  ];
  String _session = 'TT1';
  int _testIndex = 0;
  List<Map> _sessionSentenceData = [];

  final _allowTouchButtons = {
    'reListenButton': false,
    'speakButton': false,
    'nextButton': true,
  };

  @override
  void initState() {
    super.initState();
    initTongueTwistersIndexPage();
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
            '英語繞口令練習',
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Padding(
              padding: const EdgeInsets.all(2),
              child: Text("Tongue Twisters Session 選擇",
                  style: TextStyle(
                      color: PageTheme.app_theme_blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(color: PageTheme.app_theme_blue),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton(
                value: _session,
                //style: TextStyle(fontSize: 20),
                isExpanded: true,
                iconSize: 40,
                hint: AutoSizeText(
                  '   選擇要練習的Session',
                  style: TextStyle(color: PageTheme.app_theme_blue),
                  maxLines: 1,
                ),
                items:
                    _sessionList?.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: AutoSizeText(
                      '   ${value}',
                      style: TextStyle(color: PageTheme.app_theme_blue),
                      maxLines: 1,
                    ),
                  );
                }).toList(),

                onChanged: (String? value) {
                  setState(() {
                    _session = value!;
                    _testIndex = _sessionList
                        .indexWhere((note) => note.startsWith(value!));
                    initGetTongueTwistersSentenceList(value, _testIndex);
                  });
                },
                underline: Container(
                  height: 0,
                ),
              ),
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
                    'Session' + _session,
                    style: TextStyle(
                      color: PageTheme.app_theme_blue,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                  ),
                  Container(
                      child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        _sessionSentenceData[_testIndex]['sentence']?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.all(10)),
                              Text((index + 1).toString() + '.',
                                  style: TextStyle(fontSize: 16)),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Flexible(
                                  child: Text(
                                _sessionSentenceData[_testIndex]['sentence']
                                    [index],
                                style: TextStyle(fontSize: 16),
                              )),
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
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Visibility(
                            visible: _testIndex != 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    backgroundColor: PageTheme.app_theme_blue,
                                    radius: 25.0,
                                    child: IconButton(
                                      icon: const Icon(
                                          Icons.navigate_before_outlined),
                                      color: (_allowTouchButtons['nextButton']!)
                                          ? Colors.white
                                          : Colors.grey,
                                      onPressed: () {
                                        if (_allowTouchButtons['nextButton']!) {
                                          setState(() {
                                            _testIndex -= 1;
                                            _session = _sessionList[_testIndex];
                                          });
                                          initGetTongueTwistersSentenceList(
                                              _session, _testIndex);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const AutoSizeText(
                                  '上一Session',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 1,
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
                                    AutoRouter.of(context)
                                        .push(LearningManualTongueTwistersRoute(
                                      sentence: _sessionSentenceData[_testIndex]
                                          ['sentence'],
                                      sentenceIPA:
                                          _sessionSentenceData[_testIndex]
                                              ['sentenceIPA'],
                                      sentenceChinese:
                                      _sessionSentenceData[_testIndex]
                                      ['sentenceChinese'],
                                    ));
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
                      ),
                      Expanded(
                          flex: 1,
                          child: Visibility(
                            visible:
                                _testIndex < _sessionSentenceData.length - 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    backgroundColor: PageTheme.app_theme_blue,
                                    radius: 25.0,
                                    child: IconButton(
                                      icon: const Icon(
                                          Icons.navigate_next_outlined),
                                      color: (_allowTouchButtons['nextButton']!)
                                          ? Colors.white
                                          : Colors.grey,
                                      onPressed: () {
                                        if (_allowTouchButtons['nextButton']!) {
                                          setState(() {
                                            _testIndex += 1;
                                            _session = _sessionList[_testIndex];
                                          });
                                          initGetTongueTwistersSentenceList(
                                              _session, _testIndex);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const AutoSizeText(
                                  '下一Session',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ));
  }

  initTongueTwistersIndexPage() async {
    await initTongueTwisersNumList();
  }

  Future<void> initTongueTwisersNumList() async {
    Map mapTemplate = {
      'session': '',
      'sentence': ['', '', '', '', '', ''],
      'sentenceChinese': ['', '', '', '', '', ''],
    };

    for (var i = 0; i < _sessionList.length; i++) {
      _sessionSentenceData.add(mapTemplate);
    }
    initGetTongueTwistersSentenceList(_session, _testIndex);
  }

  Future<void> initGetTongueTwistersSentenceList(
      String session, int index) async {
    List<String> getSession = [];
    List<String> getSentence = [];
    List<String> getSentenceIPA = [];
    List<String> getSentenceChinese = [];

    if (_sessionSentenceData[index]['session'] == '') {
      EasyLoading.show(status: '正在讀取資料，請稍候......');
      var getTongueTwistersSentence;
      do {
        String getTongueTwistersSentenceJSON =
            await APIUtil.getTongueTwistersSentence(session);
        getTongueTwistersSentence =
            jsonDecode(getTongueTwistersSentenceJSON.toString());
        if (getTongueTwistersSentence['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getTongueTwistersSentence['apiStatus'] != 'success');

      EasyLoading.dismiss();
      getTongueTwistersSentence['data'].forEach((value) {
        getSession.add(value["session"]);
        getSentence.add(value["sentence"].toString());
        getSentenceIPA.add(value["sentenceIPA"].toString());
        getSentenceChinese.add(value["sentenceChinese"].toString());
      });

      setState(() {
        _sessionSentenceData[index] = {
          'session': getSession,
          'sentence': getSentence,
          'sentenceIPA': getSentenceIPA,
          'sentenceChinese': getSentenceChinese,
        };
      });
    } else {
      setState(() {});
    }
  }
}
