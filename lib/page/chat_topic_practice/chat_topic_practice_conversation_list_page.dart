import 'dart:convert';
import 'dart:io';

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

class ChatTopicPracticeConversationListPage extends StatefulWidget {
  final String topicName;

  const ChatTopicPracticeConversationListPage(
      {Key? key, required this.topicName})
      : super(key: key);

  @override
  _ChatTopicPracticeConversationListPageState createState() =>
      _ChatTopicPracticeConversationListPageState();
}

class _ChatTopicPracticeConversationListPageState
    extends State<ChatTopicPracticeConversationListPage> {
  List<Widget> _listViews = <Widget>[];
  String _topicName = '';
  Map _titleDict = {};

  @override
  void initState() {
    _topicName = widget.topicName;
    super.initState();
    initVocabularyPracticeTitleListPage();
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
            '選擇情境對話',
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
          child: ListView.separated(
            padding: EdgeInsets.only(
              top: 24,
              bottom: 62,
            ),
            itemCount: _listViews.length,
            itemBuilder: (BuildContext context, int index) {
              return _listViews[index];
            },
            separatorBuilder: (BuildContext context, int index) {
              return Padding(padding: EdgeInsets.all(10));
            },
          ),
        ));
  }

  Future<void> initVocabularyPracticeTitleListPage() async {
    await initTitleList();
  }

  Future<bool> initTitleList() async {
    var responseJSONDecode;
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try {
      int doLimit = 1;
      do {
        String responseJSON =
        await APIUtil.getConversationGroupData(_topicName);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 3)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 3 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');

      _titleDict = responseJSONDecode['data'];

      List<Widget> listViews = <Widget>[];

      //print(_titleDict);

      listViews.add(Wrap(
          alignment: WrapAlignment.center,
          spacing: 2,
          children: List.generate(_titleDict!.length, (index) {
            print(index);
            //if (index == 0) return Container();
            //return Text(value['title'][index]);
            //print(value['title'][index]);
            return Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(54.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 4, right: 4, bottom: 4),
                      child: ButtonSquareView(
                        mainText:
                        '${_titleDict[(index + 1).toString()]['conversationTitle']}\n',
                        subTextBottomRight:
                        '對話句數${_titleDict[(index + 1).toString()]['conversationSentenceCount']}',
                        subTextBottomLeft: '',
                        onTapFunction: () async {
                          {
                            var responseJSONDecode;
                            try {
                              int doLimit = 1;
                              do {
                                String responseJSON =
                                await APIUtil.getConversationData(
                                    _titleDict[(index + 1).toString()]
                                    ['conversationGroupId']
                                        .toString());
                                print(responseJSON);
                                responseJSONDecode = jsonDecode(responseJSON);
                                if (responseJSONDecode['apiStatus'] !=
                                    'success') {
                                  doLimit += 1;
                                  if (doLimit > 3)
                                    throw Exception('API: ' +
                                        responseJSONDecode[
                                        'apiMessage']); // 只測 3 次
                                  await Future.delayed(Duration(seconds: 1));
                                }
                              } while (
                              responseJSONDecode['apiStatus'] != 'success');
                              print(responseJSONDecode);
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Error: $e'),
                              ));
                            }
                            EasyLoading.dismiss();
                            if (responseJSONDecode['apiStatus'] != 'success') {
                              return;
                            }

                            List<String> contentList = [];
                            List<String> translateList = [];
                            List<String> speakerList = [];
                            List<String> orderList = [];
                            for (var item in responseJSONDecode['data']
                            ['sentence']) {
                              contentList.add(item['topicSentenceContent']);
                              translateList.add(item['topicSentenceChinese']);
                              speakerList.add(item['topicSentenceSpeaker']);
                              orderList
                                  .add(item['topicSentenceOrder'].toString());
                            }
                            AutoRouter.of(context).push(
                                LearningAutoChatTopicRoute(
                                    contentList: [contentList],
                                    translateList: [translateList],
                                    title: _topicName,
                                    speakerList: [speakerList],
                                    subtitle: _titleDict[(index + 1).toString()]
                                    ['conversationTitle'],
                                    orderList: [orderList]));
                          }
                        }, widgetColor: PageTheme.app_theme_blue,
                      ),
                    ),
                  ),
                ),
              ],
            );
          })));
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
