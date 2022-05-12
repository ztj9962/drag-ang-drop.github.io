import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/model/sentence_type_list_data.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/hexcolor_util.dart';


class SentenceTypeListView extends StatefulWidget {
  const SentenceTypeListView(
      {Key? key, this.showIndex = ''})
      : super(key: key);

  final String showIndex;


  @override
  _SentenceTypeListViewState createState() => _SentenceTypeListViewState();
}

class _SentenceTypeListViewState extends State<SentenceTypeListView>
    with TickerProviderStateMixin {
  //List sentenceTypeListData = SentenceTypeListData.getData();
  List sentenceTypeListData = [];
  //List<SentenceTypeListData> sentenceTypeListData = SentenceTypeListData.tabIconsList;

  @override
  void initState() {
    getData();
    //sentenceTypeListData = SentenceTypeListData.getSentenceTypeListData(key:widget.showIndex);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    List sentenceTypeListData_ = (await SentenceTypeListData.getSentenceTypeListData(key:widget.showIndex))!;
    setState(() {

      sentenceTypeListData = sentenceTypeListData_;
    });

    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: List.generate(sentenceTypeListData.length, (index) =>
            SentenceTypeView(
              showIndex: widget.showIndex,
              sentenceTypeListData: sentenceTypeListData[index],
            )
        )
    );
  }
}

class SentenceTypeView extends StatelessWidget {
  const SentenceTypeView(
      {Key? key, this.showIndex = '', this.sentenceTypeListData})
      : super(key: key);

  final String showIndex;
  final SentenceTypeListData? sentenceTypeListData;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: HexColor(sentenceTypeListData!.endColor)
                        .withOpacity(0.6),
                    offset: const Offset(1.1, 4.0),
                    blurRadius: 8.0),
              ],
              gradient: LinearGradient(
                colors: <HexColor>[
                  HexColor(sentenceTypeListData!.startColor),
                  HexColor(sentenceTypeListData!.endColor),
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
                    sentenceTypeListData!.titleTxt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: PageTheme.white,
                    ),
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    sentenceTypeListData!.descripTxt,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: PageTheme.white,
                    ),
                    maxLines: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: (){
                            if(showIndex == ''){
                              AutoRouter.of(context).push(VocabularyPracticeSentenceLearnAutoRoute(topicClass:sentenceTypeListData!.titleTxt));
                            } else {
                              AutoRouter.of(context).push(VocabularyPracticeSentenceLearnAutoRoute(topicName:sentenceTypeListData!.titleTxt));
                            }
                          },
                          //onTap: sentenceTypeListData!.onTapFunction,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: PageTheme.nearlyWhite,
                              shape: BoxShape.rectangle, // 矩形
                              borderRadius: new BorderRadius.circular((20.0)), // 圓角度
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: PageTheme.nearlyBlack.withOpacity(0.4),
                                    offset: Offset(8.0, 8.0),
                                    blurRadius: 8.0),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                '自動',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor(sentenceTypeListData!.endColor),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: (){
                            if(showIndex == ''){
                              AutoRouter.of(context).push(VocabularyPracticeSentenceLearnManualRoute(topicClass:sentenceTypeListData!.titleTxt));
                            } else {
                              AutoRouter.of(context).push(VocabularyPracticeSentenceLearnManualRoute(topicName:sentenceTypeListData!.titleTxt));
                            }
                          },
                          //onTap: sentenceTypeListData!.onTapFunction,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: PageTheme.nearlyWhite,
                              shape: BoxShape.rectangle, // 矩形
                              borderRadius: new BorderRadius.circular((20.0)), // 圓角度
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: PageTheme.nearlyBlack.withOpacity(0.4),
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
                                  color: HexColor(sentenceTypeListData!.endColor),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

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
          top: 12,
          left: 12,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Image.asset(sentenceTypeListData!.imagePath),
          ),
        )
      ],
    );
  }
}