

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:sels_app/sels_app/pages/syllable_practice_learn_page.dart';

class SyllablePracticeMainPage extends StatefulWidget {
  @override
  _SyllablePracticeMainPage createState() => _SyllablePracticeMainPage();
}

class _SyllablePracticeMainPage extends State<SyllablePracticeMainPage> {
  /*
  List<String> _ipaAboutList = [
    'i', 'ɪ', 'ʊ', 'u', 'e', 'ə', 'ɜ', 'ɔ', 'æ', 'ʌ', 'ɑ', 'ɒ',
    'ɪə', 'eɪ', 'ʊə', 'ɔɪ', 'əʊ', 'eə', 'aɪ', 'aʊ',
    'aʊə', 'aɪə', 'eɪə', 'əʊə', 'ɔɪə',
    'p', 'b', 't', 'd', 'ʧ', 'ʤ', 'k', 'g', 'f', 'v', 'θ', 'ð', 's', 'z', 'ʃ', 'ʒ', 'm', 'n', 'ŋ', 'h', 'l', 'r', 'w', 'j'
  ];

   */

  List<String> _ipaAboutList = [
    '請選擇',
    'i', 'ɪ', 'ʊ', 'u', 'e', 'ə', 'ɜ', 'ɔ', 'æ', 'ɑ',
    'eɪ', 'ɔɪ', 'əʊ', 'aɪ', 'aʊ',
    'aʊə', 'aɪə', 'eɪə', 'əʊə', 'ɔɪə',
    'p', 'b', 't', 'd', 'ʧ', 'ʤ', 'k', 'g', 'f', 'v', 'θ', 'ð', 's', 'z', 'ʃ', 'ʒ', 'm', 'n', 'ŋ', 'h', 'l', 'r', 'w', 'j'
  ];

  String _dropdownValue1 = 'i';
  String _dropdownValue2 = 'ɔ';
  String _dropdownValue3 = '請選擇';

  int _radioSelect = 1;



  final List<bool> isSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

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
          title: Text('相似字音節訓練' ),
        ),
        body: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 10,
                      child: SingleChildScrollView(
                        child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8, top: 8),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                              /*
                              Text('Vowels'),
                              Container(
                                  height: 200,
                                  child: GridView.count(
                                    physics: const NeverScrollableScrollPhysics(),
                                    //scrollDirection: Axis.horizontal,
                                    crossAxisCount: 5 ,
                                    children: List.generate(10,(index){
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8, top: 8),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                              Text('Diphthongs'),
                              Container(
                                  height: 100,
                                  child: GridView.count(
                                    physics: const NeverScrollableScrollPhysics(),
                                    //scrollDirection: Axis.horizontal,
                                    crossAxisCount: 5 ,
                                    children: List.generate(5,(index){
                                      return Container(
                                        //color: isSelected[index] ? Colors.blue : null,
                                        padding: const EdgeInsets.all(4),
                                        child: Card(
                                          shape: StadiumBorder(
                                            side: BorderSide(
                                              color: isSelected[index + 10] ? Colors.blue : Colors.transparent,
                                              //width: 2.0,
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Center(
                                                child: Text('${_ipaAboutList[index + 10 ]}')
                                            ),
                                            selected: isSelected[index + 12],
                                            onTap: () {
                                              setState(() {
                                                if( (isSelected.where((item) => item == true).length >= 3) && !(isSelected[index + 10]) ){
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text('最多只能選3個'),
                                                  ));
                                                } else {
                                                  isSelected[index + 10] = !isSelected[index + 10];
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      );

                                    }),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8, top: 8),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                              Text('Triphthong'),
                               Container(
                                  height: 100,
                                  child: GridView.count(
                                    physics: const NeverScrollableScrollPhysics(),
                                    //scrollDirection: Axis.horizontal,
                                    crossAxisCount: 5 ,
                                    children: List.generate(5,(index){
                                      return Container(
                                        //color: isSelected[index] ? Colors.blue : null,
                                        padding: const EdgeInsets.all(4),
                                        child: Card(
                                          shape: StadiumBorder(
                                            side: BorderSide(
                                              color: isSelected[index + 15] ? Colors.blue : Colors.transparent,
                                              //width: 2.0,
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Center(
                                                child: Text('${_ipaAboutList[index + 15 ]}')
                                            ),
                                            selected: isSelected[index + 15],
                                            onTap: () {
                                              setState(() {
                                                if( (isSelected.where((item) => item == true).length >= 3) && !(isSelected[index + 15]) ){
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text('最多只能選3個'),
                                                  ));
                                                } else {
                                                  isSelected[index + 15] = !isSelected[index + 15];
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      );

                                    }),
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
                              Container(
                                  height: 500,
                                  child: GridView.count(
                                    physics: const NeverScrollableScrollPhysics(),
                                    //scrollDirection: Axis.horizontal,
                                    crossAxisCount: 5 ,
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
                               */
                              Text('請選擇第一個字元'),
                              Container(
                                child: DropdownButton(
                                  value: _dropdownValue1,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.blue),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  onChanged: (String? value){
                                    setState(() {
                                      _dropdownValue1 = value!;
                                    });
                                  },
                                  items: _ipaAboutList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Text("請選擇第二個字元"),
                              Container(
                                child: DropdownButton(
                                  value: _dropdownValue2,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.blue),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  onChanged: (String? value){
                                    setState(() {
                                      _dropdownValue2 = value!;
                                    });
                                  },
                                  items: _ipaAboutList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Text("請選擇第三個字元"),
                              Container(
                                child: DropdownButton(
                                  value: _dropdownValue3,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.blue),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  onChanged: (String? value){
                                    setState(() {
                                      _dropdownValue3 = value!;
                                    });
                                  },
                                  items: _ipaAboutList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              //Padding(padding: const EdgeInsets.only(bottom: 8, top: 8)),
                              Divider(
                                height: 20,
                                thickness: 1,
                              ),
                              Text("選擇訓練要呈現的格式"),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Radio(
                                        value: 1,
                                        groupValue: _radioSelect,
                                        onChanged: _getRadioSelectValue,
                                        /*
                                        onChanged: (int? value){
                                          setState(() {
                                            _radioSelect = value!;
                                          });
                                        }
                                         */
                                    ),
                                    Text("顯示1組"),
                                    Radio(
                                        value: 3,
                                        groupValue: _radioSelect,
                                        onChanged: _getRadioSelectValue,
                                        /*
                                        onChanged: (int? value){
                                          setState(() {
                                            _radioSelect = value!;
                                          });
                                        }
                                        */
                                    ),
                                    Text("顯示3組"),
                                  ],
                                ),
                              ),
                            ]
                        )
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    /*
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
                     */
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

                                  selectSyllableList.add(_dropdownValue1);
                                  selectSyllableList.add(_dropdownValue2);
                                  if (_dropdownValue3 != '請選擇'){
                                    selectSyllableList.add(_dropdownValue3);
                                  }

                                  while(selectSyllableList.length < 3){
                                    selectSyllableList.add('');
                                  }

                                  selectSyllableList.add(_radioSelect.toString());

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SyllablePracticeLearnPage(selectSyllableList)));
                                  print(selectSyllableList);
                                  //Navigator.pop(context);
                                },
                                child: Center(
                                  //child: Icon(Icons.save),
                                  child: Text('開始練習相似字音節訓練'),
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

  void _getRadioSelectValue(int? value){
    setState(() {
      _radioSelect = value!;
    });
  }
}