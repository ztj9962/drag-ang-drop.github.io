import 'package:sels_app/sels_app/pages/phonetic_exercises_learn_manual_page.dart';
import 'package:sels_app/sels_app/pages/phonetic_exercises_learn_auto_page.dart';

import 'package:sels_app/sels_app/sels_app_theme.dart';
import 'package:sels_app/sels_app/models/sentence_types_list_data.dart';
import 'package:sels_app/main.dart';
import 'package:flutter/material.dart';


class SentenceTypesListView extends StatefulWidget {
  const SentenceTypesListView(
      {Key? key, this.showIndex = '', this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final String showIndex;
  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;


  @override
  _SentenceTypesListViewState createState() => _SentenceTypesListViewState();
}

class _SentenceTypesListViewState extends State<SentenceTypesListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  //List sentenceTypesListData = SentenceTypesListData.getData();
  List sentenceTypesListData = [];
  //List<SentenceTypesListData> sentenceTypesListData = SentenceTypesListData.tabIconsList;

  @override
  void initState() {
    getData();
    //sentenceTypesListData = SentenceTypesListData.getSentenceTypesListData(key:widget.showIndex);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    List sentenceTypesListData_ = (await SentenceTypesListData.getSentenceTypesListData(key:widget.showIndex))!;
    setState(() {

      sentenceTypesListData = sentenceTypesListData_;
    });

    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*
    if(widget.showIndex != null){
      return AnimatedBuilder(
        animation: widget.mainScreenAnimationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: widget.mainScreenAnimation!,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
              child: Container(
                height: 216,
                width: double.infinity,
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 16, left: 16),
                  itemCount: (sentenceTypesListData[widget.showIndex!].length - 1),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    index = index + 1;
                    final int count =
                    (sentenceTypesListData[widget.showIndex!].length - 1) > 10 ? 10 : (sentenceTypesListData[widget.showIndex!].length - 1);
                    final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController!,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn)));
                    animationController?.forward();
                    return SentenceTypesView(
                      //sentenceTypesListData: sentenceTypesListData[index],
                      sentenceTypesListData: sentenceTypesListData[widget.showIndex!][index],
                      animation: animation,
                      animationController: animationController!,
                    );



                  },
                ),
              ),
            ),
          );
        },
      );

    }
     */

    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: sentenceTypesListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {


                  final int count =
                  sentenceTypesListData.length > 10 ? 10 : sentenceTypesListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();
                  return SentenceTypesView(
                    //sentenceTypesListData: sentenceTypesListData[index],
                    showIndex: widget.showIndex,
                    sentenceTypesListData: sentenceTypesListData[index],
                    animation: animation,
                    animationController: animationController!,
                  );



                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class SentenceTypesView extends StatelessWidget {
  const SentenceTypesView(
      {Key? key, this.showIndex = '', this.sentenceTypesListData, this.animationController, this.animation})
      : super(key: key);

  final String showIndex;
  final SentenceTypesListData? sentenceTypesListData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: 200,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(sentenceTypesListData!.endColor)
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(sentenceTypesListData!.startColor),
                            HexColor(sentenceTypesListData!.endColor),
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
                            Text(
                              sentenceTypesListData!.titleTxt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: SELSAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: SELSAppTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      sentenceTypesListData!.descripTxt,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontFamily: SELSAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        color: SELSAppTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*
                            GestureDetector(
                              onTap: (){
                                if(showIndex == ''){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnManualPage(topicClass:sentenceTypesListData!.titleTxt)));
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnManualPage(topicName:sentenceTypesListData!.titleTxt)));
                                }
                              },
                              //onTap: sentenceTypesListData!.onTapFunction,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: SELSAppTheme.nearlyWhite,
                                  shape: BoxShape.rectangle, // 矩形
                                  borderRadius: new BorderRadius.circular((20.0)), // 圓角度
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: SELSAppTheme.nearlyBlack.withOpacity(0.4),
                                        offset: Offset(8.0, 8.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.launch,
                                    color: HexColor(sentenceTypesListData!.endColor),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            */
                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: (){
                                      if(showIndex == ''){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnAutoPage(topicClass:sentenceTypesListData!.titleTxt)));
                                      } else {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnAutoPage(topicName:sentenceTypesListData!.titleTxt)));
                                      }
                                    },
                                    //onTap: sentenceTypesListData!.onTapFunction,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: SELSAppTheme.nearlyWhite,
                                        shape: BoxShape.rectangle, // 矩形
                                        borderRadius: new BorderRadius.circular((20.0)), // 圓角度
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: SELSAppTheme.nearlyBlack.withOpacity(0.4),
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
                                            color: HexColor(sentenceTypesListData!.endColor),
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnManualPage(topicClass:sentenceTypesListData!.titleTxt)));
                                      } else {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneticExercisesLearnManualPage(topicName:sentenceTypesListData!.titleTxt)));
                                      }
                                    },
                                    //onTap: sentenceTypesListData!.onTapFunction,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: SELSAppTheme.nearlyWhite,
                                        shape: BoxShape.rectangle, // 矩形
                                        borderRadius: new BorderRadius.circular((20.0)), // 圓角度
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: SELSAppTheme.nearlyBlack.withOpacity(0.4),
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
                                            color: HexColor(sentenceTypesListData!.endColor),
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
                        color: SELSAppTheme.nearlyWhite.withOpacity(0.2),
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
                      child: Image.asset(sentenceTypesListData!.imagePath),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
