
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';
import 'package:sels_app/sels_app/utils/SharedPreferencesUtil.dart';

const listenAndSpeakLevelData = [
  {
    "name":"A1(適合初學者)",
    "value":"A1"
  },{
    "name":"A2",
    "value":"A2"
  },
  {
    "name":"B1(適合一般大眾)",
    "value":"B1"
  },
  {
    "name":"B2",
    "value":"B2"
  },
  {
    "name":"C1(適合達人)",
    "value":"C1"
  },
  {
    "name":"C2",
    "value":"C2"
  }
];

const listenAndSpeakRankingCheckData = {
  "A1": [324, 1046, 3153, 6826, 7609, 9602, 10067, 10362],
  "A2": [1046, 3153, 6826, 7609, 9602, 10067, 10362],
  "B1": [3153, 6826, 7609, 9602, 10067, 10362],
  "B2": [6826, 7609, 9602, 10067, 10362],
  "C1": [7609, 9602, 10067, 10362],
  "C2": [9602, 10067, 10362],

};

const listenAndSpeakRankingData = {
  324: "Dolch (約 324 個單字)",
  1046: "Fry (約 1,046 個單字)",
  3153: "NGSL Basic (約 3,153 個單字)",
  6826: "Taiwan L6 (約 6,826 個單字)",
  7609: "CERF (約 7,609 個單字)",
  9602: "TOEFL (約 9,602 個單字)",
  10067: "TOEIC (約 10,067 個單字)",
  10362: "Business (約 10,362 個單字)",
};

const listenAndSpeakModeData = [
  {
    "name":"聽英說英",
    "value":"聽英說英"
  },{
    "name":"聽中說英",
    "value":"聽中說英"
  },
  {
    "name":"聽英說中",
    "value":"聽英說中"
  }
];


class ApplicationSettingsPage extends StatefulWidget {

  @override
  _ApplicationSettingsPageState createState() => _ApplicationSettingsPageState();
}

class _ApplicationSettingsPageState extends State<ApplicationSettingsPage> {

  double _applicationSettingsDataTtsVolume = 1.0;
  double _applicationSettingsDataTtsPitch = 1.0;
  double _applicationSettingsDataTtsRate = 1.0;
  String _applicationSettingsDataListenAndSpeakLevel = "A1";
  double _applicationSettingsDataListenAndSpeakRanking = 9602.0;

  bool _applicationSettingsSELSAppHomePageIntroduce = true;
  bool _applicationSettingsPhoneticExercisesNewPageIntroduce = true;
  bool _applicationSettingsGrammarCheckPageIntroduce = true;


  @override
  void initState() {
    //print( listenAndSpeakRankingData[_applicationSettingsDataListenAndSpeakLevel]!["data"] );
    //print(listenAndSpeakLevelData);
    try{

    }catch (e){

    }

    super.initState();
    _initApplicationSettingsData();
  }

  _initApplicationSettingsData() {
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsVolume').then((value) {
      setState(() => _applicationSettingsDataTtsVolume = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsPitch').then((value) {
      setState(() => _applicationSettingsDataTtsPitch = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsRate').then((value) {
      setState(() => _applicationSettingsDataTtsRate = value!);
    });
    SharedPreferencesUtil.getData<String>('applicationSettingsDataListenAndSpeakLevel').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakLevel = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataListenAndSpeakRanking').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakRanking = value!);
    });
    SharedPreferencesUtil.getData<bool>('applicationSettingsSELSAppHomePageIntroduce').then((value) {
      setState(() => _applicationSettingsSELSAppHomePageIntroduce = value!);
    });
    SharedPreferencesUtil.getData<bool>('applicationSettingsPhoneticExercisesNewPageIntroduce').then((value) {
      setState(() => _applicationSettingsPhoneticExercisesNewPageIntroduce = value!);
    });
    SharedPreferencesUtil.getData<bool>('applicationSettingsGrammarCheckPageIntroduce').then((value) {
      setState(() => _applicationSettingsGrammarCheckPageIntroduce = value!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text('應用設定'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey, offset: Offset(1.1, 1.1), blurRadius: 10.0),
              ],
            ),
            child: Container(
              child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 11,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              listenAndSpeakSettings(),
                              Divider(
                                height: 1,
                              ),
                              ttsSettings(),
                              Divider(
                                height: 1,
                              ),
                              pageIntroduceSettings(),
                              Divider(
                                height: 1,
                              ),
                              smartAssistantSettings(),
                            ],
                          ),
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
                    Flexible(
                      flex: 1,
                      child: Container(
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
                              SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsVolume', _applicationSettingsDataTtsVolume);
                              SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsPitch', _applicationSettingsDataTtsPitch);
                              SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsRate', _applicationSettingsDataTtsRate);
                              SharedPreferencesUtil.saveData<String>('applicationSettingsDataListenAndSpeakLevel', _applicationSettingsDataListenAndSpeakLevel);
                              SharedPreferencesUtil.saveData<double>('applicationSettingsDataListenAndSpeakRanking', _applicationSettingsDataListenAndSpeakRanking);
                              SharedPreferencesUtil.saveData<bool>('applicationSettingsSELSAppHomePageIntroduce', _applicationSettingsSELSAppHomePageIntroduce);
                              SharedPreferencesUtil.saveData<bool>('applicationSettingsPhoneticExercisesNewPageIntroduce', _applicationSettingsPhoneticExercisesNewPageIntroduce);
                              SharedPreferencesUtil.saveData<bool>('applicationSettingsGrammarCheckPageIntroduce', _applicationSettingsGrammarCheckPageIntroduce);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Save successflully.'),
                              ));
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Icon(Icons.save),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ),
    );


    /*
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _listenAndSpeakSettings(),
                _ttsSettings(),
              ]
            ),
          ),
        ),
      */
  }

  Widget listenAndSpeakSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text('訓練設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Text(
          '訓練難度等級 Diffuiculty level',
          style: TextStyle(color: Colors.grey),
        ),
        DropdownButton(
          value: _applicationSettingsDataListenAndSpeakLevel,
          items: listenAndSpeakLevelData.map<DropdownMenuItem<String>>((data) {
            return DropdownMenuItem<String>(
              value: data['value'],
              child: Text(data['name']!),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() => _applicationSettingsDataListenAndSpeakLevel = value!);
          },
        ),

        Text(
          '單字量程度 Ranking',
          style: TextStyle(color: Colors.grey),
        ),


        DropdownButton<num?>(
          value: (listenAndSpeakRankingCheckData[_applicationSettingsDataListenAndSpeakLevel]!.contains(_applicationSettingsDataListenAndSpeakRanking)? _applicationSettingsDataListenAndSpeakRanking : listenAndSpeakRankingCheckData[_applicationSettingsDataListenAndSpeakLevel]![0]),
          items: listenAndSpeakRankingCheckData[_applicationSettingsDataListenAndSpeakLevel]!.map<DropdownMenuItem<num?>>((data) {
            return DropdownMenuItem(
              child: Text(listenAndSpeakRankingData[data].toString()),
              value: double.parse(data.toString()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _applicationSettingsDataListenAndSpeakRanking = double.parse(value.toString()));
          },
        ),
      ],
    );
  }

  Widget ttsSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text('語音設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Text(
          '音量 Volume',
          style: TextStyle(color: Colors.grey),
        ),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsVolume = value);
          },
          min: 0.0,
          max: 1.0,
          activeColor: Colors.lightBlueAccent,
          divisions: 10,
          value: _applicationSettingsDataTtsVolume,
        ),
        Text(''),
        Text(
          '音高 Pitch',
          style: TextStyle(color: Colors.grey),
        ),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsPitch = value);
          },
          min: 0.5,
          max: 1.0,
          activeColor: Colors.lightBlueAccent,
          divisions: 10,
          value: _applicationSettingsDataTtsPitch,
        ),
        Text(
          '語速 Rate',
          style: TextStyle(color: Colors.grey),
        ),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsRate = value);
          },
          min: 0.05,
          max: 1.0,
          activeColor: Colors.lightBlueAccent,
          divisions: 19,
          value: _applicationSettingsDataTtsRate,
        ),
      ],
    );
  }


  Widget pageIntroduceSettings() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text('頁面介紹', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: Text(
              '初始頁 SELS APP Home',
              style: TextStyle(color: Colors.grey),
            ),
            dense: true,
            value: _applicationSettingsSELSAppHomePageIntroduce,
            onChanged: (value) {
              setState(() => _applicationSettingsSELSAppHomePageIntroduce = value);
            },
          ),
          SwitchListTile(
            title: Text(
              '發音訓練2 PhoneticExercisesNew',
              style: TextStyle(color: Colors.grey),
            ),
            dense: true,
            value: _applicationSettingsPhoneticExercisesNewPageIntroduce,
            onChanged: (value) {
              setState(() => _applicationSettingsPhoneticExercisesNewPageIntroduce = value);
            },
          ),
          SwitchListTile(
            title: Text(
              '文法檢查 GrammarCheck',
              style: TextStyle(color: Colors.grey),
            ),
            dense: true,
            value: _applicationSettingsGrammarCheckPageIntroduce,
            onChanged: (value) {
              setState(() => _applicationSettingsGrammarCheckPageIntroduce = value);
            },
          ),



        ]
    );

  }

  Widget smartAssistantSettings() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text('助理設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          OutlinedButton(
            child: Text('重置助理連線金鑰（如遇到問題請點我重置）'),
            onPressed: () {
              APIUtil.getConversationTokenAndID();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('重置成功！'),
              ));
            },
          ),
        ]
    );
  }



}