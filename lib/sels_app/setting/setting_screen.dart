
import 'package:flutter/material.dart';
import '../utils/SharedPreferencesUtil.dart';

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

  @override
  void initState() {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          centerTitle: true,
          title: Text('應用設定'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsVolume', _applicationSettingsDataTtsVolume);
            SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsPitch', _applicationSettingsDataTtsPitch);
            SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsRate', _applicationSettingsDataTtsRate);
            SharedPreferencesUtil.saveData<String>('applicationSettingsDataListenAndSpeakLevel', _applicationSettingsDataListenAndSpeakLevel);
          },
          child: Icon(Icons.save),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _listenAndSpeakSettings(),
                _ttsSettings(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _listenAndSpeakSettings() {
    return Column(
      children: <Widget>[
        Text('Listen & Speak 設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Listen & Speak 等級'),
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
        Divider(
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  Widget _ttsSettings() {
    return Column(
      children: <Widget>[
        Text('語音設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('音量 Volume'),
        Slider(
          value: _applicationSettingsDataTtsVolume,
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsVolume = value);
          },
          min: 0.0,
          max: 1.0,
          divisions: 10,
          //label: "Volume: $_applicationSettingsDataTtsVolume "
          activeColor: Colors.blue,
        ),
        Text('音高 Pitch'),
        Slider(
          value: _applicationSettingsDataTtsPitch,
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsPitch = value);
          },
          min: 0.5,
          max: 1.0,
          divisions: 10,
          //label: "Pitch: $_applicationSettingsDataTtsPitch",
          activeColor: Colors.red,
        ),
        Text('語速 Rate'),
        Slider(
          value: _applicationSettingsDataTtsRate,
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsRate = value);
          },
          min: 0.05,
          max: 1.0,
          divisions: 19,
          //label: "Rate: $_applicationSettingsDataTtsRate",
          activeColor: Colors.green,
        ),
        Divider(
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}