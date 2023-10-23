import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:alicsnet_app/view/button_square_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class ChatTopicPracticeClassMobilePage extends StatefulWidget {
  const ChatTopicPracticeClassMobilePage({Key? key}) : super(key: key);

  @override
  _ChatTopicPracticeClassMobilePageState createState() =>
      _ChatTopicPracticeClassMobilePageState();
}

class _ChatTopicPracticeClassMobilePageState
    extends State<ChatTopicPracticeClassMobilePage> {
  List<Widget> _listViews = <Widget>[];

  List _CompleteSentenceList = [];

  @override
  void initState() {
    super.initState();
    initChatTopicPracticeIndexPage();
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
            '生活英語情境',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Container(
            decoration: BoxDecoration(
              color: HexColor('#EEF2F8'),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 24,
                  bottom: 62,
                ),
                itemCount: _listViews.length,
                itemBuilder: (BuildContext context, int index) {
                  return _listViews[index];
                }),
          ),
        ));
  }

  initChatTopicPracticeIndexPage() async {
    await initChatTopicList();
  }

  Future<bool> initChatTopicList() async {
    var responseJSONDecode;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.getChatTopicClassDataOnly();
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');

      List<Widget> listViews = <Widget>[];

      responseJSONDecode['data'].forEach((key) {
        print(key);
        /*listViews.add(TitleView(
          titleTxt: '${key}',
          titleColor: Colors.black,
        ));*/

        var parser = EmojiParser();

        listViews.add(ButtonSquareView(mainText: "${key['classChinese']} - ${key['className']}", subTextBottomLeft: key['classDescribe'], subTextBottomRight: '', widgetColor: HexColor('#FDFEFB'), borderColor: Colors.transparent,onTapFunction: (){
          AutoRouter.of(context).push(
              ChatTopicPracticeTopicMobileRoute(topicClassId: key['classId'].toString(), topicClassName: "${key['classChinese']}\n${key['className']}"));
        },));

      });

      setState(() {
        _listViews = listViews;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
    return responseJSONDecode['apiStatus'] == 'success';
  }
}
