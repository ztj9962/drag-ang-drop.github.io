import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class ChatTopicPracticeIndexPage extends StatefulWidget {
  const ChatTopicPracticeIndexPage({Key? key}) : super(key: key);

  @override
  _ChatTopicPracticeIndexPageState createState() =>
      _ChatTopicPracticeIndexPageState();
}

class _ChatTopicPracticeIndexPageState
    extends State<ChatTopicPracticeIndexPage> {
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
          child: ListView.builder(
              padding: EdgeInsets.only(
                top: 24,
                bottom: 62,
              ),
              itemCount: _listViews.length,
              itemBuilder: (BuildContext context, int index) {
                return _listViews[index];
              }),
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
        String responseJSON = await APIUtil.getChatTopicData();
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

      responseJSONDecode['data'].forEach((key, value) {
        //print(key);
        //print(value);

        listViews.add(TitleView(
          titleTxt: '${key}',
          titleColor: Colors.black,
        ));

        var parser = EmojiParser();

        listViews.add(Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: List.generate(value['title']!.length, (index) {
              if (index == 0) return Container();
              //return Text(value['title'][index]);
              //print(value['title'][index]);
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(value['appEndColor'][index])
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(value['appStartColor'][index]),
                            HexColor(value['appEndColor'][index]),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 54, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              value['title'][index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: PageTheme.white,
                              ),
                              maxLines: 1,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      //AutoRouter.of(context).push(VocabularyPracticeSentenceLearnAutoRoute(topicName:value['title'][index]));

                                      AutoRouter.of(context).push(
                                          ChatTopicPracticeConversationListRoute(
                                              topicName: value['title'][index]
                                              ));
                                    },
                                    //onTap: sentenceTypeListData!.onTapFunction,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: PageTheme.nearlyWhite,
                                        shape: BoxShape.rectangle, // 矩形
                                        borderRadius: new BorderRadius.circular(
                                            (20.0)), // 圓角度
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: PageTheme.nearlyBlack
                                                  .withOpacity(0.4),
                                              offset: Offset(8.0, 8.0),
                                              blurRadius: 8.0),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          '對話練習',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: HexColor(
                                                value['appEndColor'][index]),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                /*Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      AutoRouter.of(context).push(
                                          LearningManualVocabularyPracticeSentenceRoute(
                                              topicName: value['title']
                                              [index]));
                                    },
                                    //onTap: sentenceTypeListData!.onTapFunction,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: PageTheme.nearlyWhite,
                                        shape: BoxShape.rectangle, // 矩形
                                        borderRadius: new BorderRadius.circular(
                                            (20.0)), // 圓角度
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: PageTheme.nearlyBlack
                                                  .withOpacity(0.4),
                                              offset: Offset(8.0, 8.0),
                                              blurRadius: 8.0),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          '手動',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: HexColor(
                                                value['appEndColor'][index]),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: PageTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: 12,
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      //child: Image.asset(value['imagePath'][index]),
                      //child: Image.asset('assets/sels_app/' + value['appIcon'][index] + '.png'),
                      child: AutoSizeText(
                        parser.get(value['appEmojiName'][index]).code,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  )
                ],
              );
            })));
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