import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:alicsnet_app/view/outlined_button_card_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class IndexHomePage extends StatefulWidget {
  const IndexHomePage({Key? key}) : super(key: key);

  @override
  _IndexHomePageState createState() => _IndexHomePageState();
}

class _IndexHomePageState extends State<IndexHomePage> {
  bool get isWeb => kIsWeb;

  List<Widget> listViews = <Widget>[];
  bool? _isSignin = false;

  @override
  void initState() {
    addAllListData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: ListView.builder(
          padding: EdgeInsets.only(
            top: 24,
            bottom: 62,
          ),
          itemCount: listViews.length,
          itemBuilder: (BuildContext context, int index) {
            return listViews[index];
          }),
    );
  }

  void addAllListData() {
    var titleTextSizeGroup = AutoSizeGroup();
    var descripTextSizeGroup = AutoSizeGroup();

    listViews.add(
      const TitleView(
        titleTxt: '英語日常口語練習',
        titleColor: Colors.black,
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        imagePath: 'assets/icon/vocabulary_practice_word_02.svg',
        titleText: 'Common words with examples',
        descripText: '一萬個最常用的單字和例句',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/voabulary_practice_word_index");
        },
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/vocabulary_practice_topics.svg',
        titleText: 'Sentences based on chat topics',
        descripText: '生活英語情境',
        titleTextSizeGroup: titleTextSizeGroup,
        onTapFunction: () async {
          if(isWeb){
            AutoRouter.of(context).pushNamed("/chat_topic_practice_index_page");
          }else{
            AutoRouter.of(context).pushNamed("/chat_topic_practice_class_mobile_page");
          }
        },
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/customArticle_02.svg',
        titleText: 'User document input',
        descripText: '學習者提供教材',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context)
              .pushNamed("/customArticle_practice_sentence_index");
        },
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/pronunciation.svg',
        titleText: 'Pronunciation Practice',
        descripText: '發音練習',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/index_pronunciation_page");
        },
      ),
    );
    
    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/sentence_analysis.svg',
        titleText: 'Sentence Analysis',
        descripText: '句型分析',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context)
              .push(SentenceAnalysisIndexRoute(analysisor: ''));
        },
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/setting.svg',
        titleText: 'Summary Report',
        descripText: '總結報告',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context)
              .push(LearningAutoGenericSummaryReportRoute(summaryReportData:{'ttsRateString': '2倍', 'startTime': '2023-10-24 15:56:24', 'sentenceQuestionArray': ['creepier mine i wiill creepier minecreepier mine creepier mine hleo','you will be explodeminecreepier mine','cosmic minecreepier minemind','cosmicminecreepier mine mind','cminecreepier mineosmic miminecreepier mineminecreepier mineminecreepier minemminecreepier mineinecreepier minend','cosmminecreepier mineminecreepierminecreepier mine mineic mind'], 'sentenceQuestionIPAArray': ['creepier* maɪn','bing chin ling','mouth death','cosmic mind','cosmic mind','cosmic mind'], 'sentenceQuestionErrorArray': [['creepier', 'mine'],['explode'],['ssslloud'],['ssslloud'],['ssslloud'],['ssslloud']], 'sentenceQuestionChineseArray': ['','','','','','',''], 'sentenceAnswerArray': ['creeper','timmy will expert','fosmic mine','fosmic mine','fosmic mine','fosmic mine'], 'sentenceAnswerIPAArray': ["creeper*",'','','','',''], 'sentenceAnswerErrorArray': [['creeper'],['exclose'],['sosmic'],['sosmic'],['sosmic'],['sosmic']], 'scoreArray': [72,50,50,50,50,50], 'secondsArray': [8,9,9,50,50,50], 'userAnswerRate': [0.125,0.222,0.333,50,50,50], 'endTime': '2023-10-24 15:56:40'}));
        },
      ),
    );

    /*
    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/use_you_own_text.svg',
        backgroundColor: PageTheme.use_you_own_text_background,
        titleTxt: '提供教材',
        descripTxt: 'English text here',
        onTapFunction: (){
          print('sdasdsa');
        },
      ),
    );
     */

    /*
    listViews.add(
      const TitleView(
        titleTxt: '文法校正',
        titleColor: Colors.black,
      ),
    );

    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/grammar_correction.svg',
        backgroundColor: PageTheme.grammar_correction_background,
        titleTxt: '文法校正',
        descripTxt: 'Grammar Correction',
        onTapFunction: (){
          print('sdasdsa');
        },
      ),
    );
     */
  }
}
