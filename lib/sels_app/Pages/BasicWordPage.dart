

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sels_app/main.dart';
import 'package:sels_app/sels_app/OtherViews/mediterranean_diet_view.dart';
import 'package:sels_app/sels_app/Pages/BasicWordLearnPage.dart';
import 'package:sels_app/sels_app/Pages/BasicWordReviewPage.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';
import 'package:sels_app/sels_app/Utils/SharedPreferencesUtil.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';

class BasicWordPage extends StatefulWidget {

  String learningDegree = '';

  BasicWordPage({String learningDegree:''}) {
    this.learningDegree = learningDegree;
  }

  @override
  _BasicWordPage createState() => _BasicWordPage(learningDegree: learningDegree);
}

class _BasicWordPage extends State<BasicWordPage> {


  _BasicWordPage({String learningDegree:''}) {
    this._learningDegree = learningDegree;
  }

  String _learningDegree =  '';
  String _applicationSettingsDataUUID = '';
  Map<dynamic, dynamic> _wordSetData = {
    'wordSetDegree': 'Basic',
    'wordSetTotal': 1,
    'averageScore': 0,
    'wordSetArray': [],
  };
  List<String> _ipaAboutList = ['2021/08/02 Animals 單字集','2021/08/02 Culture 單字集','33','44','55','66','77','88','99', '101'];

  @override
  void initState() {
    super.initState();
    initBasicWordPage();
  }

  initBasicWordPage() async {
    await initApplicationSettingsData();
    await initWordSetList();
  }

  initApplicationSettingsData() {
    SharedPreferencesUtil.getData<String>('applicationSettingsDataUUID').then((value) {
      setState(() => _applicationSettingsDataUUID = value!);
    });
  }


  Future<void> initWordSetList() async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var getWordSetList;
    Map<dynamic, dynamic> wordSetData = {};
    // 獲取~5單字數的句子10句
    do {
      String getWordSetListJSON = await APIUtil.getWordSetList(_applicationSettingsDataUUID, _learningDegree);
      getWordSetList = jsonDecode(getWordSetListJSON.toString());
      print('getWordSetList 2 apiStatus:' + getWordSetList['apiStatus'] + ' apiMessage:' + getWordSetList['apiMessage']);
      if(getWordSetList['apiStatus'] != 'success') {
        sleep(Duration(seconds:1));
      }
    } while (getWordSetList['apiStatus'] != 'success');
    wordSetData.addAll(getWordSetList['data']);

    EasyLoading.dismiss();

    setState(() {
      _wordSetData = wordSetData;
    });

    print(_wordSetData);
  }

  Future<void> addWordSet() async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var addWordSet;
    String addWordSetJSON = await APIUtil.addWordSet(_applicationSettingsDataUUID, _learningDegree);
    addWordSet = jsonDecode(addWordSetJSON.toString());
    //print('addWordSet 1 apiStatus:' + addWordSet['apiStatus'] + ' apiMessage:' + addWordSet['apiMessage']);
    print(_applicationSettingsDataUUID);
    if(addWordSet['apiStatus'] != 'success') {
      sleep(Duration(seconds:1));
    }

    EasyLoading.dismiss();

    if(addWordSet['apiStatus'] == 'success'){
      initWordSetList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opps: ${addWordSet['apiMessage']}'),
      ));
    }


  }


  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
  int animationController = 100;
  int animation = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${_learningDegree} 單字集' ),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 4,
                      child: Container(
                        //color: Colors.pink,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(0.0),
                            elevation: 2.0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[

                                  Text('歡迎回來，您目前的進度還不錯喔'),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 8,
                                                    backgroundColor: Colors.grey[200],
                                                    valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                                    value: _wordSetData['averageScore']!/100,
                                                  ),
                                                ),
                                                Text('${_wordSetData['averageScore']!}分')
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Text('平均測驗分數'),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 8,
                                                    backgroundColor: Colors.grey[200],
                                                    valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                                    value: _wordSetData['wordSetArray']!.length/_wordSetData['wordSetTotal']!,
                                                  ),
                                                ),
                                                Text('${_wordSetData['wordSetArray']!.length}/${_wordSetData['wordSetTotal']!}')
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Text('單字集學習進度'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Divider(
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: OutlinedButton(
                                          child: Text('獲取新單字集'),
                                          onPressed: () {
                                            addWordSet();
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: OutlinedButton(
                                          child: Text('隨機複習'),
                                          onPressed: () {

                                          },
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),


                        ),


















                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Container(
                        //color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(0.0),
                            elevation: 2.0,
                            child: Container(
                              child: ListView.builder(
                                  itemExtent: 80,
                                  itemCount: _wordSetData['wordSetArray']!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Card(

                                        child: ListTile(
                                          title: Text('${_wordSetData['wordSetArray']![index]['wordSetDegree']} 第${_wordSetData['wordSetArray']![index]['wordSetPhase']}集 / ${_wordSetData['wordSetArray']![index]['wordSetTitle']}'),
                                          leading: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CircularProgressIndicator(
                                                    backgroundColor: Colors.grey[200],
                                                    valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                                    value: _wordSetData['wordSetArray']![index]['wordSetScore']/100,
                                                  ),
                                                ),
                                                Text(
                                                    '${_wordSetData['wordSetArray']![index]['wordSetScore']}%'
                                                )
                                              ],
                                          ),
                                          trailing: PopupMenuButton(
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  value: 'Learn',
                                                  child: Text('學習'),
                                                ),
                                                PopupMenuItem(
                                                  value: 'Review',
                                                  child: Text('複習'),
                                                ),
                                                PopupMenuItem(
                                                  value: 'Test',
                                                  child: Text('測驗'),
                                                ),
                                              ];
                                            },
                                            onSelected: (String value){
                                              switch(value) {
                                                case 'Learn':
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BasicWordLearnPage(learningDegree: _wordSetData['wordSetArray']![index]['wordSetDegree'], learningPhase: _wordSetData['wordSetArray']![index]['wordSetPhase'].toString())));
                                                  print('You Click on po up menu item' + value +_wordSetData['wordSetArray']![index]['wordSetDegree'].toString());
                                                  break;
                                                case 'Review':
                                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => BasicWordReviewPage()));
                                                  print('You Click on po up menu item' + value);
                                                  break;
                                                case 'Test':
                                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => BasicWordLearnPage()));
                                                  print('You Click on po up menu item' + value);
                                                  break;
                                                default:
                                                  print('You Click on po up menu item' + value);
                                                break;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
              Visibility(
                visible: false,
                child: Stack(
                    children: <Widget>[
                      Dismissible(
                          key: ValueKey('GrammarCheckPage_Introduce_03'),
                          onDismissed: (DismissDirection direction){
                            //setState(() => _applicationSettingsGrammarCheckPageIntroduce = false);
                            //SharedPreferencesUtil.saveData<bool>('applicationSettingsGrammarCheckPageIntroduce', _applicationSettingsGrammarCheckPageIntroduce);
                            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //  content: Text('讓我們開始吧！'),
                            //));
                          },
                          child: ConstrainedBox(
                            child: Image.asset(
                              'assets/sels_app/GrammarCheckPage/GrammarCheckPage_Introduce_03.png',
                              fit: BoxFit.fill,
                            ),
                            constraints: new BoxConstraints.expand(),
                          )
                      ),
                      Dismissible(
                          key: ValueKey('GrammarCheckPage_Introduce_02'),
                          child: ConstrainedBox(
                            child: Image.asset(
                              'assets/sels_app/GrammarCheckPage/GrammarCheckPage_Introduce_02.png',
                              fit: BoxFit.fill,
                            ),
                            constraints: new BoxConstraints.expand(),
                          )
                      ),
                      Dismissible(
                          key: ValueKey('GrammarCheckPage_Introduce_01'),
                          child: ConstrainedBox(
                            child: Image.asset(
                              'assets/sels_app/GrammarCheckPage/GrammarCheckPage_Introduce_01.png',
                              fit: BoxFit.fill,
                            ),
                            constraints: new BoxConstraints.expand(),
                          )
                      ),
                    ]
                ),

              ),

            ]
        )
    );
  }

}