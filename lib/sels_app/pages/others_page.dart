import 'package:sels_app/sels_app/pages/application_settings_page.dart';

import 'package:sels_app/sels_app/views/button_card_view.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';

class OthersPage extends StatefulWidget {
  const OthersPage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _OthersPageState createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage>
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

  void addAllListData() {
    const int count = 3;
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/user.png',
        titleTxt: '帳戶',
        descripTxt: '帳戶資訊',
        onTapFunction: (){
          AutoRouter.of(context).pushNamed("/accountInfo");
          //Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationSettingsPage()));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/vip.png',
        titleTxt: '訂閱',
        descripTxt: '訂閱會員資格',
        onTapFunction: (){
          AutoRouter.of(context).pushNamed("/purchase");
          //Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationSettingsPage()));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/settings.png',
        titleTxt: '設定',
        descripTxt: '設定',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationSettingsPage()));
        },
      ),
    );
    /*
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/coming_soon.png',
        titleTxt: 'TrainingScreen',
        descripTxt: 'HealthBBBB222',
        onTapFunction: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context) => TrainingScreen(animationController: widget.animationController)));
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        imagePath: 'assets/sels_app/coming_soon.png',
        titleTxt: 'HealthAAA333',
        descripTxt: 'HealthBBBB3333',
        onTapFunction: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context) => MyDiaryScreen(animationController: widget.animationController)));
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
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
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
                                  'Others',
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
