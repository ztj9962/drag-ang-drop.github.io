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

  List<String> list=[];
  bool _switchSearch = true;
  TextEditingController _searchWordController = TextEditingController();


  Map<String, List<String>> _IPAMap = {'':[]};
  List<String>? _IPA1List = [];
  List<String>? _IPA2List = [];
  //List<List<dynamic>> _IPA2List = [];

  String? _dropdownValue1;
  String? _dropdownValue2;

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
          title: Column(
            children: <Widget>[
              AutoSizeText(
                'Pronunciation - Minimal pairs',
                maxLines: 1,
              ),
              AutoSizeText(
                '相似字音練習',
                maxLines: 1,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(15)),
                if (_switchSearch)...[
                  Container(
                    width: 350,
                    child: ElevatedButton(
                      child: const AutoSizeText(
                        '切換為相似字節模式',
                        style: TextStyle(fontSize: 20),
                        maxLines: 1,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: PageTheme.app_theme_blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shadowColor: Colors.black,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {
                        setState(() {
                          _switchSearch = !_switchSearch;
                        });
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(15)),
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: PageTheme.app_theme_blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton(
                      value: _dropdownValue1,
                      //style: TextStyle(fontSize: 20),
                      isExpanded: true,
                      iconSize: 40,
                      hint: AutoSizeText(
                        '   請選擇第一個字元',
                        style:
                        TextStyle(color: PageTheme.app_theme_blue),
                        maxLines: 1,
                      ),
                      items: _IPA1List?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: AutoSizeText(
                            '   ${value}',
                            style:
                            TextStyle(color: PageTheme.app_theme_blue),
                            maxLines: 1,
                          ),
                        );
                      }).toList(),

                      onChanged: (String? value){
                        setState(() {
                          _dropdownValue1 = value!;
                          _dropdownValue2 = null;
                          _IPA2List = _IPAMap[_dropdownValue1];

                        });
                      },
                      underline: Container(
                        height: 0,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: PageTheme.app_theme_blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton(
                      value: _dropdownValue2,
                      //style: TextStyle(fontSize: 20),
                      isExpanded: true,
                      iconSize: 40,
                      hint: AutoSizeText(
                        '   請選擇第二個字元',
                        style:
                        TextStyle(color: PageTheme.app_theme_blue),
                        maxLines: 1,
                      ),
                      items: _IPA2List?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: AutoSizeText(
                            '   ${value}',
                            style:
                            TextStyle(color: PageTheme.app_theme_blue),
                            maxLines: 1,
                          ),
                        );
                      }).toList(),

                      onChanged: (String? value){
                        setState(() {
                          _dropdownValue2 = value!;
                        });
                      },
                      underline: Container(
                        height: 0,
                      ),
                    ),
                  ),
                ] else...[

                  Container(
                    width: 350,
                    child: ElevatedButton(
                      child: const AutoSizeText(
                        '切換為相似音標模式',
                        style: TextStyle(fontSize: 20),
                        maxLines: 1,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: PageTheme.app_theme_blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shadowColor: Colors.black,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {
                        setState(() {
                          _switchSearch = !_switchSearch;
                        });
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(15)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onSubmitted: (value) async {
                      },
                      controller: _searchWordController,
                      decoration: const InputDecoration(
                          labelText: "搜尋單詞",
                          hintText: "搜尋單詞",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0))
                          )
                      ),
                    ),
                  ),
                ],
                Padding(padding: EdgeInsets.all(20)),
                Divider(
                  thickness: 1,
                  color: PageTheme.syllable_search_background,
                ),
                Padding(padding: EdgeInsets.all(15)),
                Container(
                  width: 350,
                  child: ElevatedButton(
                      child: const AutoSizeText(
                        '手動模式',
                        maxLines: 1,
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: PageTheme.app_theme_blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shadowColor: Colors.black,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {
                        if (_switchSearch) {
                          if (_dropdownValue1 == null || _dropdownValue2 == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('請記得要輸入喔'),
                            ));
                          } else {
                            //print(_dropdownValue1);
                            //print(_dropdownValue2);
                            AutoRouter.of(context).push(MinimalPairLearnManualRoute(IPA1:_dropdownValue1!, IPA2:_dropdownValue2!));
                          }
                        } else {
                          if (_searchWordController.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('請記得要輸入喔'),
                            ));
                          } else {
                            //print(_searchWordController.text);
                            AutoRouter.of(context).push(MinimalPairLearnManualRoute(word:_searchWordController.text));
                          }
                        }
                      }),
                ),
                Padding(padding: EdgeInsets.all(15)),
                Container(
                  width: 350,
                  child: ElevatedButton(
                    child: const AutoSizeText(
                      '自動模式',
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: PageTheme.app_theme_blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shadowColor: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {
                      if (_switchSearch) {
                        if (_dropdownValue1 == null || _dropdownValue2 == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('請記得要輸入喔'),
                          ));
                        } else {
                          //print(_dropdownValue1);
                          //print(_dropdownValue2);
                          AutoRouter.of(context).push(MinimalPairLearnAutoRoute(IPA1:_dropdownValue1!, IPA2:_dropdownValue2!));
                        }
                      } else {
                        if (_searchWordController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('請記得要輸入喔'),
                          ));
                        } else {
                          //print(_searchWordController.text);
                          AutoRouter.of(context).push(MinimalPairLearnAutoRoute(word:_searchWordController.text));
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        )



    );
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
    });
  }

}