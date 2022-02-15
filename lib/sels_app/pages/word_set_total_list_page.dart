

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sels_app/sels_app/pages/phonetic_exercises_learn_auto_page.dart';
import 'package:sels_app/sels_app/pages/word_set_learn_page.dart';
import 'package:sels_app/sels_app/utils/api_util.dart';
import 'package:sels_app/sels_app/utils/shared_preferences_util.dart';

class WordSetTotalListPage extends StatefulWidget {

  String learningClassification = '';

  WordSetTotalListPage({String learningClassification:''}) {
    this.learningClassification = learningClassification;
  }

  @override
  _WordSetTotalListPage createState() => _WordSetTotalListPage(learningClassification: learningClassification);
}

class _WordSetTotalListPage extends State<WordSetTotalListPage> {


  _WordSetTotalListPage({String learningClassification:''}) {
    this._learningClassification = learningClassification;
  }


  int _sliderMin = 1;
  int _sliderMax = 10;
  int _sliderIndex = 2;

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
    initWordSetTotalListPage();
  }

  initWordSetTotalListPage() async {
    await initApplicationSettingsData();
    await initWordSetTotalList();
  }

  initApplicationSettingsData() {
    SharedPreferencesUtil.getData<String>('applicationSettingsDataUUID').then((value) {
      setState(() => _applicationSettingsDataUUID = value!);
    });
  }


  Future<void> initWordSetTotalList() async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try{
      var getWordSetTotalList;
      Map<String, dynamic> wordSetData = {};
      // 獲取~5單字數的句子10句
      do {
        String getWordSetTotalListJSON = await APIUtil.getWordSetTotalList(_sliderIndex.toString());
        getWordSetTotalList = jsonDecode(getWordSetTotalListJSON.toString());
        print(getWordSetTotalList);
        print('getWordSetTotalList 2 apiStatus:' + getWordSetTotalList['apiStatus'] + ' apiMessage:' + getWordSetTotalList['apiMessage']);
        if(getWordSetTotalList['apiStatus'] != 'success') {
          sleep(Duration(seconds:1));
        }
      } while (getWordSetTotalList['apiStatus'] != 'success');
      wordSetData.addAll(getWordSetTotalList['data']);


      setState(() {
        _wordSetData = wordSetData;
        _sliderMax = wordSetData['wordSetTotal'];
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
        initWordSetTotalList();
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
                                    Slider(
                                      autofocus: false,
                                      onChanged: (value) {
                                        setState(() => _sliderIndex = value.toInt());
                                      },
                                      onChangeEnd: (value) {
                                        setState(() => _sliderIndex = value.toInt());
                                        print(value);
                                        initWordSetTotalList();
                                      },
                                      min: _sliderMin.toDouble(),
                                      max: _sliderMax.toDouble(),
                                      activeColor: Colors.lightBlueAccent,
                                      divisions: (_sliderMax - _sliderMin),
                                      //value: _applicationSettingsDataTtsRate,
                                      value: _sliderIndex.toDouble(),
                                      label: 'Ranking ${_sliderIndex * 10 - 9} ~ ${_sliderIndex * 10}',
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: OutlinedButton(
                                            child: Text('-100'),
                                            onPressed: () {
                                              _adjustSliderIndex(-10);
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: OutlinedButton(
                                            child: Text('-10'),
                                            onPressed: () {
                                              _adjustSliderIndex(-1);
                                            },
                                          ),
                                        ),
                                        /*
                                      Flexible(
                                        flex: 1,
                                        child: TextField(
                                          controller: TextEditingController()..text='${_sliderIndex}',
                                        ),
                                      ),
                                       */
                                        Flexible(
                                          flex: 1,
                                          child: Text(
                                              'Ranking ${_sliderIndex * 10 - 9} ~ ${_sliderIndex * 10}'
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: OutlinedButton(
                                            child: Text('+10'),
                                            onPressed: () {
                                              _adjustSliderIndex(1);
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: OutlinedButton(
                                            child: Text('+100'),
                                            onPressed: () {
                                              _adjustSliderIndex(10);
                                            },
                                          ),
                                        ),

                                      ],
                                    ),
                                    /*
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
                                  */

                                  ],
                                ),
                              ),
                            ),


                          ),


















                        ),
                      ),
                      Flexible(
                        flex: 4,
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
                                      itemCount: _wordSetData['wordSetArray']!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          //height: 300,
                                          padding: const EdgeInsets.all(4),
                                          child: Card(
                                            color: Colors.grey.shade400,
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.all(4),
                                                  child: ListTile(
                                                    title: Text('${_wordSetData['learningClassificationName']!} \n第${_wordSetData['wordSetArray']![index]['wordSetPhase']}集\nRanking ${_wordSetData['wordSetArray']![index]['wordSetPhase'] *10 -9 } ~ ${_wordSetData['wordSetArray']![index]['wordSetPhase'] *10 }'),
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
                                                Divider(
                                                  color: Colors.white,
                                                ),
                                                Wrap(
                                                  spacing: 2,
                                                  runSpacing: 5,
                                                  children: List.generate(_wordSetData['wordSetArray']![index]['wordList'].length, (index2) {
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
                                                ),

                                              ],
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

  /*
  other
   */

  void _adjustSliderIndex(int value) {

    int sliderIndex = _sliderIndex + value;

    if( (sliderIndex >= _sliderMin) && (sliderIndex <= _sliderMax) ){
      setState(() => _sliderIndex = sliderIndex);
      initWordSetTotalList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opps: 已超出範圍'),
      ));
    }

  }

}