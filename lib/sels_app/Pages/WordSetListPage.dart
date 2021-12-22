

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sels_app/sels_app/Pages/PhoneticExercisesLearnAutoPage.dart';
import 'package:sels_app/sels_app/Pages/WordSetLearnPage.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';
import 'package:sels_app/sels_app/Utils/SharedPreferencesUtil.dart';

class WordSetListPage extends StatefulWidget {

  String learningClassification = '';

  WordSetListPage({String learningClassification:''}) {
    this.learningClassification = learningClassification;
  }

  @override
  _WordSetListPage createState() => _WordSetListPage(learningClassification: learningClassification);
}

class _WordSetListPage extends State<WordSetListPage> {


  _WordSetListPage({String learningClassification:''}) {
    this._learningClassification = learningClassification;
  }

  String _learningClassification =  '';
  String _applicationSettingsDataUUID = '';
  Map<String, dynamic> _wordSetData = {
    'wordSetClassification': '',
    'learningClassificationName': '',
    'wordSetTotal': 1,
    'averageScore': 0,
    'wordSetArray': [],
  };

  var _allowTouchButtons = {
    'addWordSetButton' : true,
  };

  @override
  void initState() {
    super.initState();
    initWordSetListPage();
  }

  initWordSetListPage() async {
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
    try{
      var getWordSetList;
      Map<String, dynamic> wordSetData = {};
      // 獲取~5單字數的句子10句
      do {
        String getWordSetListJSON = await APIUtil.getWordSetList(_applicationSettingsDataUUID, _learningClassification);
        getWordSetList = jsonDecode(getWordSetListJSON.toString());
        print(getWordSetList);
        print('getWordSetList 2 apiStatus:' + getWordSetList['apiStatus'] + ' apiMessage:' + getWordSetList['apiMessage']);
        if(getWordSetList['apiStatus'] != 'success') {
          sleep(Duration(seconds:1));
        }
      } while (getWordSetList['apiStatus'] != 'success');
      wordSetData.addAll(getWordSetList['data']);


      setState(() {
        _wordSetData = wordSetData;
      });

      if(_wordSetData['wordSetArray'].length == 0){
        addWordSet();
      }
    } catch(e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('連線發生錯誤，請稍候再重試'),
      ));
    }
    EasyLoading.dismiss();


  }

  Future<void> addWordSet() async {

    setState(() {
      _allowTouchButtons['addWordSetButton'] = false;
    });
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try{
      var addWordSet;
      String addWordSetJSON = await APIUtil.addWordSet(_applicationSettingsDataUUID, _learningClassification);
      addWordSet = jsonDecode(addWordSetJSON.toString());
      if(addWordSet['apiStatus'] != 'success') {
        sleep(Duration(seconds:1));
      }
      if(addWordSet['apiStatus'] == 'success'){
        initWordSetList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Opps: ${addWordSet['apiMessage']}'),
        ));
      }
    } catch(e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('連線發生錯誤，請稍候再重試'),
      ));
    }
    EasyLoading.dismiss();
    setState(() {
      _allowTouchButtons['addWordSetButton'] = true;
    });

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
          title: Text('${_wordSetData['learningClassificationName']} 單字集' ),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
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
                                            if(_wordSetData['wordSetArray']!.length != _wordSetData['wordSetTotal']!){
                                              if(_allowTouchButtons['addWordSetButton']!){
                                                addWordSet();
                                              }

                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('Opps: 已超出本單字集上限'),
                                              ));
                                            }
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
                      flex: 2,
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
                                  itemExtent: 200,
                                  itemCount: _wordSetData['wordSetArray']!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Card(
                                        color: Colors.grey.shade400,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 7,
                                                child: Container(

                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.all(4),
                                                  child: ListTile(
                                                    title: Text('${_wordSetData['learningClassificationName']!} 第${_wordSetData['wordSetArray']![index]['wordSetPhase']}集'),
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
                                                            value: 'word_card_learn',
                                                            child: Text('單字卡學習'),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 'sentence_phonetic_auto',
                                                            child: Text('句子口說練習'),
                                                          ),
                                                          /*
                                                PopupMenuItem(
                                                  value: 'Review',
                                                  child: Text('複習'),
                                                ),
                                                PopupMenuItem(
                                                  value: 'Test',
                                                  child: Text('測驗'),
                                                ),

                                                 */
                                                        ];
                                                      },
                                                      onSelected: (String value){
                                                        switch(value) {
                                                          case 'word_card_learn':
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetLearnPage(learningClassification: _wordSetData['wordSetArray']![index]['wordSetClassification'].toString(), learningPhase: _wordSetData['wordSetArray']![index]['wordSetPhase'].toString())));
                                                            //print('You Click on po up menu item ' + value +_wordSetData['wordSetArray']![index]['wordSetClassification'].toString());
                                                            //print('You Click on po up menu item ' + value +_wordSetData['wordSetArray']![index]['wordSetPhase'].toString());
                                                            break;
                                                          case 'sentence_phonetic_auto':
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnAutoPage(
                                                                wordSet:{
                                                                  'learningClassification': _wordSetData['wordSetArray']![index]['wordSetClassification'].toString(),
                                                                  'learningPhase': _wordSetData['wordSetArray']![index]['wordSetPhase'].toString()
                                                                }
                                                            )));
                                                            //print('You Click on po up menu item ' + value +_wordSetData['wordSetArray']![index]['wordSetClassification'].toString());
                                                            //print('You Click on po up menu item ' + value +_wordSetData['wordSetArray']![index]['wordSetPhase'].toString());
                                                            break;
                                                          case 'Review':
                                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetReviewPage()));
                                                            print('You Click on po up menu item' + value);
                                                            break;
                                                          case 'Test':
                                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetLearnPage()));
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
                                              ),

                                              Divider(
                                                color: Colors.white,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  //color: Colors.red,
                                                  child: ListView.builder(
                                                      //itemExtent: 100,
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: _wordSetData['wordSetArray']![index]['wordList'].length,
                                                      itemBuilder: (context, index2) {
                                                        return Container(
                                                          padding: const EdgeInsets.all(4),
                                                          child: OutlinedButton(
                                                            style: OutlinedButton.styleFrom(
                                                              side: BorderSide(
                                                                color: Colors.white,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                            child: Text(
                                                                _wordSetData['wordSetArray']![index]['wordList'][index2],
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                      }),


                                                  /*
                                                OutlinedButton(

                                                  child: Text(_wordSetData['wordSetArray']![index]['wordList'][index2]),
                                                  onPressed: () {
                                                  },
                                                ),
                                                */
                                                ),
                                              ),

                                            ],
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