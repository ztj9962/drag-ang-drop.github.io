

import 'package:flutter/material.dart';
import 'package:sels_app/main.dart';
import 'package:sels_app/sels_app/OtherViews/mediterranean_diet_view.dart';
import 'package:sels_app/sels_app/Pages/BasicWordLearnPage.dart';
import 'package:sels_app/sels_app/Pages/BasicWordReviewPage.dart';
import 'package:sels_app/sels_app/Pages/SyllablePracticeLearnPage.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';

class SyllablePracticeMainPage extends StatefulWidget {
  @override
  _SyllablePracticeMainPage createState() => _SyllablePracticeMainPage();
}

class _SyllablePracticeMainPage extends State<SyllablePracticeMainPage> {

  List<String> _ipaAboutList = [
    'i:', 'ɪ', 'ʊ', 'u:', 'e', 'ə', 'ɜ:', 'ɔ:', 'æ', 'ʌ', 'ɑ:', 'ɒ',
    'ɪə', 'eɪ', 'ʊə', 'ɔɪ', 'əʊ', 'eə', 'aɪ', 'aʊ',
    'p', 'b', 't', 'd', 'ʧ', 'ʤ', 'k', 'g', 'f', 'v', 'θ', 'ð', 's', 'z', 'ʃ', 'ʒ', 'm', 'n', 'ŋ', 'h', 'l', 'r', 'w', 'j'
  ];





  final List<bool> isSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

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
                      flex: 10,
                      child:Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 8),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                            Text('Vowels'),
                            Flexible(
                              flex: 5,
                              child: Container(
                                height: 200,
                                child: GridView.count(
                                  //scrollDirection: Axis.horizontal,
                                  crossAxisCount: 4 ,
                                  children: List.generate(12,(index){
                                    return Container(
                                      //color: isSelected[index] ? Colors.blue : null,
                                      padding: const EdgeInsets.all(4),
                                      child: Card(
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                            color: isSelected[index] ? Colors.blue : Colors.transparent,
                                            //width: 2.0,
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Center(
                                              child: Text('${_ipaAboutList[index]}')
                                          ),
                                          selected: isSelected[index],
                                          onTap: () {
                                            setState(() {
                                              if( (isSelected.where((item) => item == true).length >= 3) && !(isSelected[index]) ){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('最多只能選3個'),
                                                ));
                                              } else {
                                                isSelected[index] = !isSelected[index];
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );

                                  }),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 8),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                            Text('Diphthongs'),
                            Flexible(
                              flex: 4,
                              child: Container(
                                height: 200,
                                child: GridView.count(
                                  //scrollDirection: Axis.horizontal,
                                  crossAxisCount: 4 ,
                                  children: List.generate(7,(index){
                                    return Container(
                                      //color: isSelected[index] ? Colors.blue : null,
                                      padding: const EdgeInsets.all(4),
                                      child: Card(
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                            color: isSelected[index + 12] ? Colors.blue : Colors.transparent,
                                            //width: 2.0,
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Center(
                                              child: Text('${_ipaAboutList[index + 12 ]}')
                                          ),
                                          selected: isSelected[index + 12],
                                          onTap: () {
                                            setState(() {
                                              if( (isSelected.where((item) => item == true).length >= 3) && !(isSelected[index + 12]) ){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('最多只能選3個'),
                                                ));
                                              } else {
                                                isSelected[index + 12] = !isSelected[index + 12];
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );

                                  }),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 8),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                            Text('Consonants'),
                            Flexible(
                              flex: 4,
                              child: Container(
                                height: 200,
                                child: GridView.count(
                                  //scrollDirection: Axis.horizontal,
                                  crossAxisCount: 4 ,
                                  children: List.generate(24,(index){
                                    return Container(
                                      //color: isSelected[index] ? Colors.blue : null,
                                      padding: const EdgeInsets.all(4),
                                      child: Card(
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                            color: isSelected[index + 20] ? Colors.blue : Colors.transparent,
                                            //width: 2.0,
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Center(
                                              child: Text('${_ipaAboutList[index + 20 ]}')
                                          ),
                                          selected: isSelected[index + 20],
                                          onTap: () {
                                            setState(() {
                                              if( (isSelected.where((item) => item == true).length >= 3) && !(isSelected[index + 20]) ){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('最多只能選3個'),
                                                ));
                                              } else {
                                                isSelected[index + 20] = !isSelected[index + 20];
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );

                                  }),
                                ),
                              ),
                            ),
                          ]
                      )
                    ),

                    /*
                    Flexible(
                      flex: 9,
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
                                      //color: isSelected[index] ? Colors.blue : null,
                                      padding: const EdgeInsets.all(4),
                                      child: Card(
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                            color: isSelected[index] ? Colors.blue : Colors.transparent,
                                            //width: 2.0,
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text('${_ipaAboutList[index]}'),
                                          selected: isSelected[index],
                                          onTap: () {
                                            setState(() {
                                              if( (isSelected.where((item) => item == true).length >= 3) && !(isSelected[index]) ){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('最多只能選3個'),
                                                ));
                                              } else {
                                                isSelected[index] = !isSelected[index];
                                              }
                                            });
                                          },
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

                     */

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        //color: Colors.pink,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
                          child: Container(
                              margin: EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.6),
                                    blurRadius: 8,
                                    offset: const Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                  highlightColor: Colors.transparent,
                                  onTap: () {

                                    /*
                              SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsVolume', _applicationSettingsDataTtsVolume);
                              SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsPitch', _applicationSettingsDataTtsPitch);
                              SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsRate', _applicationSettingsDataTtsRate);
                              SharedPreferencesUtil.saveData<String>('applicationSettingsDataListenAndSpeakLevel', _applicationSettingsDataListenAndSpeakLevel);
                              SharedPreferencesUtil.saveData<double>('applicationSettingsDataListenAndSpeakRanking', _applicationSettingsDataListenAndSpeakRanking);
                              SharedPreferencesUtil.saveData<bool>('applicationSettingsSELSAppHomePageIntroduce', _applicationSettingsSELSAppHomePageIntroduce);
                              SharedPreferencesUtil.saveData<bool>('applicationSettingsPhoneticExercisesNewPageIntroduce', _applicationSettingsPhoneticExercisesNewPageIntroduce);
                              SharedPreferencesUtil.saveData<bool>('applicationSettingsGrammarCheckPageIntroduce', _applicationSettingsGrammarCheckPageIntroduce);

                               */

                                    List<String> selectSyllableList = [];
                                    isSelected.asMap().forEach((index, value) {
                                      if(value){
                                        selectSyllableList.add(_ipaAboutList[index]);
                                      }
                                    });

                                    while(selectSyllableList.length < 3){
                                      selectSyllableList.add('');
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Save successflully. ${selectSyllableList}'),
                                    ));

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SyllablePracticeLearnPage(selectSyllableList)));
                                    //Navigator.pop(context);
                                  },
                                  child: Center(
                                    //child: Icon(Icons.save),
                                    child: Text('開始，已選擇${isSelected.where((item) => item == true).length}/3'),
                                  ),
                                ),
                              ),
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