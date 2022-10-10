import 'dart:convert';

import 'package:alicsnet_app/view/title_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PreferenceTranslationEditPage extends StatefulWidget {
  final Map sentenceDataList;

  const PreferenceTranslationEditPage(
      {Key? key, required this.sentenceDataList})
      : super(key: key);

  @override
  _PreferenceTranslationEditPageState createState() =>
      _PreferenceTranslationEditPageState();
}

class _PreferenceTranslationEditPageState
    extends State<PreferenceTranslationEditPage> {
  late Map _sentenceDataList;
  String mainlike = '';

  TextEditingController _adController = TextEditingController();
  TextEditingController _edController = TextEditingController();
  int _rowIndexSliderMin = 1;
  int _rowIndexSliderMax = 10000;
  int _rowIndexSliderIndex = 1;
  int _amountSliderIndex = 5;
  int _dataLimit = 5;
  int _ClauseCount = 1;
  String _sliderEducationLevel = '國小';
  final FlutterTts flutterTts = FlutterTts();

  List<Widget> listViews = <Widget>[];
  List<int> recommandId = [];
  Map _preferenceMap = {};
  Map _sentenceRecord = {};
  Map _recommendRecord = {};

  speak(String lan, String text) async {
    await flutterTts.setLanguage(lan);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    _sentenceDataList = widget.sentenceDataList;
    //pageRefresher();
    initList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PageTheme.app_theme_black,
        title: AutoSizeText(
          '推薦翻譯系統',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 3.0,
            color: Color(0xFFFEFEFE),
          ),
          maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: TitleView(
                titleTxt: '預設翻譯',
                titleColor: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: double.infinity,
                height: 400,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PageTheme.app_theme_blue,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: AutoSizeText(
                                        'ID:' +
                                            _sentenceDataList['sentenceID']
                                                .toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: PageTheme.app_theme_blue)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: AutoSizeText(
                                    '句長:' +
                                        _sentenceDataList['sentenceLength']
                                            .toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: PageTheme.app_theme_blue)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: AutoSizeText(
                                    '最高字排:' +
                                        _sentenceDataList['sentenceHWR']
                                            .toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                        color: PageTheme.app_theme_blue)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: AutoSizeText(
                                    '子句:' +
                                        _ClauseCount.toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: PageTheme.app_theme_blue)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: PageTheme.syllable_search_background,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: AutoSizeText(
                                      _sentenceDataList['sentenceContent']
                                          .toString(),
                                      maxLines: 5,
                                      textAlign: TextAlign.center,
                                      minFontSize: 18,
                                      maxFontSize: 50,
                                      style: TextStyle(
                                          color: PageTheme.app_theme_blue)),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: AutoSizeText(
                                      _sentenceDataList['sentenceChinese']
                                          .toString(),
                                      maxLines: 5,
                                      textAlign: TextAlign.center,
                                      minFontSize: 18,
                                      maxFontSize: 50,
                                      style: TextStyle(
                                          color: PageTheme.app_theme_blue)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: PageTheme.syllable_search_background,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const AutoSizeText(
                                      '英',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Icon(Icons.volume_up)
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: PageTheme.app_theme_blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shadowColor: Colors.black,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () async {
                                  speak('en',
                                      _sentenceDataList['sentenceContent']);
                                }),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const AutoSizeText(
                                      '中',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Icon(Icons.volume_up)
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: PageTheme.app_theme_blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shadowColor: Colors.black,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () async {
                                  speak('zh',
                                      _sentenceDataList['sentenceChinese']);
                                }),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
                                        mainlike,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Expanded(child: Icon(Icons.thumb_up))
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: PageTheme.app_theme_blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shadowColor: Colors.black,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () async {
                                  await _getUserSentenceLikeRecord(
                                      '${FirebaseAuth.instance.currentUser?.uid}');
                                  List leng = _sentenceRecord['votedSentenceID']
                                      as List;
                                  if (leng.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('感謝你的回饋!'),
                                    ));
                                    await _sentUserSentenceLikeRecord(
                                        _sentenceDataList['sentenceID']
                                            .toString(),
                                        '${FirebaseAuth.instance.currentUser?.uid}');
                                    initList();
                                  } else {
                                    for (int i = 0; i < leng.length; i++) {
                                      if (_sentenceDataList['sentenceID'] ==
                                          _sentenceRecord['votedSentenceID']
                                              [i]) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('你已經點過讚了喔!'),
                                        ));
                                        break;
                                      }
                                      if (i == leng.length - 1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('感謝你的回饋!'),
                                        ));
                                        await _sentUserSentenceLikeRecord(
                                            _sentenceDataList['sentenceID']
                                                .toString(),
                                            '${FirebaseAuth.instance.currentUser?.uid}');
                                        initList();
                                      }
                                    }
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TitleView(
                titleTxt: '推薦翻譯',
                titleColor: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listViews.length,
                //itemExtent: 100.0, //强制高度为50.0

                itemBuilder: (BuildContext context, int index) {
                  return listViews[index];
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 16,
                  color: PageTheme.grey,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(20)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 350,
                child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AutoSizeText(
                          '新增翻譯',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(Icons.add)
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: PageTheme.app_theme_blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shadowColor: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () async {
                      showAddDialog(context);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  other
   */
  Future<Map> _sentenceClauseCount(String sent) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.sentenceClauseCount(sent);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        _ClauseCount = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  Future<Map> _refreshPreference(String id) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.getPreferenceDataByID(id);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        _preferenceMap = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  Future<Map> _sentRecommandAddQuery(String id, String chinese) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.sentRecommandAddQuery(id, chinese);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        //_preferenceMap = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  Future<Map> _sentRecommandEditQuery(String id, String chinese) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.sentRecommandEditQuery(id, chinese);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        //_preferenceMap = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  Future<Map> _getUserSentenceLikeRecord(String uid) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.getUserSentenceLikeRecord(uid);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        _sentenceRecord = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  Future<Map> _getUserRecommendLikeRecord(String uid) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.getUserRecommendLikeRecord(uid);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        _recommendRecord = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  Future<Map> _sentUserSentenceLikeRecord(String id, String uid) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.sentUserSentenceLikeRecord(id, uid);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        //_preferenceMap = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  Future<Map> _sentUserRecommendLikeRecord(String id, String uid) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON =
            await APIUtil.sentUserRecommendLikeRecord(id, uid);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        //_preferenceMap = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  Future<Map> _sentSentenceClosedRecord(String id, String chinese) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON =
            await APIUtil.sentSentenceClosedRecord(id, chinese);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        //_preferenceMap = responseJSONDecode['data'];
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    EasyLoading.dismiss();
    return responseJSONDecode;
  }

  void pageRefresher() async {
    try{
      await _sentenceClauseCount(_sentenceDataList['sentenceContent']);
    }catch(e){};
    List ll = _preferenceMap['likeDislike'] as List;
    if (ll.isNotEmpty) if (_preferenceMap['likeDislike'][0][0] >= 3) {
      await _sentSentenceClosedRecord(
          _sentenceDataList['sentenceID'].toString(),
          _sentenceDataList['sentenceChinese']);
      closeDialog(context);
      //Navigator.pop(context);
    }
    List l = _preferenceMap['sentenceRecommandChinese'] as List;
    //print(_preferenceMap['sentenceRecommandChinese'][0][2]);
    if (l.isNotEmpty)
      for (int i = 0; i < l.length; i++) {
        if (_preferenceMap['sentenceRecommandChinese'][i][2] >= 3) {
          await _sentSentenceClosedRecord(
              _sentenceDataList['sentenceID'].toString(),
              _preferenceMap['sentenceRecommandChinese'][i][1]);
          closeDialog(context);
          //Navigator.pop(context);
        }
      }
    //重製列表
    listViews = [];
    List length = _preferenceMap['sentenceRecommandChinese'] as List;
    List liked = _preferenceMap['likeDislike'] as List;

    if (liked.isNotEmpty) {
      mainlike = _preferenceMap['likeDislike'][0][0].toString();
    } else {
      mainlike = '0';
    }
    if (length.isNotEmpty) {
      for (int i = 0; i < length.length; i++) {
        //recommandId.add(_preferenceMap[i][0]);
        listViews.add(
          Container(
            height: 300,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: PageTheme.app_theme_blue,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Align(
                    alignment: AlignmentDirectional(0, -1),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                  '翻譯ID:' +
                                      _preferenceMap['sentenceRecommandChinese']
                                              [i][0]
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: PageTheme.app_theme_blue)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: PageTheme.syllable_search_background,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(5)),
                      AutoSizeText(
                          _preferenceMap['sentenceRecommandChinese'][i][1]
                              .toString(),
                          minFontSize: 20,
                          style: TextStyle(color: PageTheme.app_theme_blue)),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: PageTheme.syllable_search_background,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: const AutoSizeText(
                                    '中',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Expanded(child: Icon(Icons.volume_up))
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: PageTheme.app_theme_blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shadowColor: Colors.black,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () async {
                              speak(
                                  'zh',
                                  _preferenceMap['sentenceRecommandChinese'][i]
                                      [1]);
                            }),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AutoSizeText(
                                  '修改翻譯',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Icon(Icons.edit)
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: PageTheme.app_theme_blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shadowColor: Colors.black,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () async {
                              //int index =_preferenceMap['sentenceRecommandChinese'][i][0];
                              //print(index);
                              showAlertDialog(context, i);
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    _preferenceMap['sentenceRecommandChinese']
                                            [i][2]
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Expanded(child: Icon(Icons.thumb_up))
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: PageTheme.app_theme_blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shadowColor: Colors.black,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () async {
                              await _getUserRecommendLikeRecord(
                                  '${FirebaseAuth.instance.currentUser?.uid}');
                              List leng =
                                  _recommendRecord['votedRecommendID'] as List;
                              if (leng.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('感謝你的回饋!'),
                                ));

                                await _sentUserRecommendLikeRecord(
                                    _preferenceMap['sentenceRecommandChinese']
                                            [i][0]
                                        .toString(),
                                    '${FirebaseAuth.instance.currentUser?.uid}');
                                initList();
                              } else {
                                for (int j = 0; j < leng.length; j++) {
                                  if (_preferenceMap['sentenceRecommandChinese']
                                          [j][0] ==
                                      _recommendRecord['votedRecommendID'][i]) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('你已經點過讚了喔!'),
                                    ));
                                    break;
                                  }
                                  if (j == leng.length - 1) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('感謝你的回饋!'),
                                    ));
                                    await _sentUserRecommendLikeRecord(
                                        _preferenceMap[
                                                    'sentenceRecommandChinese']
                                                [i][0]
                                            .toString(),
                                        '${FirebaseAuth.instance.currentUser?.uid}');
                                    initList();
                                  }
                                }
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }
    setState(() {});
  }

  void initList() async {
    //listViews=[];
    await _refreshPreference(_sentenceDataList['sentenceID'].toString());

    pageRefresher();
  }

  closeDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: Text("翻譯讚數超過3，此翻譯已關閉!感謝您的意見!"),
      content: Container(
        width: 400,
        height: 5,
        padding: const EdgeInsets.all(8),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Expanded(child: Icon(Icons.done))],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: PageTheme.app_theme_blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () async {
                    Navigator.pop(context);
                    context.router.pop();
                  }),
            ),
          ],
        ),
      ],
    );

    // Show the dialog
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Wrap();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            (1.0 - Curves.easeInOut.transform(anim1.value)) * 200,
            0.0,
          ),
          child: dialog,
        );
      },
      transitionDuration: Duration(milliseconds: 200),
    );
  }

  showAddDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: Text("新增翻譯"),
      content: Container(
        width: 400,
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: PageTheme.app_theme_blue,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: TextField(
          controller: _adController,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Expanded(
                        child: AutoSizeText(
                         '確認',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),*/
                      Expanded(child: Icon(Icons.done))
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: PageTheme.app_theme_blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () async {
                    //String regexCn = "[\\u4e00-\\u9fa5]+";
                    List length =
                        _preferenceMap['sentenceRecommandChinese'] as List;
                    if (_adController.text.trim().isNotEmpty) {
                      if (_adController.text.trim() !=
                          _sentenceDataList['sentenceChinese']) {
                        if (length.isNotEmpty) {
                          for (int i = 0; i < length.length; i++) {
                            if (_adController.text.trim() ==
                                _preferenceMap['sentenceRecommandChinese'][i]
                                    [1]) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('該翻譯已經存在!'),
                              ));
                              break;
                            }
                            if (i == length.length - 1)
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('新增成功'),
                              ));
                            await _sentRecommandAddQuery(
                                _sentenceDataList['sentenceID'].toString(),
                                _adController.text.trim());
                            initList();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('新增成功'),
                          ));
                          await _sentRecommandAddQuery(
                              _sentenceDataList['sentenceID'].toString(),
                              _adController.text.trim());
                          initList();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('該翻譯與預設翻譯衝突!'),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('請勿輸入空值!'),
                      ));
                    }

                    Navigator.pop(context);
                  }),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Expanded(
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* Expanded(
                        child: AutoSizeText(
                          '取消',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),*/
                      Expanded(child: Icon(Icons.cancel_outlined))
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: PageTheme.app_theme_blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ],
    );

    // Show the dialog
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Wrap();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            (1.0 - Curves.easeInOut.transform(anim1.value)) * 200,
            0.0,
          ),
          child: dialog,
        );
      },
      transitionDuration: Duration(milliseconds: 200),
    );
  }

  showAlertDialog(BuildContext context, int index) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: Text('修改翻譯:' +
          _preferenceMap['sentenceRecommandChinese'][index][1] +
          '\n翻譯ID:' +
          _preferenceMap['sentenceRecommandChinese'][index][0].toString()),
      content: Container(
        width: 400,
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: PageTheme.app_theme_blue,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: TextField(
          controller: _edController,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Expanded(
                        child: AutoSizeText(
                         '確認',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),*/
                      Expanded(child: Icon(Icons.done))
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: PageTheme.app_theme_blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () async {
                    //String regexCn = "[\\u4e00-\\u9fa5]+";
                    List length =
                        _preferenceMap['sentenceRecommandChinese'] as List;
                    if (_edController.text.trim().isNotEmpty) {
                      if (_edController.text.trim() !=
                          _sentenceDataList['sentenceChinese']) {
                        if (length.isNotEmpty) {
                          for (int i = 0; i < length.length; i++) {
                            if (_edController.text.trim() ==
                                _preferenceMap['sentenceRecommandChinese'][i]
                                    [1]) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('該翻譯已經存在!'),
                              ));
                              break;
                            }
                            if (i == length.length - 1)
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('修改成功'),
                              ));
                            await _sentRecommandEditQuery(
                                _preferenceMap['sentenceRecommandChinese']
                                        [index][0]
                                    .toString(),
                                _edController.text.trim());
                            initList();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('修改成功'),
                          ));
                          await _sentRecommandEditQuery(
                              _preferenceMap['sentenceRecommandChinese'][index]
                                      [0]
                                  .toString(),
                              _edController.text.trim());
                          initList();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('該翻譯與預設翻譯衝突!'),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('請勿輸入空值!'),
                      ));
                    }

                    Navigator.pop(context);
                  }),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Expanded(
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* Expanded(
                        child: AutoSizeText(
                          '取消',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),*/
                      Expanded(child: Icon(Icons.cancel_outlined))
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: PageTheme.app_theme_blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ],
    );

    // Show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }
}
