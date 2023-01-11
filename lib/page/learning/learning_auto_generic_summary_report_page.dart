
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class LearningAutoGenericSummaryReportPage extends StatefulWidget {

  final List<String> sentenceQuestionIDArray;
  final List<String> sentenceQuestionArray;
  final List<String> sentenceQuestionIPAArray;
  final List<List<String>> sentenceQuestionErrorArray;
  final List<String> sentenceQuestionChineseArray;
  final List<String> sentenceAnswerArray;
  final List<String> sentenceAnswerIPAArray;

  const LearningAutoGenericSummaryReportPage ({ Key? key, required this.sentenceQuestionIDArray, required this.sentenceQuestionArray, required this.sentenceQuestionIPAArray, required this.sentenceQuestionErrorArray, required this.sentenceQuestionChineseArray, required this.sentenceAnswerArray, required this.sentenceAnswerIPAArray}): super(key: key);

  @override
  _LearningAutoGenericSummaryReportPage createState() => _LearningAutoGenericSummaryReportPage();
}

class _LearningAutoGenericSummaryReportPage extends State<LearningAutoGenericSummaryReportPage> {

  late List<String> _sentenceQuestionIDArray;
  late List<String> _sentenceQuestionArray;
  late List<String> _sentenceQuestionIPAArray;
  late List<List<String>> _sentenceQuestionErrorArray;
  late List<String> _sentenceQuestionChineseArray;
  late List<String> _sentenceAnswerArray;
  late List<String> _sentenceAnswerIPAArray;

  @override
  void initState() {
    _sentenceQuestionIDArray = widget.sentenceQuestionIDArray;
    _sentenceQuestionArray = widget.sentenceQuestionArray;
    _sentenceQuestionIPAArray = widget.sentenceQuestionIPAArray;
    _sentenceQuestionErrorArray = widget.sentenceQuestionErrorArray;
    _sentenceQuestionChineseArray = widget.sentenceQuestionChineseArray;
    _sentenceAnswerArray = widget.sentenceAnswerArray;
    _sentenceAnswerIPAArray = widget.sentenceAnswerIPAArray;
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
              '',
              maxLines: 1,
            ),
            AutoSizeText(
              '',
              maxLines: 1,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child:Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: _sentenceQuestionArray.length,
                    itemBuilder: (context, index) {
                      var questionTextArray = _sentenceQuestionArray[index].split(' ');
                      List<TextSpan> questionTextWidget = [];
                      var questionIPATextArray = _sentenceQuestionIPAArray[index].split(' ');
                      List<TextSpan> questionIPATextWidget = [];

                      for (var i = 0; i < questionTextArray.length; i++) {
                        if (_sentenceQuestionErrorArray[index].contains(questionTextArray[i])) {
                          if (i < questionTextArray.length -1) {
                            questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' ', style: TextStyle(color: Colors.red)));
                          }

                          if (i < questionIPATextArray.length -1) {
                            questionIPATextWidget.add(TextSpan(text: questionIPATextArray[i] + ' ', style: TextStyle(color: Colors.red)));

                          }
                        } else {
                          if (i < questionTextArray.length - 1) {
                            questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' ', style: TextStyle(color: Colors.black)));
                          }
                          if (i < questionIPATextArray.length - 1) {
                            questionIPATextWidget.add(TextSpan(text: questionIPATextArray[i] + ' ', style: TextStyle(color: Colors.black)));
                          }
                        }
                      }



                      var answerTextArray = _sentenceAnswerArray[index].split(' ');
                      List<TextSpan> answerTextWidget = [];
                      var answerIPATextArray = _sentenceAnswerIPAArray[index].split(' ');
                      List<TextSpan> answerIPATextWidget = [];


                      for (var i = 0; i < answerTextArray.length; i++) {
                        print(i);
                        print(answerTextWidget);
                        if (_sentenceQuestionErrorArray[index].contains(answerTextArray[i])) {

                          if (i < answerTextArray.length - 1) {
                            answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' ', style: TextStyle(color: Colors.red)));
                          }

                          if (i < answerIPATextArray.length - 1) {
                            answerIPATextWidget.add(TextSpan(text: answerIPATextArray[i] + ' ', style: TextStyle(color: Colors.red)));
                          }
                        } else {

                          if (i < answerTextArray.length - 1) {
                            answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' ', style: TextStyle(color: Colors.black)));
                          }

                          if (i < answerIPATextArray.length - 1) {
                            answerIPATextWidget.add(TextSpan(text: answerIPATextArray[i] + ' ', style: TextStyle(color: Colors.black)));
                          }
                        }
                      }



                      return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: PageTheme.app_theme_blue,
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '',
                                  style: const TextStyle(
                                    fontSize: 24 ,
                                    color: Colors.black,
                                  ),
                                  children: questionTextWidget,
                                ),
                              ),
                              Text(
                                _sentenceQuestionChineseArray[index],
                                style: const TextStyle(
                                  fontSize: 18 ,
                                  color: Colors.black,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '',
                                  style: const TextStyle(
                                    fontSize: 18 ,
                                    color: Colors.black,
                                  ),
                                  children: questionIPATextWidget,
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: PageTheme.app_theme_blue,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '',
                                  style: const TextStyle(
                                    fontSize: 24 ,
                                    color: Colors.black,
                                  ),
                                  children: answerTextWidget,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '',
                                  style: const TextStyle(
                                    fontSize: 18 ,
                                    color: Colors.black,
                                  ),
                                  children: answerIPATextWidget,
                                ),
                              ),
                            ],
                          )
                      );
                    },
                    separatorBuilder: (context, index){
                      return const Padding(padding: const EdgeInsets.all(8.0));
                    },
                  ),
                ),
              ]
          )

      ),



    );
  }
}