
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class LearningAutoGenericSummaryReportPage extends StatefulWidget {

  final Map summaryReportData;

  const LearningAutoGenericSummaryReportPage ({ Key? key, required this.summaryReportData}): super(key: key);

  @override
  _LearningAutoGenericSummaryReportPage createState() => _LearningAutoGenericSummaryReportPage();
}

class _LearningAutoGenericSummaryReportPage extends State<LearningAutoGenericSummaryReportPage> {

  Map _summaryReportData = {
    'ttsRateString' : '',
    'startTime' : '',
    'sentenceQuestionArray' : <String>[],
    'sentenceQuestionIPAArray' : <String>[],
    'sentenceQuestionErrorArray' : <List<String>>[],
    'sentenceQuestionChineseArray' : <String>[],
    'sentenceAnswerArray' : <String>[],
    'sentenceAnswerIPAArray' : <String>[],
    'sentenceAnswerErrorArray' : <List<String>>[],
    'scoreArray' : <int>[],
    'secondsArray' : <int>[],
    'userAnswerRate' : <double>[],
    'endTime' : '',
  };

  //全局key-截图key
  final GlobalKey boundaryKey = GlobalKey();


  @override
  void initState() {
    _summaryReportData = widget.summaryReportData;
    print(_summaryReportData);
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
                'Summary Report',
                maxLines: 1,
              ),
              AutoSizeText(
                '總結報告',
                maxLines: 1,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child:RepaintBoundary(
                key: boundaryKey,
                child: Column(
                    children: <Widget>[
                      Text('Shadow Speaking Quiz Error List'),
                      Text('英語口語跟讀測驗錯誤列表'),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: _summaryReportData['sentenceQuestionArray'].length,
                          itemBuilder: (context, index) {

                            var questionTextArray = _summaryReportData['sentenceQuestionArray'][index].split(' ');
                            List<TextSpan> questionTextWidget = [];
                            for (var i = 0; i < questionTextArray.length; i++) {
                              if (_summaryReportData['sentenceQuestionErrorArray'][index].contains(questionTextArray[i])) {
                                questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' ', style: TextStyle(color: Colors.red)));
                              } else {
                                questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' ', style: TextStyle(color: Colors.black)));
                              }
                            }

                            var answerTextArray = _summaryReportData['sentenceAnswerArray'][index].split(' ');
                            List<TextSpan> answerTextWidget = [];
                            for (var i = 0; i < answerTextArray.length; i++) {
                              if (_summaryReportData['sentenceAnswerErrorArray'][index].contains(answerTextArray[i])) {
                                answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' ', style: TextStyle(color: Colors.red)));
                              } else {
                                answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' ', style: TextStyle(color: Colors.black)));
                              }
                            }



                            return Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: PageTheme.app_theme_blue,
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('題目${index+1}'),
                                    const Divider(
                                      thickness: 1,
                                      color: PageTheme.app_theme_blue,
                                    ),
                                    Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                                'Bot',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                )
                                            )
                                        ),
                                        Text(' | '),
                                        Expanded(
                                          flex: 9,
                                          child: RichText(
                                            text: TextSpan(
                                              text: '',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                              children: questionTextWidget,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 0.5,
                                      color: PageTheme.app_theme_blue,
                                      indent: 50,
                                      endIndent: 50,
                                    ),
                                    Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                              'You',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              )
                                          ),
                                        ),
                                        Text(' | '),
                                        Expanded(
                                          flex: 9,
                                          child: RichText(
                                            text: TextSpan(
                                              text: '',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                              children: answerTextWidget,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Divider(
                                      thickness: 1,
                                      color: PageTheme.app_theme_blue,
                                    ),
                                    Center(
                                        child:Row(
                                          children: [
                                            Expanded(
                                              flex: 8,
                                              child: Column(
                                                children: [
                                                  AutoSizeText(
                                                    _summaryReportData['sentenceQuestionArray'][index],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    _summaryReportData['sentenceQuestionIPAArray'][index],
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    _summaryReportData['sentenceQuestionChineseArray'][index],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            _summaryReportData['sentenceQuestionChineseArray'][index].toString().contains('原句:') ?
                                            Container() :
                                            Expanded(
                                              child: CircleAvatar(
                                                backgroundColor: PageTheme.app_theme_blue,
                                                radius: 30.0,
                                                child: IconButton(
                                                  icon: Icon(Icons.analytics_outlined , size: 30),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    AutoRouter.of(context).push(
                                                        SentenceAnalysisIndexRoute(
                                                            analysisor: _summaryReportData['sentenceQuestionArray'][index]));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    )



                                  ],
                                )
                            );
                          },
                          separatorBuilder: (context, index){
                            return const Padding(padding: const EdgeInsets.all(8.0));
                          },
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: PageTheme.app_theme_blue,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('統整'),
                              const Divider(
                                thickness: 1,
                                color: PageTheme.app_theme_blue,
                              ),
                              AutoSizeText(
                                '答對數/總題數：${ _summaryReportData['scoreArray'].where((score) => score == 100).toList().length } / ${ _summaryReportData['scoreArray'].length } ( ${(_summaryReportData['scoreArray'].where((score) => score == 100).toList().length/_summaryReportData['scoreArray'].length * 100).toStringAsFixed(1)} %)',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              AutoSizeText(
                                '答錯數/總題數：${ _summaryReportData['scoreArray'].where((score) => score != 100).toList().length } / ${ _summaryReportData['scoreArray'].length } ( ${(_summaryReportData['scoreArray'].where((score) => score != 100).toList().length/_summaryReportData['scoreArray'].length * 100).toStringAsFixed(1)} %)',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(''),
                              AutoSizeText(
                                '設定語速：${_summaryReportData['ttsRateString']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              AutoSizeText(
                                '您的平均語速：${(_summaryReportData['userAnswerRate'].fold(0, (p, c) => p + c) / _summaryReportData['scoreArray'].length).toStringAsFixed(2)} wps',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(''),
                              AutoSizeText(
                                '測驗開始時間：${_summaryReportData['startTime']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              AutoSizeText(
                                '測驗結束時間：${_summaryReportData['endTime']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              AutoSizeText(
                                '總測驗時間：${formatDuration(Duration(seconds: DateTime.parse(_summaryReportData['endTime']).difference(DateTime.parse(_summaryReportData['startTime'])).inSeconds))}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                      ),
                      const Divider(
                        thickness: 1,
                        color: PageTheme.app_theme_blue,
                      ),
                      /*
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              backgroundColor: PageTheme.app_theme_blue,
                              radius: 40.0,
                              child: IconButton(
                                icon: Icon(Icons.download , size: 30),
                                color: Colors.white,
                                onPressed: () {

                                },
                              ),
                            ),
                          ),
                          ],
                        ),
                      ),
                      */
                    ]
                )
            )
        )
    );
  }


  // Define the function
  String formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(0, '2');
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

}

