import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sels_app/sels_app/Pages/PhoneticExercisesPage.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';
import 'package:sels_app/sels_app/Utils/SharedPreferencesUtil.dart';

class PhoneticExercisesHistoryPage extends StatefulWidget {
  @override
  _PhoneticExercisesHistoryPage createState() => _PhoneticExercisesHistoryPage();
}

class _PhoneticExercisesHistoryPage extends State<PhoneticExercisesHistoryPage> {

  String _applicationSettingsDataUUID = '';
  List _quizHistoryData = [];
  List<String> _ipaAboutList = ['2021/08/02 Animals 單字集','2021/08/02 Culture 單字集','33','44','55','66','77','88','99', '101'];

  @override
  void initState() {
    super.initState();
    initPhoneticExercisesHistoryPage();
  }
  initPhoneticExercisesHistoryPage() async {
    await initApplicationSettingsData();
    await initQuizHistory();
  }

  initApplicationSettingsData() {
    SharedPreferencesUtil.getData<String>('applicationSettingsDataUUID').then((value) {
      setState(() => _applicationSettingsDataUUID = value!);
    });
  }


  Future<void> initQuizHistory() async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var getQuizHistory;
    var quizHistoryData = [];
    // 獲取~5單字數的句子10句
    do {
      String getQuizHistoryJSON = await APIUtil.getQuizHistory(_applicationSettingsDataUUID);
      getQuizHistory = jsonDecode(getQuizHistoryJSON.toString());
      print('getQuizHistory 1 apiStatus:' + getQuizHistory['apiStatus'] + ' apiMessage:' + getQuizHistory['apiMessage']);
      if(getQuizHistory['apiStatus'] != 'success') {
        sleep(Duration(seconds:1));
      }
    } while (getQuizHistory['apiStatus'] != 'success');
    quizHistoryData.addAll(getQuizHistory['data']);

    EasyLoading.dismiss();

    setState(() {
      _quizHistoryData = quizHistoryData;
    });

    print(_quizHistoryData);
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
          title: Text('已儲存的紀錄' ),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    /*
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
                                                    value: 70/100,
                                                  ),
                                                ),
                                                Text('98分')
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
                                                    value: 70/100,
                                                  ),
                                                ),
                                                Text('13/310')
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
                    */

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
                                  itemCount: _quizHistoryData.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Card(

                                        child: ListTile(
                                          title: Text('${_quizHistoryData[index]['quizTitle']}/${_quizHistoryData[index]['quizUpdatedAt']}'),
                                          leading: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CircularProgressIndicator(
                                                    backgroundColor: Colors.grey[200],
                                                    valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                                    value: _quizHistoryData[index]['quizAverageScore']/100,
                                                  ),
                                                ),
                                                Text(
                                                    '${_quizHistoryData[index]['quizAverageScore']}%'
                                                )
                                              ],
                                          ),
                                          trailing: PopupMenuButton(
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  value: 'Auto',
                                                  child: Text('自動'),
                                                ),
                                                /*
                                                PopupMenuItem(
                                                  value: 'Maunal',
                                                  child: Text('手動'),
                                                ),

                                                 */
                                              ];
                                            },
                                            onSelected: (String value){
                                              switch(value) {
                                                case 'Auto':
                                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesHistoryLearnPage()));
                                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesPage(sentencesIDData: _quizHistoryData[index]['quizSentenceIDArray'].cast<int>() )));
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesPage(quizID:_quizHistoryData[index]['quizID'] )));
                                                  print('You Click on po up menu item' + value);
                                                  break;
                                                case 'Maunal':
                                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesHistoryReviewPage()));
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