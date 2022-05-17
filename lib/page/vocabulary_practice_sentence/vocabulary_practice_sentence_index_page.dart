import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
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
        backgroundColor: PageTheme.app_theme_black,
        title: Column(
          children: <Widget>[
            AutoSizeText(
              'Sentences based on chat topics',
              maxLines: 1,
            ),
            AutoSizeText(
              '生活英語情境',
              maxLines: 1,
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
        titleColor: PageTheme.app_theme_blue,
      ),
    );

    listViews.add(
      ButtonCardView(
        imagePath: 'assets/icon/sentence_practice.svg',
        backgroundColor: PageTheme.app_theme_blue,
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
        backgroundColor: PageTheme.app_theme_blue,
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
        titleColor: PageTheme.app_theme_blue,
      ),
    );

    listViews.add(
      SentenceTypeListView(
        //showIndex: '',
      ),
    );
  }

}