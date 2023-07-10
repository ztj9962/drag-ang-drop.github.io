import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HarvardIndexPage extends StatefulWidget {
  const HarvardIndexPage({Key? key}) : super(key: key);

  @override
  _HarvardIndexPage createState() => _HarvardIndexPage();
}

class _HarvardIndexPage extends State<HarvardIndexPage> {
  int _sessionNum = 1;
  List<String> _sessionNumList = [];
  List<Map> _sessionSentenceData = [];

  final _allowTouchButtons = {
    'reListenButton': false,
    'speakButton': false,
    'nextButton': true,
  };

  @override
  void initState() {
    super.initState();
    initAddSessionNum();
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
            'Harvard句子練習',
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2),
                child: Text("Session 選擇",
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
                  value: _sessionNum.toString(),
                  //style: TextStyle(fontSize: 20),
                  isExpanded: true,
                  iconSize: 40,
                  hint: AutoSizeText(
                    '   選擇要練習的Session',
                    style: TextStyle(color: PageTheme.app_theme_blue),
                    maxLines: 1,
                  ),
                  items: _sessionNumList
                      ?.map<DropdownMenuItem<String>>((String value) {
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
                      _sessionNum = int.parse(value!);
                      initGetHarvardSentenceList(value, _sessionNum - 1);
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
                      'Session' + _sessionNum.toString(),
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
                      itemCount: _sessionSentenceData[_sessionNum - 1]
                              ['sentence']
                          ?.length,
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
                                    _sessionSentenceData[_sessionNum - 1]
                                        ['sentence'][index],
                                    style: TextStyle(fontSize: 16),
                                  ),
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
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Visibility(
                              visible: _sessionNum != 1,
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
                                        color:
                                            (_allowTouchButtons['nextButton']!)
                                                ? Colors.white
                                                : Colors.grey,
                                        onPressed: () {
                                          if (_allowTouchButtons[
                                              'nextButton']!) {
                                            setState(() {
                                              _sessionNum -= 1;
                                            });
                                            initGetHarvardSentenceList(
                                                _sessionNum.toString(),
                                                _sessionNum - 1);
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
                                          .push(LearningManualHarvardRoute(
                                        sentence: _sessionSentenceData[
                                            _sessionNum - 1]['sentence'],
                                        sentenceIPA: _sessionSentenceData[
                                            _sessionNum - 1]['sentenceIPA'],
                                        sentenceChinese: _sessionSentenceData[
                                        _sessionNum - 1]['sentenceChinese'],
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
                                  _sessionNum < _sessionSentenceData.length,
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
                                        color:
                                            (_allowTouchButtons['nextButton']!)
                                                ? Colors.white
                                                : Colors.grey,
                                        onPressed: () {
                                          if (_allowTouchButtons[
                                              'nextButton']!) {
                                            setState(() {
                                              _sessionNum += 1;
                                            });
                                            initGetHarvardSentenceList(
                                                _sessionNum.toString(),
                                                _sessionNum - 1);
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
            ],
          ),
        ));
  }

  initAddSessionNum() async {
    await initSessionNumList();
  }

  Future<void> initSessionNumList() async {
    Map mapTemplate = {
      'session': '',
      'sentence': ['', '', '', '', '', '', '', '', '', ''],
      'sentenceIPA': '',
      'sentenceChinese': ['', '', '', '', '', '', '', '', '', ''],
    };

    for (var i = 1; i < 73; i++) {
      _sessionNumList.add(i.toString());
      _sessionSentenceData.add(mapTemplate);
    }

    initGetHarvardSentenceList(_sessionNum.toString(), _sessionNum - 1);
  }

  Future<void> initGetHarvardSentenceList(String sessionNum, int index) async {
    List<int> getSessionNum = [];
    List<String> getSentence = [];
    List<String> getSentenceIPA = [];
    List<String> getSentenceChinese = [];

    if (_sessionSentenceData[index]['session'] == '') {
      EasyLoading.show(status: '正在讀取資料，請稍候......');
      var getHarvardSentence;
      do {
        String getHarvardSentenceJSON =
            await APIUtil.getHarvardSentence(sessionNum);
        getHarvardSentence = jsonDecode(getHarvardSentenceJSON.toString());
        if (getHarvardSentence['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getHarvardSentence['apiStatus'] != 'success');

      EasyLoading.dismiss();
      getHarvardSentence['data'].forEach((value) {
        getSessionNum.add(value["session"]);
        getSentence.add(value["sentence"].toString());
        getSentenceIPA.add(value["sentenceIPA"].toString());
        getSentenceChinese.add(value["sentenceChinese"].toString());
      });

      setState(() {
        _sessionSentenceData[index] = {
          'sessionNum': getSessionNum,
          'sentence': getSentence,
          'sentenceIPA': getSentenceIPA,
          'sentenceChinese': getSentenceChinese,
        };
      });
    } else {
      setState(() {});
    }
    print(_sessionSentenceData);
  }
}
