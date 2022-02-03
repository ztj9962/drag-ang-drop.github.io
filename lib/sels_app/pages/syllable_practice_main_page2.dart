

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:sels_app/sels_app/pages/syllable_practice_learn_page.dart';
import 'package:sels_app/sels_app/pages/syllable_practice_word_page.dart';

class SyllablePracticeMainPage extends StatefulWidget {
  @override
  _SyllablePracticeMainPage createState() => _SyllablePracticeMainPage();
}

class _SyllablePracticeMainPage extends State<SyllablePracticeMainPage> with TickerProviderStateMixin {
  final List<String> _ipaAboutList = [
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

  final searchWordController = TextEditingController();
  late TabController _tabController;


  final List<bool> isSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    searchWordController.dispose();
    super.dispose();
  }
  int animationController = 100;
  int animation = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //title: Text('相似字音節訓練' ),
          title: const Text('Minimal Pair'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'Use Syllable'),
              Tab(text: 'Use Word')
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30, top: 30),
                  ),
                  const Text('請選擇第一個字元'),
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
                  const Text("請選擇第二個字元"),
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
                  const Text("請選擇第三個字元"),
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
                  const Divider(
                    height: 20,
                    thickness: 2,
                    indent: 80,
                    endIndent: 80,
                  ),
                  const Text("選擇訓練要呈現的格式"),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: _radioSelect,
                          onChanged: _getRadioSelectValue,
                        ),
                        const Text("顯示1組"),
                        Radio(
                          value: 3,
                          groupValue: _radioSelect,
                          onChanged: _getRadioSelectValue,
                        ),
                        const Text("顯示3組"),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
                  ),
                  Container(
                    child: ElevatedButton(
                      child: const Text('開始練習相似字音節訓練'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shadowColor: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        )
                      ),
                      onPressed: (){
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
                      },
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30, top: 30),
                  ),
                  Container(
                    width: 250,
                    child: TextField(
                      decoration: const InputDecoration(
                        //border: OutlineInputBorder(),  //有框的 TextField
                        labelText: '尋找相似的單詞',
                        hintText: '請輸入要尋找相似的單詞',
                      ),
                      controller: searchWordController,
                    ),
                  ),
                  /*
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
                  ),
                  const Text("選擇訓練要呈現的格式"),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: _radioSelect,
                          onChanged: _getRadioSelectValue,
                        ),
                        const Text("顯示1組"),
                        Radio(
                          value: 3,
                          groupValue: _radioSelect,
                          onChanged: _getRadioSelectValue,
                        ),
                        const Text("顯示3組"),
                      ],
                    ),
                  ),
                  */
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30, top: 30),
                  ),
                  Container(
                    child: ElevatedButton(
                      child: const Text('開始尋找單詞相似字'),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shadowColor: Colors.black,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SyllablePracticeWordPage(searchWordController.text)));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        /*
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
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8, top: 8),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    const Text('請選擇第一個字元'),
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
                                    const Text("請選擇第二個字元"),
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
                                    const Text("請選擇第三個字元"),
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
                                    const Divider(
                                      height: 20,
                                      thickness: 1,
                                    ),
                                    const Text("選擇訓練要呈現的格式"),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Radio(
                                            value: 1,
                                            groupValue: _radioSelect,
                                            onChanged: _getRadioSelectValue,
                                          ),
                                          const Text("顯示1組"),
                                          Radio(
                                            value: 3,
                                            groupValue: _radioSelect,
                                            onChanged: _getRadioSelectValue,
                                          ),
                                          const Text("顯示3組"),
                                        ],
                                      ),
                                    ),
                                  ]
                              )
                          )
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8, top: 8),
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
                              margin: const EdgeInsets.all(0.0),
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
                                  },
                                  child: const Center(
                                    child: Text('開始練習相似字音節訓練'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
                            child: Container(
                              margin: const EdgeInsets.all(0.0),
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
                                    List<String> selectSyllableWordList = [];

                                    selectSyllableWordList.add(searchWordController.text);

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SyllablePracticeWordPage()));
                                    //Navigator.pop(context);
                                  },
                                  child: const Center(
                                    //child: Icon(Icons.save),
                                    child: Text('開始尋找單詞相似字'),
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
                          key: const ValueKey('GrammarCheckPage_Introduce_03'),
                          onDismissed: (DismissDirection direction){
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
                          key: const ValueKey('GrammarCheckPage_Introduce_02'),
                          child: ConstrainedBox(
                            child: Image.asset(
                              'assets/sels_app/GrammarCheckPage/GrammarCheckPage_Introduce_02.png',
                              fit: BoxFit.fill,
                            ),
                            constraints: new BoxConstraints.expand(),
                          )
                      ),
                      Dismissible(
                          key: const ValueKey('GrammarCheckPage_Introduce_01'),
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
        */
    );
  }

  void _getRadioSelectValue(int? value){
    setState(() {
      _radioSelect = value!;
    });
  }
}