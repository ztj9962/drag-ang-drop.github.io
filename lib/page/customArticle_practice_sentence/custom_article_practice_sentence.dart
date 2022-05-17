import 'dart:async';
import 'dart:convert';
import 'dart:math';import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/model/sentence_example_data.dart';
import 'package:alicsnet_app/page/login/fade_animation.dart';
import 'package:alicsnet_app/util/api_util.dart';

import 'package:alicsnet_app/page/page_theme.dart';

class CustomArticlePracticeSentenceIndexPage extends StatefulWidget {
  const CustomArticlePracticeSentenceIndexPage({Key? key}) : super(key: key);

  @override
  _CustomArticlePracticeSentenceIndexPage createState() =>
      _CustomArticlePracticeSentenceIndexPage();
}

class _CustomArticlePracticeSentenceIndexPage
    extends State<CustomArticlePracticeSentenceIndexPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _controller = new TextEditingController();
  final r = RegExp(r'[a-zA-Z]+');
  String userId ="";
  String text = "";
  int maxLength = 500;
  List sentencelist = [];
  List sentenceIPAlist = [];
  List analyzeResult = [];
  bool isloading = false;
  bool practice_auto = false;
  int inputWordCount = 0;
  List<Widget> topicList = [];

  late Image image ;
  @override
  void initState() {
    super.initState();
    creatTopic();
    userId = FirebaseAuth.instance.currentUser!.uid;
    //getUid();
    //createTopic();
  }

  @override
  void dispose() {
    //SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  //創建topiWidget
  void creatTopic() async{

    sentenceExampleData.sentence.keys.forEach((key) {
      topicList.add(
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            onPressed: () {
              int count = 0;
              for (var i = 0;
                  i < sentenceExampleData.sentence[key].split(" ").length;
                  i++) {
                if (r.hasMatch(
                    sentenceExampleData.sentence[key].split(" ")[i])) {
                  count += 1;
                }
              }
              setState(() {
                inputWordCount = count;
              });
              _controller.text = sentenceExampleData.sentence[key];
            },
            child: Text('${key}'),
            style: ElevatedButton.styleFrom(
                primary: PageTheme.app_theme_blue),
          ),
        ),
      );
    });
  }
  //將輸入文章做作文法校正、分句、文章分析
  void addSentence() async {
    print(userId);
    print(_controller.text);
    setState(() {
      sentenceIPAlist = [];
      isloading = true;
      sentencelist = [];
    });
    List list = [];
    List ipa = [];
    List analyzeResponse =[];
    if (_controller.text != "") {
      String grammar_response = await APIUtil.checkGrammar(_controller.text);
      analyzeResponse = await APIUtil.getStatitics(grammar_response,userId);
      print(analyzeResponse);
      var checkedGrammar = jsonDecode(grammar_response);
      if (checkedGrammar['apiStatus'] == 'success') {
        list = await APIUtil.getSentenceSegmentation(
            checkedGrammar['data']['sentenceTextChecked']);
      } else {
        final text = "文章內容包含除英文之外的字元";
        final snackbar = SnackBar(
          content: Text(text),
        );
        _scaffoldKey.currentState?.showSnackBar(snackbar);
      }
    }
    ipa = await APIUtil.getSentenceIPA(list);

    image =  Image.network('https://sels.nkfust.edu.tw/api/alics/getPhoto?user_id=${userId}&index=${new Random().nextInt(100)}');
    final Completer<void> completer = Completer<void>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool syncCall)=> completer.complete()));
    await completer.future;
    if (mounted) {
      setState(() {
        sentenceIPAlist = ipa;
        isloading = false;
        sentencelist = list;
      });

    }


    /*if(await getPhoto()){
      setState(() {
        sentenceIPAlist = ipa;
        isloading = false;
        sentencelist = list;
      });
    }*/
  }

  Future<bool> getPhoto() async{
    imageCache?.clear();
    Image test =  Image.network('https://sels.nkfust.edu.tw/api/alics/getPhoto?user_id=${userId}');
    final Completer<void> completer = Completer<void>();
    test.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool syncCall)=> completer.complete()));
    await completer.future;
    if (mounted) {
      image = test;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white, //Color(0xffffdef5),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: PageTheme.app_theme_black,
            title: Column(
              children: <Widget>[
                AutoSizeText(
                  'User document input',
                  maxLines: 1,
                ),
                AutoSizeText(
                  '學習者提供教材',
                  maxLines: 1,
                ),
              ],
            ),
        ),
        body: ListView(
          padding: EdgeInsets.only(
            top: 24,
            bottom: 62,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text("Example Article",
                      style: TextStyle(
                          color: PageTheme.cutom_article_practice_background,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 3,
                  margin: EdgeInsets.only(right: 10, left: 10, top: 5),
                  decoration: BoxDecoration(
                      color: PageTheme.cutom_article_practice_background,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ],
            ),
            Container(
                height: 20,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: topicList,
                )),
            Container(
                margin: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 5),
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 2,
                    color:
                        PageTheme.cutom_article_practice_background.withOpacity(0.5),
                  ),
                ),
                child: ListView(
                  children: [
                    TextField(
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "請輸入一段文章",
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        minLines: 1,
                        controller: _controller,
                        onChanged: (String newVal) {
                          int count = 0;
                          String pastText = "";
                          for (var i = 0; i < newVal.split(" ").length; i++) {
                            if (r.hasMatch(newVal.split(' ')[i])) {
                              count += 1;
                            }
                          }
                          if (count <= maxLength) {
                            setState(() {
                              inputWordCount = count;
                            });
                            text = newVal;
                          } else {
                            for (var i = 0; i < 500; i++) {
                              pastText += newVal.split(' ')[i] + " ";
                            }
                            _controller.text = pastText;
                            setState(() {
                              inputWordCount = 500;
                            });
                            _controller.value = new TextEditingValue(
                                text: text,
                                selection: new TextSelection(
                                    baseOffset: maxLength,
                                    extentOffset: maxLength,
                                    affinity: TextAffinity.downstream,
                                    isDirectional: false),
                                composing:
                                    new TextRange(start: 0, end: maxLength));
                            _controller.text = text;
                          }
                        })
                  ],
                )),
            Row(
              children: [
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    '${inputWordCount}/500',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20, bottom: 30),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  isloading
                      ? Container(
                          padding: EdgeInsets.all(3),
                          height: 40,
                          width: 100,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: PageTheme.cutom_article_practice_background,
                            strokeWidth: 4.0,
                          )))
                      : GestureDetector(
                          onTap: () {
                            addSentence();
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color: PageTheme.cutom_article_practice_background,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: const Offset(0, 1),
                                  ),
                                ]),
                            child: Center(
                                child: Text(
                              "提交",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                ],
              ),
            ),
           // BarChartSample3(),
            if (sentencelist.length >= 1 && !isloading)
              FadeAnimation(1, Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text("Article Analyze",
                        style: TextStyle(
                            color: PageTheme.cutom_article_practice_background,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    height: 3,
                    margin: EdgeInsets.only(right: 10, left: 10, top: 3,bottom: 10),
                    decoration: BoxDecoration(
                        color: PageTheme.cutom_article_practice_background,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20,left: 20),
                    child: image,
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      children: [
                        Text("Sentence",
                            style: TextStyle(
                                color: PageTheme.cutom_article_practice_background,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Expanded(child: Container()),
                        SizedBox(
                          height: 30,
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () async {
                                if(!practice_auto){
                                  AutoRouter.of(context).push(CustomArticlePracticeSentenceLearnManualRoute(questionList: sentencelist, questionIPAList: sentenceIPAlist,));
                                }else{
                                  AutoRouter.of(context).push(CustomArticlePracticeSentenceLearnAutoRoute(questionList: sentencelist,));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary:
                                  PageTheme.cutom_article_practice_background),
                              child: Text('練習')),
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: [
                            Text("Auto：",
                                style: TextStyle(
                                    color: PageTheme.cutom_article_practice_background,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            Switch(
                              value: practice_auto,
                              onChanged: (value) {setState(() {
                                practice_auto = !practice_auto;
                              });},
                              activeColor:PageTheme.cutom_article_practice_background,
                              activeTrackColor: Color(0xffcbdaff),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 3,
                    margin: EdgeInsets.only(right: 10, left: 10, top: 3),
                    decoration: BoxDecoration(
                        color: PageTheme.cutom_article_practice_background,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ],
              ),),

            for (var i = 0; i < sentencelist.length; i++)
              FadeAnimation(
                1.0,
                Card(
                  margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                  color: Color(0xffcbdaff),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        "${sentencelist[i]}",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}
