import 'package:flutter/material.dart';

class IndexSettingPage extends StatefulWidget {
  const IndexSettingPage({Key? key}) : super(key: key);

  @override
  _IndexSettingPageState createState() => _IndexSettingPageState();
}

class _IndexSettingPageState extends State<IndexSettingPage> {


  double _applicationSettingsDataTtsVolume = 1.0;
  double _applicationSettingsDataTtsPitch = 1.0;
  double _applicationSettingsDataTtsRate = 1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('語音設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: ttsSettings(),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('助理設定', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: smartAssistantSettings(),
            ),
          ],
        ),
      ),




    );
  }

  Widget ttsSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('音量 Volume', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsVolume = value);
          },
          min: 0.0,
          max: 1.0,
          activeColor: Colors.grey,
          inactiveColor: Colors.grey.shade300,
          divisions: 10,
          value: _applicationSettingsDataTtsVolume,
        ),
        const Text('音高 Pitch', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsPitch = value);
          },
          min: 0.5,
          max: 1.0,
          activeColor: Colors.grey,
          inactiveColor: Colors.grey.shade300,
          divisions: 10,
          value: _applicationSettingsDataTtsPitch,
        ),
        const Text('語速 Rate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsRate = value);
          },
          min: 0.05,
          max: 1.0,
          activeColor: Colors.grey,
          inactiveColor: Colors.grey.shade300,
          divisions: 19,
          value: _applicationSettingsDataTtsRate,
        ),
      ],
    );
  }

  Widget smartAssistantSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        OutlinedButton(
          child: const Text('重置助理連線金鑰（如遇到問題請點我重置）'),
          onPressed: () {
            //APIUtil.getConversationTokenAndID();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('重置成功！'),));
          },
        ),
      ],
    );
  }

}