import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MinimalPairIndexPage extends StatefulWidget {
  const MinimalPairIndexPage({Key? key}) : super(key: key);

  @override
  _MinimalPairIndexPageState createState() => _MinimalPairIndexPageState();
}

class _MinimalPairIndexPageState extends State<MinimalPairIndexPage> {
  List<String> list = [];

  Map<String, List<String>> _IPAMap = {'': []};
  List<String>? _IPA1List = [];
  List<String>? _IPA2List = [];

  List<Map> _minimalPairPractice = [];

  String? _dropdownValue1 = 'aɪ';
  String? _dropdownValue2;
  int _selected = -1;

  Map _mapTemplate = {
    'leftWord': '',
    'leftIPA': '',
    'rightWord': '',
    'rightIPA': '',
  };

  @override
  void initState() {
    super.initState();
    initMinimalPairIndexPage();
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
            '相似字音練習',
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
              Padding(
                padding: const EdgeInsets.all(2),
                child: Text("練習的IPA",
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
                    '   請選擇第一個字元',
                    style: TextStyle(color: PageTheme.app_theme_blue),
                    maxLines: 1,
                  ),
                  items:
                      _IPA1List?.map<DropdownMenuItem<String>>((String value) {
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
                      _dropdownValue2 = null;
                      _IPA2List = _IPAMap[_dropdownValue1];
                      _selected = -1;

                      _minimalPairPractice = [];
                      _IPA2List!.forEach((value) {
                        _minimalPairPractice.add(_mapTemplate);
                      });
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
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    itemCount: _IPA2List?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: PageTheme.app_theme_blue),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              '${_dropdownValue1}, ${_IPA2List![index]}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: PageTheme
                                                      .app_theme_blue)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Column(
                                    children: <Widget>[
                                      Divider(
                                        thickness: 2,
                                        color: PageTheme
                                            .syllable_search_background,
                                      ),
                                      Flex(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _minimalPairPractice[
                                                              index]["leftWord"]
                                                          ?.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index2) {
                                                    return Flex(
                                                      direction:
                                                          Axis.horizontal,
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              '${_minimalPairPractice[index]["leftWord"][index2]}, ${_minimalPairPractice[index]["rightWord"][index2]}',
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            )),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            '[${_minimalPairPractice[index]["leftIPA"][index2]}, ${_minimalPairPractice[index]["rightIPA"][index2]}]',
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                          child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  PageTheme.app_theme_blue,
                                              radius: 25.0,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  AutoRouter.of(context).push(
                                                      LearningManualMinimalPairRoute(
                                                          IPA1:
                                                              _dropdownValue1!,
                                                          IPA2: _IPA2List![
                                                              index]));
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
                                      ))
                                    ],
                                  ),
                                ),
                              ],
                              onExpansionChanged: (bool expanded) {
                                if (expanded) {
                                  setState(() {
                                    getMinimalPairWord(
                                        _dropdownValue1!,
                                        _IPA2List![index],
                                        _minimalPairPractice,
                                        index);
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
                    }),
              ),
            ],
          ),
        ));
  }

  initMinimalPairIndexPage() async {
    await initIPAList();
  }

  Future<void> initIPAList() async {
    Map<String, List<String>> IPAMap = {};
    List<String> IPA1List = [];

    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var getIPAAvailable;
    do {
      String getIPAAvailableJSON = await APIUtil.getIPAAvailable();
      getIPAAvailable = jsonDecode(getIPAAvailableJSON.toString());
      if (getIPAAvailable['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (getIPAAvailable['apiStatus'] != 'success');

    EasyLoading.dismiss();
    getIPAAvailable['data'].forEach((value) {
      IPAMap.addAll({value["IPA1"]: new List<String>.from(value["IPA2"])});
      IPA1List.add(value["IPA1"]);
    });
    setState(() {
      _IPAMap = IPAMap;
      _IPA1List = IPA1List;
      _IPA2List = _IPAMap[_dropdownValue1];
      _IPA2List!.forEach((value) {
        _minimalPairPractice.add(_mapTemplate);
      });
    });
  }

  Future<void> getMinimalPairWord(
      String IPA1, String IPA2, List practiceData, int index) async {
    List<String> leftWord = [];
    List<String> leftIPA = [];
    List<String> rightWord = [];
    List<String> rightIPA = [];

    if (practiceData[index]['leftWord'] == '') {
      EasyLoading.show(status: '正在讀取資料，請稍候......');
      var minimalPairTwoFinder;
      do {
        String minimalPairTwoFinderJSON =
            await APIUtil.minimalPairTwoFinder(IPA1, IPA2, dataLimit: '10');
        minimalPairTwoFinder = jsonDecode(minimalPairTwoFinderJSON.toString());
        if (minimalPairTwoFinder['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (minimalPairTwoFinder['apiStatus'] != 'success');

      EasyLoading.dismiss();
      minimalPairTwoFinder['data'].forEach((value) {
        leftWord.add(value["leftWord"]);
        leftIPA.add(value["leftIPA"]);
        rightWord.add(value["rightWord"]);
        rightIPA.add(value["rightIPA"]);
      });

      setState(() {
        _minimalPairPractice[index] = {
          'leftWord': leftWord,
          'leftIPA': leftIPA,
          'rightWord': rightWord,
          'rightIPA': rightIPA,
        };
      });
    } else {
      setState(() {});
    }
  }
}
