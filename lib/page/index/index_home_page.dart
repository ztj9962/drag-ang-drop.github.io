import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:alicsnet_app/view/outlined_button_card_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/view/title_view.dart';

class IndexHomePage extends StatefulWidget {
  const IndexHomePage({Key? key}) : super(key: key);

  @override
  _IndexHomePageState createState() => _IndexHomePageState();
}

class _IndexHomePageState extends State<IndexHomePage> {
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
          AutoRouter.of(context)
              .pushNamed("/chat_topic_practice_index_page");
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
        imagePath: 'assets/icon/minimal_pair_02.svg',
        titleText: 'Pronunciation - Minimal pairs',
        descripText: '相似字音練習',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/minimal_pair_index");
        },
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/minimal_pair_02.svg',
        titleText: 'IPA Grapheme Practice',
        descripText: 'IPA字素練習',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/ipa_grapheme_pair_index_page");
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
