
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sels_app/sels_app/Pages/PhoneticExercisesHistoryPage.dart';
import 'package:sels_app/sels_app/Pages/PhoneticExercisesLearnManualPage.dart';
import 'package:sels_app/sels_app/Pages/PhoneticExercisesLearnAutoPage.dart';
import 'package:sels_app/sels_app/Pages/PhoneticExercisesTopicListPage.dart';
import 'package:sels_app/sels_app/OtherViews/buttonCard_view.dart';
import 'package:sels_app/sels_app/OtherViews/title_view.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';
import 'package:sels_app/sels_app/OtherViews/class_list_view.dart';
import 'package:flutter/material.dart';

class PhoneticExercisesMainPage extends StatefulWidget {
  const PhoneticExercisesMainPage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _PhoneticExercisesMainPageState createState() => _PhoneticExercisesMainPageState();
}

class _PhoneticExercisesMainPageState extends State<PhoneticExercisesMainPage>
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



  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  void addAllListData() {
    const int count = 6;

    /* Listen & Speak */
    listViews.add(
      TitleView(
        titleTxt: '主題式發音練習',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        subTxt: '查看全部',
        subVisivle: false,
        subFunction: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesTopicListPage(animationController: widget.animationController)));
        },
      ),
    );

    listViews.add(
      SentenceTypesListView(
        //showIndex: '',
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 2, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
    /* Listen & Speak */

    listViews.add(
      TitleView(
        titleTxt: '發音練習',
        subTxt: 'All',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
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
        titleTxt: '發音訓練(自動)',
        descripTxt: '藉由說話來校正發音',
        onTapFunction: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnAutoPage(sentencesIDData:[11, 22, 641491])));
          Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnAutoPage()));
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
        titleTxt: '發音訓練(手動)',
        descripTxt: '藉由說話來校正發音',
        onTapFunction: (){
          /*
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
                pageBuilder: (_,__,___) => PhoneticExercisesLearnManualPage(),
            )
          );

           */

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PhoneticExercisesLearnManualPage()
              )
          );


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
        titleTxt: '發音訓練(已儲存的紀錄)',
        descripTxt: '藉由說話來校正發音',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesHistoryPage()));
        },
      ),
    );

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
          title: Text('Empty' ),
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
