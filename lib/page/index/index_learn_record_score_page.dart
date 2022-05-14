import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class IndexLearnRecordScorePage extends StatefulWidget {
  const IndexLearnRecordScorePage({Key? key}) : super(key: key);

  @override
  _IndexLearnRecordScorePageState createState() =>
      _IndexLearnRecordScorePageState();
}

class _IndexLearnRecordScorePageState extends State<IndexLearnRecordScorePage> {
  List<Widget> listViews = <Widget>[];

  static get items => null;

  static get onChanged => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: PageTheme.learn_record_score_green,
              border: Border.all(
                  width: 1,
                  color:
                  PageTheme.learn_record_score_dark_green),
            ),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 2,
                            color:
                                PageTheme.vocabulary_practice_total_background),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton(
                          iconSize: 50,
                          hint: AutoSizeText(
                            '  詞彙練習 Vocabulary Practice',
                            maxLines: 1,
                            style: TextStyle(color: Colors.black),
                          ),
                          underline: Container(),
                          isExpanded: true,
                          items: items,
                          onChanged: onChanged)),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                AutoSizeText(
                                  '平均測驗分數',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 25, color: PageTheme.learn_record_score_white),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Align(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsets.all(7)),
                                      new CircularPercentIndicator(
                                        backgroundWidth: 15,
                                        radius: 60.0,
                                        lineWidth: 13.0,
                                        animation: true,
                                        animationDuration: 1200,
                                        percent: 0.75,
                                        center: AutoSizeText(
                                          '75',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 50,
                                              color: PageTheme.learn_record_score_white),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.butt,
                                        backgroundColor: PageTheme.percent_indicator_background,
                                        progressColor:
                                        PageTheme.percent_indicator_progress,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 100),
                                        child: AutoSizeText(
                                          '分',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: PageTheme.learn_record_score_white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                AutoSizeText(
                                  '學習進度',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 25, color: PageTheme.learn_record_score_white),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Align(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsets.all(7)),
                                      new CircularPercentIndicator(
                                        backgroundWidth: 15,
                                        radius: 60.0,
                                        lineWidth: 13.0,
                                        animation: true,
                                        animationDuration: 1200,
                                        percent: 0.142,
                                        center: Column(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(15)),
                                            Container(
                                              child: AutoSizeText(
                                                "01  ",
                                                style: TextStyle(
                                                    height: 1,
                                                    fontSize: 40,
                                                    color: PageTheme.learn_record_score_white),
                                              ),
                                            ),
                                            Container(
                                              child: AutoSizeText(
                                                '  /07',
                                                style: TextStyle(
                                                    height: 1,
                                                    fontSize: 30,
                                                    color: PageTheme.learn_record_score_white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.butt,
                                        backgroundColor: PageTheme.percent_indicator_background,
                                        progressColor:
                                        PageTheme.percent_indicator_progress,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 100),
                                          child: AutoSizeText('份',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: PageTheme.learn_record_score_white)))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 250,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: AutoSizeText('Kindergarten 單字集',
                          style: TextStyle(fontSize: 25)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(7)),
                            new CircularPercentIndicator(
                              backgroundWidth: 15,
                              radius: 60.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 1200,
                              percent: 0.75,
                              center: AutoSizeText(
                                '75',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 50, color: PageTheme.learn_record_score_dark_green),
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: PageTheme.percent_indicator_background,
                              progressColor:
                              PageTheme.percent_indicator_progress,
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 100),
                                child: AutoSizeText('%',
                                    style: TextStyle(
                                        fontSize: 20, color: PageTheme.learn_record_score_dark_green)))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(7)),
                            new CircularPercentIndicator(
                              backgroundWidth: 15,
                              radius: 60.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 1200,
                              percent: 0.142,
                              center: Column(
                                children: [
                                  Padding(padding: EdgeInsets.all(15)),
                                  Container(
                                    child: AutoSizeText(
                                      "01  ",
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 40,
                                          color: PageTheme.learn_record_score_dark_green),
                                    ),
                                  ),
                                  Container(
                                    child: AutoSizeText(
                                      '  /35',
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 30,
                                          color: PageTheme.learn_record_score_dark_green),
                                    ),
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: PageTheme.percent_indicator_background,
                              progressColor:
                              PageTheme.percent_indicator_progress,
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 100),
                                child: AutoSizeText('個',
                                    style: TextStyle(
                                        fontSize: 20, color: PageTheme.learn_record_score_dark_green)))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(7)),
                            new CircularPercentIndicator(
                              backgroundWidth: 15,
                              radius: 60.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 1200,
                              percent: 0.142,
                              center: Column(
                                children: [
                                  Padding(padding: EdgeInsets.all(15)),
                                  Container(
                                    child: AutoSizeText(
                                      "01  ",
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 40,
                                          color: PageTheme.learn_record_score_dark_green),
                                    ),
                                  ),
                                  Container(
                                    child: AutoSizeText(
                                      '  /35',
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 30,
                                          color: PageTheme.learn_record_score_dark_green),
                                    ),
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: PageTheme.percent_indicator_background,
                              progressColor:
                              PageTheme.percent_indicator_progress,
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 100),
                                child: AutoSizeText('句',
                                    style: TextStyle(
                                        fontSize: 20, color: PageTheme.learn_record_score_dark_green)))
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: AutoSizeText('完成程度',
                              maxLines: 1, style: TextStyle(fontSize: 20)),
                        ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText('練習單字',
                            maxLines: 1, style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText('練習句型',
                            maxLines: 1, style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 1,color: PageTheme.learn_record_score_dark_green,),
          Container(
            height: 250,
            //color: Colors.yellow,
            child:Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: AutoSizeText('Elementary 單字集',
                          style: TextStyle(fontSize: 25)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(7)),
                            new CircularPercentIndicator(
                              backgroundWidth: 15,
                              radius: 60.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 1200,
                              percent: 0.75,
                              center: AutoSizeText(
                                '75',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 50, color: PageTheme.learn_record_score_dark_green),
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: PageTheme.percent_indicator_background,
                              progressColor:
                              PageTheme.percent_indicator_progress,
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 100),
                                child: AutoSizeText('%',
                                    style: TextStyle(
                                        fontSize: 20, color: PageTheme.learn_record_score_dark_green)))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(7)),
                            new CircularPercentIndicator(
                              backgroundWidth: 15,
                              radius: 60.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 1200,
                              percent: 0.142,
                              center: Column(
                                children: [
                                  Padding(padding: EdgeInsets.all(15)),
                                  Container(
                                    child: AutoSizeText(
                                      "01  ",
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 40,
                                          color: PageTheme.learn_record_score_dark_green),
                                    ),
                                  ),
                                  Container(
                                    child: AutoSizeText(
                                      '  /35',
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 30,
                                          color: PageTheme.learn_record_score_dark_green),
                                    ),
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: PageTheme.percent_indicator_background,
                              progressColor:
                              PageTheme.percent_indicator_progress,
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 100),
                                child: AutoSizeText('個',
                                    style: TextStyle(
                                        fontSize: 20, color: PageTheme.learn_record_score_dark_green)))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(7)),
                            new CircularPercentIndicator(
                              backgroundWidth: 15,
                              radius: 60.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 1200,
                              percent: 0.142,
                              center: Column(
                                children: [
                                  Padding(padding: EdgeInsets.all(15)),
                                  Container(
                                    child: AutoSizeText(
                                      "01  ",
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 40,
                                          color: PageTheme.learn_record_score_dark_green),
                                    ),
                                  ),
                                  Container(
                                    child: AutoSizeText(
                                      '  /35',
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 30,
                                          color: PageTheme.learn_record_score_dark_green),
                                    ),
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: PageTheme.percent_indicator_background,
                              progressColor:
                              PageTheme.percent_indicator_progress,
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 100),
                                child: AutoSizeText('句',
                                    style: TextStyle(
                                        fontSize: 20, color: PageTheme.learn_record_score_dark_green)))
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText('完成程度',
                            maxLines: 1, style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText('練習單字',
                            maxLines: 1, style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText('練習句型',
                            maxLines: 1, style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 250,
            //color: Colors.yellow,
          ),
          //Your Widgets
          //Your Widgets,
          //Your Widgets
        ],
      ),
    );
  }
}
