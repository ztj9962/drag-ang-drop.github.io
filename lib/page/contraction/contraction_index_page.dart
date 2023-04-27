import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContractionIndexPage extends StatefulWidget {
  const ContractionIndexPage({Key? key}) : super(key: key);

  @override
  _ContractionIndexPage createState() => _ContractionIndexPage();
}

class _ContractionIndexPage extends State<ContractionIndexPage> {
  String? _dropdownValue1 = 'prefix';
  List<String> _wordConditionList = ['prefix', 'suffix'];
  List<String> _getWord = [];
  List<String> _getContraction = [];
  List<String> _getPairContraction = [];
  List<String> _getPairFullForm = [];
  List<String> _getPracticeContraction = [];
  List<String> _getPracticeContractionIPA = [];
  List<String> _getPracticeFullForm = [];
  List<String> _getPracticeSentence = [];
  List<String> _getPracticeSentenceIPA = [];
  int _selected = -1;

  @override
  void initState() {
    super.initState();
    initGetContractionList(_dropdownValue1!);
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
          '縮寫練習',
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
              child: Text("練習字首、字尾",
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
                value: _dropdownValue1,
                //style: TextStyle(fontSize: 20),
                isExpanded: true,
                iconSize: 40,
                hint: AutoSizeText(
                  '   請選擇練習字首、字尾',
                  style: TextStyle(color: PageTheme.app_theme_blue),
                  maxLines: 1,
                ),
                items: _wordConditionList?.map<DropdownMenuItem<String>>(
                        (String value) {
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
                    _dropdownValue1 = value!;
                    _selected = -1;
                    initGetContractionList(_dropdownValue1!);
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
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  key: Key('builder ${_selected.toString()}'),
                  padding: EdgeInsets.only(
                      top: 20,
                      bottom: 20
                  ),
                  itemCount: _getWord?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: PageTheme.app_theme_blue),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ExpansionTile(
                            key: Key(index.toString()),
                            initiallyExpanded: index == _selected,
                            title: Flex(
                              mainAxisAlignment: MainAxisAlignment.center,
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_getWord![index], style: TextStyle(fontSize: 20, color: PageTheme.app_theme_blue)),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('contraction: ', style: TextStyle(fontSize: 10, color: PageTheme.app_theme_blue),),
                                      Text(_getContraction![index].replaceAll('[', '').replaceAll(']', ''), style: TextStyle(fontSize: 14, color: PageTheme.app_theme_blue))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            children: <Widget>[
                              ListTile(
                                title: Column(
                                  children: <Widget>[
                                    Divider(
                                      thickness: 2,
                                      color: PageTheme.syllable_search_background,
                                    ),
                                    Flex(
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: _getPairContraction?.length,
                                                itemBuilder: (BuildContext context, int index){
                                                  return Flex(
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: <Widget>[
                                                                Padding(padding: EdgeInsets.all(10)),
                                                                Text(_getPairContraction![index], style: TextStyle(fontSize: 14),),
                                                              ],
                                                            ),
                                                          )
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(_getPairFullForm![index].replaceAll(',', ', '), style: TextStyle(fontSize: 14),),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: CircleAvatar(
                                            backgroundColor: PageTheme.app_theme_blue,
                                            radius: 25.0,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.navigate_next_outlined,
                                                color: Colors.white,
                                              ),
                                              onPressed: (){
                                                AutoRouter.of(context).push(
                                                    LearningManualContractionRoute(getContraction: _getPracticeContraction, getContractionIPA: _getPracticeContractionIPA, getFullForm: _getPracticeFullForm, getSentence: _getPracticeSentence, getSentenceIPA: _getPracticeSentenceIPA)
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onExpansionChanged: (bool expanded){
                              if (expanded){
                                setState(() {
                                  initGetContractionFullForm(_dropdownValue1!, _getWord![index]);
                                  _selected = index;
                                });
                              } else {
                                setState(() {
                                  _selected = -1;
                                });
                              }
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4)),
                      ],
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initGetContractionList(String wordCondition) async {
    List<String> getWord = [];
    List<String> getContraction = [];

    if (wordCondition == 'prefix'){
      wordCondition = 'word1';
    } else if (wordCondition == 'suffix'){
      wordCondition = 'word2';
    }

    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var getIPAGraphemePair;
    do {
      String getIPAGraphemePairJSON = await APIUtil.getContractionPair(wordCondition);
      getIPAGraphemePair = jsonDecode(getIPAGraphemePairJSON.toString());
      if (getIPAGraphemePair['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (getIPAGraphemePair['apiStatus'] != 'success');

    EasyLoading.dismiss();
    getIPAGraphemePair['data'].forEach((value) {
      getWord.add(value["word"]);
      getContraction.add(value["contraction"].toString());
    });

    print(getWord);
    print(getContraction);

    setState(() {
      _getWord = getWord;
      _getContraction = getContraction;
    });
  }

  Future<void> initGetContractionFullForm(String wordCondition, String word) async {
    List<String> getPairContraction = [];
    List<String> getPairFullForm = [];
    List<String> getPracticeContraction = [];
    List<String> getPracticeContractionIPA = [];
    List<String> getPracticeFullForm = [];
    List<String> getPracticeSentence = [];
    List<String> getPracticeSentenceIPA = [];

    if (wordCondition == 'prefix'){
      wordCondition = 'word1';
    } else if (wordCondition == 'suffix'){
      wordCondition = 'word2';
    }

    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var getIPAGraphemePair;
    do {
      String getIPAGraphemePairJSON = await APIUtil.getContractionFullForm(wordCondition, word);
      getIPAGraphemePair = jsonDecode(getIPAGraphemePairJSON.toString());
      if (getIPAGraphemePair['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (getIPAGraphemePair['apiStatus'] != 'success');

    //EasyLoading.dismiss();
    getIPAGraphemePair['data'].forEach((value) {
      getPairContraction.add(value["contraction"]);
      getPairFullForm.add(value["fullForm"]);
    });

    do {
      String getIPAGraphemePairJSON = await APIUtil.getContractionSentence(wordCondition, word);
      getIPAGraphemePair = jsonDecode(getIPAGraphemePairJSON.toString());
      if (getIPAGraphemePair['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (getIPAGraphemePair['apiStatus'] != 'success');

    EasyLoading.dismiss();
    getIPAGraphemePair['data'].forEach((value) {
      getPracticeContraction.add(value["contraction"]);
      getPracticeContractionIPA.add(value["contractionIPA"]);
      getPracticeFullForm.add(value["fullForm"]);
      getPracticeSentence.add(value["sentence"]);
      getPracticeSentenceIPA.add(value["sentenceIPA"]);
    });

    setState(() {
      _getPairContraction = getPairContraction;
      _getPairFullForm = getPairFullForm;
      _getPracticeContraction = getPracticeContraction;
      _getPracticeContractionIPA = getPracticeContractionIPA;
      _getPracticeFullForm = getPracticeFullForm;
      _getPracticeSentence = getPracticeSentence;
      _getPracticeSentenceIPA = getPracticeSentenceIPA;
    });
  }
}