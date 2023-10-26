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
/*
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
              .push(LearningAutoGenericSummaryReportRoute(summaryReportData:{"ttsRateString":"一般","startTime":"2023-10-25 16:38:29","sentenceQuestionArray":["you may call upon us as needed","we came upon them in new york","we came upon them in new york","shall we go","shall i call christopher back","shall i buy some for him","the ball is with you","where's my ball","you like balls","why wouldn't we make corn better","corn doesn't grow here","corn doesn't grow here","the bird is in its nest","the bird is in its nest","away from his nest","every old bird could fly away from his nest"],"sentenceQuestionIPAArray":["ju meɪ kɔl əˈpɑn ˈjuˈɛs ɛz ˈnidɪd","wi keɪm əˈpɑn ðɛm ɪn nu jɔrk","wi keɪm əˈpɑn ðɛm ɪn nu jɔrk","ʃæl wi goʊ","ʃæl aɪ kɔl ˈkrɪstəfər bæk","ʃæl aɪ baɪ səm fər ɪm","ðə bɔl ɪz wɪθ ju","wɛrz maɪ bɔl","ju laɪk bɔlz","waɪ ˈwʊdənt wi meɪk kɔrn ˈbɛtər","kɔrn ˈdəzənt groʊ hir","kɔrn ˈdəzənt groʊ hir","ðə bərd ɪz ɪn ɪts nɛst","ðə bərd ɪz ɪn ɪts nɛst","əˈweɪ frəm hɪz nɛst","ˈɛvəri oʊld bərd kʊd flaɪ əˈweɪ frəm hɪz nɛst"],"sentenceQuestionErrorArray":[["you","may","upon","us","as","needed"],["came","upon"],["we","came","upon","them"],["shall","we","go"],["shall","christopher"],["shall","some","for","him"],["the","ball"],["where's","ball"],[],["corn"],["corn","doesn't","grow"],["corn"],[],[],["nest"],[]],"sentenceQuestionChineseArray":["您可以根據需要致電我們。","我們在紐約遇到了他們。","我們在紐約遇到了他們。","我們去嗎？","我可以給克里斯托弗回電話嗎？","我要買一些給他嗎？","球就在你身邊。","我的球呢？","你喜歡球。","我們為什麼不讓玉米變得更好？","這裡不種玉米。","這裡不種玉米。","鳥在它的巢裡。","鳥在它的巢裡。","原句:Every old bird could fly away from his nest.","每隻老鳥都能飛離巢穴。"],"sentenceAnswerArray":["give me a call open jose smith","we can offend them in new york","between the fountain in new york","shamiko","should i call crystal back","should i buy something","nepal is with you","where is my phone","you like balls","why wouldn't we make phone better","quarters and coral here","paul doesn't grow here","the bird is in its nest","the bird is in its nest","away from his neck","every old bird could fly away from his nest"],"sentenceAnswerIPAArray":["gɪv mi ə kɔl ˈoʊpən ˌhoʊˈzeɪ smɪθ","wi kən əˈfɛnd ðɛm ɪn nu jɔrk","bɪtˈwin ðə ˈfaʊntən ɪn nu jɔrk","shamiko*","ʃʊd aɪ kɔl ˈkrɪstəl bæk","ʃʊd aɪ baɪ ˈsəmθɪŋ","nəˈpɔl ɪz wɪθ ju","wɛr ɪz maɪ foʊn","ju laɪk bɔlz","waɪ ˈwʊdənt wi meɪk foʊn ˈbɛtər","kˈwɔrtərz ənd ˈkɔrəl hir","pɔl ˈdəzənt groʊ hir","ðə bərd ɪz ɪn ɪts nɛst","ðə bərd ɪz ɪn ɪts nɛst","əˈweɪ frəm hɪz nɛk","ˈɛvəri oʊld bərd kʊd flaɪ əˈweɪ frəm hɪz nɛst"],"sentenceAnswerErrorArray":[["give","me","a","open","jose","smith"],["can","offend"],["between","the","fountain"],["shamiko"],["should","crystal"],["should","something"],["nepal"],["where","is","phone"],[],["phone"],["quarters","and","coral"],["paul"],[],[],["neck"],[]],"scoreArray":[39,82,55,22,83,66,81,66,100,90,35,87,100,100,91,100],"secondsArray":[29,9,9,9,9,9,9,8,8,9,9,10,10,9,9,10],"userAnswerRate":[0.2413793103448276,0.7777777777777778,0.6666666666666666,0.1111111111111111,0.5555555555555556,0.4444444444444444,0.4444444444444444,0.5,0.375,0.6666666666666666,0.4444444444444444,0.4,0.6,0.6666666666666666,0.4444444444444444,0.9],"endTime":"2023-10-25 16:42:37"}
          ));
        },
      ),
    );
*/
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
