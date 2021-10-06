

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:sels_app/main.dart';
import 'package:sels_app/sels_app/OtherViews/mediterranean_diet_view.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';

class BasicWordLearnPage extends StatefulWidget {
  @override
  _BasicWordLearnPage createState() => _BasicWordLearnPage();
}

class _BasicWordLearnPage extends State<BasicWordLearnPage> {

  List<String> _ipaAboutList = ['我要不要帶點東西參加派對\nShall I bring anything to the party?','This is a sentance on here.','This is a sentance la.'];

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
          title: Text('learn page' ),
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
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(0.0),
                            elevation: 2.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 32, right: 32,top: 16,bottom: 16),
                                  child: Column(
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: 'bring',
                                          style: TextStyle(
                                            fontSize: 40 ,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Divider(
                                          height: 1,
                                          thickness: 1,
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: '[br-ing]\n[brɪŋ]',
                                          style: TextStyle(
                                            fontSize: 16 ,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Divider(
                                          height: 1,
                                          thickness: 1,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: 'A1級\n[v.] 帶來',
                                            style: TextStyle(
                                              fontSize: 16 ,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    color: Colors.grey,
                                    iconSize: 25,
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () async {
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    color: Colors.grey,
                                    iconSize: 25,
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () async {
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Container(
                        //color: Colors.green,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                            Card(
                              color: Colors.white,
                                margin: EdgeInsets.all(0.0),
                                elevation: 2.0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: SELSAppTheme.white,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Explanation 解釋: ',
                                        style: TextStyle(
                                          fontSize: 16 ,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      Text(
                                        'Come to lace with (someone or something)',
                                        style: TextStyle(
                                          fontSize: 20 ,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                              Card(
                                color: Colors.white,
                                margin: EdgeInsets.all(0.0),
                                elevation: 2.0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Sentance 句子練習: ',
                                              style: TextStyle(
                                                fontSize: 16 ,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            IconButton(
                                              color: Colors.grey,
                                              iconSize: 25,
                                              icon: Icon(Icons.refresh_outlined),
                                              onPressed: () {
                                                print('refresh_outlined');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      Divider(
                                        height: 1,
                                        thickness: 1,
                                      ),
                                      Container(
                                        child: ListView.builder(
                                            physics: new NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemExtent: 120,
                                            itemCount: _ipaAboutList.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                child: Card(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 9,
                                                        child: Column(
                                                          children: <Widget>[
                                                            ListTile(
                                                              title: Text('${_ipaAboutList[index]}'),
                                                            ),
                                                          ],
                                                        ),


                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Center(
                                                              child: AvatarGlow(
                                                                animate: true,
                                                                glowColor: Theme.of(context).primaryColor,
                                                                endRadius: 30.0,
                                                                duration: Duration(milliseconds: 2000),
                                                                repeat: true,
                                                                showTwoGlows: true,
                                                                repeatPauseDuration: Duration(milliseconds: 100),
                                                                child: Material(     // Replace this child with your own
                                                                  elevation: 8.0,
                                                                  shape: CircleBorder(),
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Theme.of(context).primaryColor,
                                                                    radius: 20.0,
                                                                    child: IconButton(
                                                                      iconSize: 15,
                                                                      icon: Icon(Icons.volume_off_outlined ),
                                                                      color: Colors.white,
                                                                      onPressed: () async {
                                                                        print('SSS');
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Center(
                                                                  child: AvatarGlow(
                                                                    animate: true,
                                                                    glowColor: Theme.of(context).primaryColor,
                                                                    endRadius: 30.0,
                                                                    duration: Duration(milliseconds: 2000),
                                                                    repeat: true,
                                                                    showTwoGlows: true,
                                                                    repeatPauseDuration: Duration(milliseconds: 100),
                                                                    child: Material(     // Replace this child with your own
                                                                      elevation: 8.0,
                                                                      shape: CircleBorder(),
                                                                      child: CircleAvatar(
                                                                        backgroundColor: Theme.of(context).primaryColor,
                                                                        radius: 20.0,
                                                                        child: IconButton(
                                                                          iconSize: 15,
                                                                          icon: Icon(Icons.mic ),
                                                                          color: Colors.white,
                                                                          onPressed: () async {
                                                                            print('SSS');
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                            ),

                                                          ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              );
                                            },

                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                              Card(
                                color: Colors.white,
                                margin: EdgeInsets.all(0.0),
                                elevation: 2.0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text('XX'),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),




                      /*
                      Container(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: SELSAppTheme.white,
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Divider(
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ),

                                ],
                            ),
                          ),

                          /*
                          Card(
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
                                                  value: '開始學習',
                                                  child: Text('開始學習'),
                                                ),
                                                PopupMenuItem(
                                                  value: '複習',
                                                  child: Text('複習'),
                                                ),
                                                PopupMenuItem(
                                                  value: '測驗',
                                                  child: Text('測驗'),
                                                ),
                                              ];
                                            },
                                            onSelected: (String value){
                                              print('You Click on po up menu item' + value);
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            )
                          ),*/
                        ),
                      ),

                       */
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