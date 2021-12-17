import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sels_app/sels_app/Pages/WordSetListPage.dart';
import 'package:sels_app/sels_app/OtherViews/buttonCard_view.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';
import 'package:flutter/material.dart';

class WordSetMainPage extends StatefulWidget {
  const WordSetMainPage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _WordSetMainPageState createState() => _WordSetMainPageState();
}

class _WordSetMainPageState extends State<WordSetMainPage>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  Future<void> addAllListData() async {

    EasyLoading.show(status: '正在讀取資料，請稍候......');
    String wordSetClassificationDataJSON = await APIUtil.getWordSetClassificationData();
    var wordSetClassificationData = jsonDecode(wordSetClassificationDataJSON.toString());
    print(wordSetClassificationData);
    EasyLoading.dismiss();

    List<dynamic> wordSetClassification = wordSetClassificationData['data']!;

    int count = wordSetClassification.length;

    wordSetClassification.forEach((value) {
      listViews.add(
        ButtonCardView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController!,
              curve:
              Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!,
          imagePath: 'assets/sels_app/speaking.png',
          titleTxt:  '${value['title']} 單字集',
          descripTxt: '${value['descrip']}，目前共有${value['wordCount']}個單字',
          onTapFunction: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetListPage(learningClassification: '${value['id']}')));
          },
        ),
      );
    });


    setState(() {
      listViews =listViews;
    });








    /*
    const int count = 5;

    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/speaking.png',
        titleTxt: 'Kindergarten 單字集',
        descripTxt: 'Ranking 1~300',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetListPage(learningClassification: '1')));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/speaking.png',
        titleTxt: 'Elementary 單字集',
        descripTxt: 'Ranking 301~1,050',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetListPage(learningClassification: '2')));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/speaking.png',
        titleTxt: 'Middle School 單字集',
        descripTxt: 'Ranking 1,051~3,150',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetListPage(learningClassification: '3')));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/speaking.png',
        titleTxt: 'High School 單字集',
        descripTxt: 'Ranking 3,151~7,000',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetListPage(learningClassification: '4')));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/speaking.png',
        titleTxt: 'College 單字集',
        descripTxt: 'Ranking 7,001~11,000',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetListPage(learningClassification: '5')));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/speaking.png',
        titleTxt: '6 單字集',
        descripTxt: 'Ranking 7,001~11,000',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetListPage(learningClassification: '6')));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/speaking.png',
        titleTxt: '7 單字集',
        descripTxt: 'Ranking 7,001~11,000',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WordSetListPage(learningClassification: '7')));
        },
      ),
    );

     */

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SELSAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('單字集訓練' ),
        ),
        body: Stack(
          children: <Widget>[
            getMainListViewUI()
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: SELSAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: SELSAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Home',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: SELSAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: SELSAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
