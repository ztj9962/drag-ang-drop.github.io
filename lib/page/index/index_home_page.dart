import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sels_app/page/page_theme.dart';
import 'package:sels_app/page/syllable_practice/syllable_practice_main_page2.dart';
import 'package:sels_app/view/button_card_view.dart';
import 'package:sels_app/view/title_view.dart';

class IndexHomePage extends StatefulWidget {
  const IndexHomePage({Key? key}) : super(key: key);

  @override
  _IndexHomePageState createState() => _IndexHomePageState();
}

class _IndexHomePageState extends State<IndexHomePage> {

  List<Widget> listViews = <Widget>[];

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
    return ListView.builder(
        padding: EdgeInsets.only(
          top: 24,
          bottom: 62,
        ),
        itemCount: listViews.length,
        itemBuilder:  (BuildContext context, int index) {
          return listViews[index];
        }
    );
  }

  void addAllListData() {
    listViews.add(
      const TitleView(
        titleTxt: '英語日常口語練習',
        titleColor: Colors.black,
      ),
    );

    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/vocabulary_practice_total.svg',
        backgroundColor: PageTheme.vocabulary_practice_total_background,
        titleTxt: '一萬常用單字口語句子練習',
        descripTxt: 'English text here',
        onTapFunction: (){
          AutoRouter.of(context).pushNamed("/voabulary_practice_word_index");
        },
      ),
    );

    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/sentence_practice.svg',
        backgroundColor: PageTheme.voabulary_practice_sentence_background,
        titleTxt: '主題式口語句子練習',
        descripTxt: 'English text here',
        onTapFunction: (){
          AutoRouter.of(context).pushNamed("/voabulary_practice_sentence_index");
        },
      ),
    );

    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/customArticle.svg',
        backgroundColor: PageTheme.cutom_article_practice_background,
        titleTxt: '自訂文章句子練習',
        descripTxt: 'English text here',
        onTapFunction: (){
          AutoRouter.of(context).pushNamed("/customArticle_practice_sentence_index");
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

    listViews.add(
      const TitleView(
        titleTxt: '相似字音訓練',
        titleColor: Colors.black,
      ),
    );

    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/minimal_pair.svg',
        backgroundColor: PageTheme.minimal_pair_background,
        titleTxt: '音標練習',
        descripTxt: 'Minimal Pair',
        onTapFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SyllablePracticeMainPage()));
        },
      ),
    );

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