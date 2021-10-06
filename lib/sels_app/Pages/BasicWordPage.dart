

import 'package:flutter/material.dart';
import 'package:sels_app/main.dart';
import 'package:sels_app/sels_app/OtherViews/mediterranean_diet_view.dart';
import 'package:sels_app/sels_app/Pages/BasicWordLearnPage.dart';
import 'package:sels_app/sels_app/Pages/BasicWordReviewPage.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';

class BasicWordPage extends StatefulWidget {
  @override
  _BasicWordPage createState() => _BasicWordPage();
}

class _BasicWordPage extends State<BasicWordPage> {

  List<String> _ipaAboutList = ['2021/08/02 Animals 單字集','2021/08/02 Culture 單字集','33','44','55','66','77','88','99', '101'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  int animationController = 100;
  int animation = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Empty' ),
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
                                  itemCount: _ipaAboutList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(4),
                                      child: Card(

                                        child: ListTile(
                                          title: Text('${_ipaAboutList[index]}'),
                                          leading: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CircularProgressIndicator(
                                                    backgroundColor: Colors.grey[200],
                                                    valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                                    value: 70/100,
                                                  ),
                                                ),
                                                Text(
                                                    '70%'
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
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BasicWordLearnPage()));
                                                  print('You Click on po up menu item' + value);
                                                  break;
                                                case 'Review':
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BasicWordReviewPage()));
                                                  print('You Click on po up menu item' + value);
                                                  break;
                                                case 'Test':
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BasicWordLearnPage()));
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