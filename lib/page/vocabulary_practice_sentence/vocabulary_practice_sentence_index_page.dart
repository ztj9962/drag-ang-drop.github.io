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
          title: AutoSizeText(
            '生活英語情境',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
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
        showIndex: 'Animals',
      ),
    );
    
    listViews.add(
      SentenceTypeListView(
        showIndex: 'Appearance',
      ),
    );

    listViews.add(
      SentenceTypeListView(
        showIndex: 'Communication'
      ),
    );

    listViews.add(
      SentenceTypeListView(
        showIndex: 'Culture',
      ),
    );

    listViews.add(
      SentenceTypeListView(
        showIndex: 'Food_and_drink',
      ),
    );

    listViews.add(
      SentenceTypeListView(
        showIndex: 'Functions',
      ),
    );

    listViews.add(
      SentenceTypeListView(
        showIndex: 'Health',
      ),
    );

    listViews.add(
      SentenceTypeListView(
        showIndex: 'Homes_and_buildings',
      ),
    );

    listViews.add(
      SentenceTypeListView(
        showIndex: 'Leisure',
      ),
    );

    listViews.add(
      SentenceTypeListView(
        showIndex: 'Notions',
      ),
    );
/*
    listViews.add(
      TitleView(
        titleTxt: 'People',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 11, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      SentenceTypeListView(
        showIndex: 'People',
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 12, 1.0, curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Politics and society',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 11, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      SentenceTypeListView(
        showIndex: 'Politics_and_society',
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 12, 1.0, curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Science and technology',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 11, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      SentenceTypeListView(
        showIndex: 'Science_and_technology',
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 12, 1.0, curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Sport',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 11, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      SentenceTypeListView(
        showIndex: 'Sport',
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 12, 1.0, curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'The natural world',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 11, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      SentenceTypeListView(
        showIndex: 'The_natural_world',
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 12, 1.0, curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Time and space',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 11, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      SentenceTypeListView(
        showIndex: 'Time_and_space',
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 12, 1.0, curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Travel',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval((1 / count) * 11, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      SentenceTypeListView(
        showIndex: 'Travel',
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 12, 1.0, curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
    
 */







  }

}