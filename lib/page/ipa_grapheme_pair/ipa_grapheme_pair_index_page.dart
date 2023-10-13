import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';

class IPAGraphemePairIndexPage extends StatefulWidget {
  const IPAGraphemePairIndexPage({Key? key}) : super(key: key);

  @override
  _IPAGraphemePairIndexPage createState() => _IPAGraphemePairIndexPage();
}

class _IPAGraphemePairIndexPage extends State<IPAGraphemePairIndexPage> {
  final audioPlayer = AudioPlayer();

  // Index list API data
  List<String>? _ipaSymbolMonophthongs = [];
  List<String>? _graphemesMonophthongs = [];
  List<String>? _ipaSymbolUrlMonophthongs = [];
  List<String>? _ipaSymbolDiphthongs = [];
  List<String>? _graphemesDiphthongs = [];
  List<String>? _ipaSymbolUrlDiphthongs = [];
  List<String>? _ipaSymbolConsonants = [];
  List<String>? _graphemesConsonants = [];
  List<String>? _ipaSymbolUrlConsonants = [];
  List<List<int>>? _ipaAudioClipMonophthongs = [];
  List<List<int>>? _ipaAudioClipConsonants = [];


  // Temporary storage API data
  List<Map> _Monophthongs = [];
  List<Map> _Diphthongs = [];
  List<Map> _Consonants = [];

  // ExpansionTile index
  int _selected1 = -1;
  int _selected2 = -1;
  int _selected3 = -1;

  @override
  void initState() {
    super.initState();
    initIPAGraphemePairIndexPage();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PageTheme.app_theme_black,
          centerTitle: true,
          title: AutoSizeText(
            'IPA發音練習',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text("Vowel - Monophthongs",
                          style: TextStyle(
                              color: PageTheme.app_theme_blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text("單母音",
                          style: TextStyle(
                              color: PageTheme.app_theme_blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Container(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      key: Key('builder ${_selected1.toString()}'),
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: _ipaSymbolMonophthongs?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: PageTheme.app_theme_blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ExpansionTile(
                                key: Key(index.toString()),
                                initiallyExpanded: index == _selected1,
                                title: Flex(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Visibility(
                                              visible: _ipaSymbolUrlMonophthongs![index] != "",
                                              child: IconButton(
                                                icon: Icon(Icons.volume_up),
                                                onPressed: () async{
                                                  await audioPlayer.setUrl(_ipaSymbolUrlMonophthongs![index]);
                                                  if(_ipaAudioClipMonophthongs![index][1] != 0){
                                                    await audioPlayer.setClip(start: Duration(milliseconds: _ipaAudioClipMonophthongs![index][0]), end: Duration(milliseconds: _ipaAudioClipMonophthongs![index][1]));
                                                  }
                                                  audioPlayer.play();
                                                },
                                              ),
                                            ),
                                            Text(_ipaSymbolMonophthongs![index],
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: PageTheme
                                                        .app_theme_blue)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'grapheme: ',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                PageTheme.app_theme_blue),
                                          ),
                                          Text(
                                              _graphemesMonophthongs![index]
                                                  .replaceAll('[', '')
                                                  .replaceAll(']', ''),
                                              style: TextStyle(
                                                  color:
                                                  PageTheme.app_theme_blue))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: Column(
                                      children: <Widget>[
                                        Divider(
                                          thickness: 2,
                                          color: PageTheme
                                              .syllable_search_background,
                                        ),
                                        Flex(
                                          direction: Axis.horizontal,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ListView.builder(
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                    _Monophthongs[index]
                                                    ['getIPASymbol']
                                                        ?.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index2) {
                                                      return Flex(
                                                        direction:
                                                        Axis.horizontal,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                        padding:
                                                                        EdgeInsets.all(10)),
                                                                    Text(
                                                                      _Monophthongs[index]
                                                                      [
                                                                      'getGraphemes']
                                                                      [
                                                                      index2],
                                                                      //_getGraphemes![index2],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              _Monophthongs[index]
                                                              [
                                                              'getWord']
                                                              [index2]
                                                                  .replaceAll(
                                                                  '[', '')
                                                                  .replaceAll(
                                                                  ']', ''),
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.all(10)),
                                        Container(
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                    PageTheme.app_theme_blue,
                                                    radius: 25.0,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        AutoRouter.of(context).push(
                                                            LearningManualIPAGraphemePairRoute(
                                                              getIPASymbol:
                                                              _ipaSymbolMonophthongs![
                                                              index],
                                                              getGraphemes:
                                                              _Monophthongs[index]
                                                              ['getGraphemes'],
                                                              getWord:
                                                              _Monophthongs[index]
                                                              ['getWord'],
                                                              getWordIPA:
                                                              _Monophthongs[index]
                                                              ['getWordIPA'],
                                                            ));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const AutoSizeText(
                                                  '開始練習',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  if (expanded) {
                                    setState(() {
                                      _selected1 = -1;
                                      _selected2 = -1;
                                      _selected3 = -1;
                                      initIPAGraphemeWordList(
                                          _ipaSymbolMonophthongs![index],
                                          _Monophthongs,
                                          index);
                                      _selected1 = index;
                                    });
                                  } else {
                                    setState(() {
                                      _selected1 = -1;
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(4)),
                          ],
                        );
                      }),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text("Vowel - Diphthongs",
                          style: TextStyle(
                              color: PageTheme.app_theme_blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text("雙母音",
                          style: TextStyle(
                              color: PageTheme.app_theme_blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Container(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      key: Key('builder ${_selected2.toString()}'),
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      itemCount: _ipaSymbolDiphthongs?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: PageTheme.app_theme_blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ExpansionTile(
                                key: Key(index.toString()),
                                initiallyExpanded: index == _selected2,
                                title: Flex(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Visibility(
                                              visible: _ipaSymbolUrlDiphthongs![index] != "",
                                              child: IconButton(
                                                icon: Icon(Icons.volume_up),
                                                onPressed: () async{
                                                  await audioPlayer.setUrl(_ipaSymbolUrlDiphthongs![index]);
                                                  audioPlayer.play();
                                                },
                                              ),
                                            ),
                                            Text(_ipaSymbolDiphthongs![index],
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: PageTheme
                                                        .app_theme_blue)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'grapheme: ',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                PageTheme.app_theme_blue),
                                          ),
                                          Text(
                                              _graphemesDiphthongs![index]
                                                  .replaceAll('[', '')
                                                  .replaceAll(']', ''),
                                              style: TextStyle(
                                                  color:
                                                  PageTheme.app_theme_blue))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: Column(
                                      children: <Widget>[
                                        Divider(
                                          thickness: 2,
                                          color: PageTheme
                                              .syllable_search_background,
                                        ),
                                        Flex(
                                          direction: Axis.horizontal,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ListView.builder(
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                    _Diphthongs[index]
                                                    ['getIPASymbol']
                                                        ?.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index2) {
                                                      return Flex(
                                                        direction:
                                                        Axis.horizontal,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                        padding:
                                                                        EdgeInsets.all(10)),
                                                                    Text(
                                                                      _Diphthongs[index]
                                                                      [
                                                                      'getGraphemes']
                                                                      [
                                                                      index2],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              _Diphthongs[index]
                                                              [
                                                              'getWord']
                                                              [index2]
                                                                  .replaceAll(
                                                                  '[', '')
                                                                  .replaceAll(
                                                                  ']', ''),
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.all(10)),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                  PageTheme.app_theme_blue,
                                                  radius: 25.0,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      AutoRouter.of(context).push(
                                                          LearningManualIPAGraphemePairRoute(
                                                            getIPASymbol:
                                                            _ipaSymbolDiphthongs![
                                                            index],
                                                            getGraphemes:
                                                            _Diphthongs[index][
                                                            'getGraphemes'],
                                                            getWord:
                                                            _Diphthongs[index]
                                                            ['getWord'],
                                                            getWordIPA:
                                                            _Diphthongs[index]
                                                            ['getWordIPA'],
                                                          ));
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const AutoSizeText(
                                                '開始練習',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  if (expanded) {
                                    setState(() {
                                      _selected1 = -1;
                                      _selected2 = -1;
                                      _selected3 = -1;
                                      initIPAGraphemeWordList(
                                          _ipaSymbolDiphthongs![index],
                                          _Diphthongs,
                                          index);
                                      _selected2 = index;
                                    });
                                  } else {
                                    setState(() {
                                      _selected2 = -1;
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(4)),
                          ],
                        );
                      }),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text("Consonants",
                          style: TextStyle(
                              color: PageTheme.app_theme_blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text("子音",
                          style: TextStyle(
                              color: PageTheme.app_theme_blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Container(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      key: Key('builder ${_selected3.toString()}'),
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      itemCount: _ipaSymbolConsonants?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: PageTheme.app_theme_blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ExpansionTile(
                                key: Key(index.toString()),
                                initiallyExpanded: index == _selected3,
                                title: Flex(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Visibility(
                                              visible: _ipaSymbolUrlConsonants![index] != "",
                                              child: IconButton(
                                                icon: Icon(Icons.volume_up),
                                                onPressed: () async{
                                                  await audioPlayer.setUrl(_ipaSymbolUrlConsonants![index]);
                                                  if(_ipaAudioClipConsonants![index][1] != 0){
                                                    await audioPlayer.setClip(start: Duration(milliseconds: _ipaAudioClipConsonants![index][0]), end: Duration(milliseconds: _ipaAudioClipConsonants![index][1]));
                                                  }
                                                  audioPlayer.play();
                                                },
                                              ),
                                            ),
                                            Text(_ipaSymbolConsonants![index],
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: PageTheme
                                                        .app_theme_blue)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'grapheme: ',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                PageTheme.app_theme_blue),
                                          ),
                                          Text(
                                              _graphemesConsonants![index]
                                                  .replaceAll('[', '')
                                                  .replaceAll(']', ''),
                                              style: TextStyle(
                                                  color:
                                                  PageTheme.app_theme_blue))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: Column(
                                      children: <Widget>[
                                        Divider(
                                          thickness: 2,
                                          color: PageTheme
                                              .syllable_search_background,
                                        ),
                                        Flex(
                                          direction: Axis.horizontal,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ListView.builder(
                                                    physics:
                                                    NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                    _Consonants[index]
                                                    ['getIPASymbol']
                                                        ?.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index2) {
                                                      return Flex(
                                                        direction:
                                                        Axis.horizontal,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                        padding:
                                                                        EdgeInsets.all(10)),
                                                                    Text(
                                                                      _Consonants[index]
                                                                      [
                                                                      'getGraphemes']
                                                                      [
                                                                      index2],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              _Consonants[index]
                                                              [
                                                              'getWord']
                                                              [index2]
                                                                  .replaceAll(
                                                                  '[', '')
                                                                  .replaceAll(
                                                                  ']', ''),
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                  PageTheme.app_theme_blue,
                                                  radius: 25.0,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      AutoRouter.of(context).push(
                                                          LearningManualIPAGraphemePairRoute(
                                                            getIPASymbol:
                                                            _ipaSymbolConsonants![
                                                            index],
                                                            getGraphemes:
                                                            _Consonants[index][
                                                            'getGraphemes'],
                                                            getWord:
                                                            _Consonants[index]
                                                            ['getWord'],
                                                            getWordIPA:
                                                            _Consonants[index]
                                                            ['getWordIPA'],
                                                          ));
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const AutoSizeText(
                                                '開始練習',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  if (expanded) {
                                    setState(() {
                                      _selected1 = -1;
                                      _selected2 = -1;
                                      _selected3 = -1;
                                      initIPAGraphemeWordList(
                                          _ipaSymbolConsonants![index],
                                          _Consonants,
                                          index);
                                      _selected3 = index;
                                    });
                                  } else {
                                    setState(() {
                                      _selected3 = -1;
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(4)),
                          ],
                        );
                      }),
                ),
              ],
            )));
  }

  initIPAGraphemePairIndexPage() async {
    await initIPAList();
  }

  Future<void> initIPAList() async {
    List<String> ipaSymbolMonophthongs = [];
    List<String> graphemesMonophthongs = [];
    List<String> ipaSymbolUrlMonophthongs = [];
    List<String> ipaSymbolDiphthongs = [];
    List<String> graphemesDiphthongs = [];
    List<String> ipaSymbolUrlDiphthongs = [];
    List<String> ipaSymbolConsonants = [];
    List<String> graphemesConsonants = [];
    List<String> ipaSymbolUrlConsonants = [];
    List<List> ipaAudioClipConsonants = [];
    List<List> ipaAudioClipMonophthongs = [];
    Map mapTemplate = {
      'getIPASymbol': '',
      'getGraphemes': '',
      'getWord': '',
      'getWordIPA': '',
    };

    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var getIPAGraphemePair;
    do {
      String getIPAGraphemePairJSON =
      await APIUtil.getIPAGraphemePair('monophthongs');
      getIPAGraphemePair = jsonDecode(getIPAGraphemePairJSON.toString());
      if (getIPAGraphemePair['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (getIPAGraphemePair['apiStatus'] != 'success');

    getIPAGraphemePair['data'].forEach((value) {
      ipaSymbolMonophthongs.add(value["ipaSymbol"]);
      graphemesMonophthongs.add(value["grapheme"].toString());
      ipaSymbolUrlMonophthongs.add(value["audioUrl"]);
      ipaAudioClipMonophthongs.add(value['audioClip'].map((number) => double.tryParse(number)! * 1000).toList());
    });

    do {
      String getIPAGraphemePairJSON =
      await APIUtil.getIPAGraphemePair('diphthongs');
      getIPAGraphemePair = jsonDecode(getIPAGraphemePairJSON.toString());
      if (getIPAGraphemePair['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (getIPAGraphemePair['apiStatus'] != 'success');

    getIPAGraphemePair['data'].forEach((value) {
      ipaSymbolDiphthongs.add(value["ipaSymbol"]);
      graphemesDiphthongs.add(value["grapheme"].toString());
      ipaSymbolUrlDiphthongs.add(value["audioUrl"]);
    });

    do {
      String getIPAGraphemePairJSON =
      await APIUtil.getIPAGraphemePair('consonants');
      getIPAGraphemePair = jsonDecode(getIPAGraphemePairJSON.toString());
      if (getIPAGraphemePair['apiStatus'] != 'success') {
        await Future.delayed(Duration(seconds: 1));
      }
    } while (getIPAGraphemePair['apiStatus'] != 'success');

    EasyLoading.dismiss();
    getIPAGraphemePair['data'].forEach((value) {
      ipaSymbolConsonants.add(value["ipaSymbol"]);
      graphemesConsonants.add(value["grapheme"].toString());
      ipaSymbolUrlConsonants.add(value["audioUrl"]);
      ipaAudioClipConsonants.add(value['audioClip'].map((number) => double.tryParse(number)! * 1000).toList());
    });

    setState(() {
      _ipaSymbolMonophthongs = ipaSymbolMonophthongs;
      _graphemesMonophthongs = graphemesMonophthongs;
      _ipaSymbolUrlMonophthongs = ipaSymbolUrlMonophthongs;
      _ipaSymbolDiphthongs = ipaSymbolDiphthongs;
      _graphemesDiphthongs = graphemesDiphthongs;
      _ipaSymbolUrlDiphthongs = ipaSymbolUrlDiphthongs;
      _ipaSymbolConsonants = ipaSymbolConsonants;
      _graphemesConsonants = graphemesConsonants;
      _ipaSymbolUrlConsonants = ipaSymbolUrlConsonants;
      _ipaAudioClipMonophthongs = ipaAudioClipMonophthongs.map((e) => e.map((ex) => ex as int).toList()).toList();
      _ipaAudioClipConsonants = ipaAudioClipConsonants.map((e) => e.map((ex) => ex as int).toList()).toList();

      _ipaSymbolMonophthongs?.forEach((value) {
        _Monophthongs.add(mapTemplate);
      });
      _ipaSymbolDiphthongs?.forEach((value) {
        _Diphthongs.add(mapTemplate);
      });
      _ipaSymbolConsonants?.forEach((value) {
        _Consonants.add(mapTemplate);
      });
    });
  }

  Future<void> initIPAGraphemeWordList(
      String ipaSymbol, List ipaType, int index) async {
    List<String> getIPASymbol = [];
    List<String> getGraphemes = [];
    List<String> getWord = [];
    List<String> getWordIPA = [];

    if (ipaType[index]['getIPASymbol'] == '') {
      EasyLoading.show(status: '正在讀取資料，請稍候......');
      var getIPAGraphemePairWord;
      do {
        String getIPAGraphemePairWordJSON =
        await APIUtil.getIPAGraphemePairWord(ipaSymbol);
        getIPAGraphemePairWord =
            jsonDecode(getIPAGraphemePairWordJSON.toString());
        if (getIPAGraphemePairWord['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getIPAGraphemePairWord['apiStatus'] != 'success');

      EasyLoading.dismiss();
      getIPAGraphemePairWord['data'].forEach((value) {
        getIPASymbol.add(value["ipaSymbol"]);
        getGraphemes.add(value["grapheme"]);
        getWord.add(value['word'].toString());
        getWordIPA.add(value['wordIPA']);
      });

      setState(() {
        ipaType[index] = {
          'getIPASymbol': getIPASymbol,
          'getGraphemes': getGraphemes,
          'getWord': getWord,
          'getWordIPA': getWordIPA,
        };
      });
    } else {
      setState(() {});
    }
  }
}
