import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
  String _applicationSettingsDataAPIURL = 'api.alicsnet.com';

  @override
  void initState() {
    super.initState();
    initIndexSettingPage();
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
              child: const Text('語音設定',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: ttsSettings(),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('應用程式API設定',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: appAPISettings(),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('助理設定',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
        const Text('音量 Volume',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsVolume = value);
            SharedPreferencesUtil.setTTSVolume(value);
          },
          min: 0.0,
          max: 1.0,
          activeColor: Colors.grey,
          inactiveColor: Colors.grey.shade300,
          divisions: 10,
          value: _applicationSettingsDataTtsVolume,
        ),
        const Text('音高 Pitch',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsPitch = value);
            SharedPreferencesUtil.setTTSPitch(value);
          },
          min: 0.5,
          max: 2.0,
          activeColor: Colors.grey,
          inactiveColor: Colors.grey.shade300,
          divisions: 15,
          value: _applicationSettingsDataTtsPitch,
        ),
        const Text('語速 Rate',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          onChanged: (value) {
            setState(() => _applicationSettingsDataTtsRate = value);
            SharedPreferencesUtil.setTTSRate(value);
            print(value);
          },
          min: 0.125,
          max: 1.0,
          activeColor: Colors.grey,
          inactiveColor: Colors.grey.shade300,
          divisions: 7,
          value: _applicationSettingsDataTtsRate,
          label: '${(_applicationSettingsDataTtsRate * 2).toString()}倍',
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('重置成功！'),
            ));
          },
        ),
      ],
    );
  }

  Widget appAPISettings() {
    //List<String> apiURLList = ['api.alicsnet.com', 'api-develop.alicsnet.com'];
    List<Map<String, String>> apiURLList = [
      {
        'name': '正式環境',
        'value': 'api.alicsnet.com',
      },
      {
        'name': '測試環境',
        'value': 'api-develop.alicsnet.com',
      },
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(color: PageTheme.app_theme_blue),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButton(
            value: _applicationSettingsDataAPIURL,
            //style: TextStyle(fontSize: 20),
            isExpanded: true,
            iconSize: 40,
            hint: AutoSizeText(
              '   請選擇第一個字元',
              style: TextStyle(color: PageTheme.app_theme_blue),
              maxLines: 1,
            ),
            items: apiURLList
                .map<DropdownMenuItem<String>>((Map<String, String> value) {
              return DropdownMenuItem<String>(
                value: value['value'],
                child: AutoSizeText(
                  '  ${value['name']}',
                  style: TextStyle(color: PageTheme.app_theme_blue),
                  maxLines: 1,
                ),
              );
            }).toList(),

            onChanged: (String? value) {
              setState(() => _applicationSettingsDataAPIURL = value!);
              SharedPreferencesUtil.setAPIURL(value!);
            },
            underline: Container(
              height: 0,
            ),
          ),
        ),
      ],
    );
  }

  /*
  initState() 初始化相關
   */
  initIndexSettingPage() async {
    await initApplicationSettingsData();
  }

  initApplicationSettingsData() {
    SharedPreferencesUtil.getTTSVolume().then((value) {
      setState(() => _applicationSettingsDataTtsVolume = value);
    });
    SharedPreferencesUtil.getTTSPitch().then((value) {
      setState(() => _applicationSettingsDataTtsPitch = value);
    });
    SharedPreferencesUtil.getTTSRate().then((value) {
      setState(() => _applicationSettingsDataTtsRate = value);
    });
    SharedPreferencesUtil.getAPIURL().then((value) {
      setState(() => _applicationSettingsDataAPIURL = value);
    });
  }
}
