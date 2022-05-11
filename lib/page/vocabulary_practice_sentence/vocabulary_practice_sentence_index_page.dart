import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_auto_page.dart';
import 'package:alicsnet_app/page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_manual_page.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/view/button_card_view.dart';
import 'package:alicsnet_app/view/sentence_type_list_view.dart';
import 'package:alicsnet_app/view/title_view.dart';

class VocabularyPracticeSentenceIndexPage extends StatefulWidget {
  const VocabularyPracticeSentenceIndexPage({Key? key}) : super(key: key);

  @override
  _VocabularyPracticeSentenceIndexPageState createState() => _VocabularyPracticeSentenceIndexPageState();
}

class _VocabularyPracticeSentenceIndexPageState extends State<VocabularyPracticeSentenceIndexPage> {

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PageTheme.voabulary_practice_sentence_background,
        title: Column(
          children: <Widget>[
            Text(
              '口語句子練習',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: 3.0,
                color: Color(0xFFFEFEFE),
              ),
            ),
            Text(
              'Sentence Voabulary Practice',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 3.0,
                color: Color(0xFFFEFEFE),
              ),
            ),
          ],
        ),


      ),
      body: ListView.builder(
          padding: EdgeInsets.only(
            top: 24,
            bottom: 62,
          ),
          itemCount: listViews.length,
          itemBuilder:  (BuildContext context, int index) {
            return listViews[index];
          }
      )
    );
  }


  void addAllListData() {
    /*
    listViews.add(
      const TitleView(
        titleTxt: '發音練習',
        titleColor: PageTheme.voabulary_practice_sentence_background,
      ),
    );

    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/sentence_practice.svg',
        backgroundColor: PageTheme.voabulary_practice_sentence_background,
        titleTxt: '發音練習(自動)',
        descripTxt: 'SubTitle text here',
        onTapFunction: (){
          AutoRouter.of(context).push(VocabularyPracticeSentenceLearnAutoRoute());
        },
      ),
    );
    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/sentence_practice.svg',
        backgroundColor: PageTheme.voabulary_practice_sentence_background,
        titleTxt: '發音練習(手動)',
        descripTxt: 'SubTitle text here',
        onTapFunction: (){
          AutoRouter.of(context).push(VocabularyPracticeSentenceLearnManualRoute());
        },
      ),
    );
    */

    listViews.add(
      const TitleView(
        titleTxt: '主題式發音練習',
        titleColor: PageTheme.voabulary_practice_sentence_background,
      ),
    );

    listViews.add(
      SentenceTypeListView(
        //showIndex: '',
      ),
    );
  }

}