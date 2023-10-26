import 'dart:convert';
import 'dart:typed_data';

import 'package:alicsnet_app/util/web_only_feature_util.dart' if(dart.library.io) 'package:alicsnet_app/util/mobile_only_feature_util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class LearningAutoGenericSummaryReportPage extends StatefulWidget {
  final Map summaryReportData;

  const LearningAutoGenericSummaryReportPage(
      {Key? key, required this.summaryReportData})
      : super(key: key);

  @override
  _LearningAutoGenericSummaryReportPage createState() =>
      _LearningAutoGenericSummaryReportPage();
}

class _LearningAutoGenericSummaryReportPage
    extends State<LearningAutoGenericSummaryReportPage> {

  bool get isIOS => !kIsWeb && isIOS;

  bool get isAndroid => !kIsWeb && isAndroid;

  bool get isWeb => kIsWeb;

  //asset是根目錄
  String _PDFttfPath = "fonts/NotoSansTC-Black.ttf";
  Map _summaryReportData = {
    'ttsRateString': '',
    'startTime': '',
    'sentenceQuestionArray': <String>[],
    'sentenceQuestionIPAArray': <String>[],
    'sentenceQuestionErrorArray': <List<String>>[],
    'sentenceQuestionChineseArray': <String>[],
    'sentenceAnswerArray': <String>[],
    'sentenceAnswerIPAArray': <String>[],
    'sentenceAnswerErrorArray': <List<String>>[],
    'scoreArray': <int>[],
    'secondsArray': <int>[],
    'userAnswerRate': <double>[],
    'endTime': '',
  };

  //全局key-截图key
  final GlobalKey boundaryKey = GlobalKey();

  @override
  void initState() {
    _summaryReportData = widget.summaryReportData;
    print(jsonEncode(_summaryReportData));
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
            child: RepaintBoundary(
                key: boundaryKey,
                child: Column(children: <Widget>[
                  Text('Shadow Speaking Practice result'),
                  Text('英語口語練習結果'),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount:
                          _summaryReportData['sentenceQuestionArray'].length,
                      itemBuilder: (context, index) {
                        var questionTextArray = _summaryReportData['sentenceQuestionArray'][index].split(' ');
                        List<TextSpan> questionTextWidget = [];
                        for (var i = 0; i < questionTextArray.length; i++) {
                          if (_summaryReportData['sentenceQuestionErrorArray'][index].contains(questionTextArray[i])) {
                            questionTextWidget.add(TextSpan(
                                text: questionTextArray[i] + ' ',
                                style: TextStyle(color: Colors.red)));
                          } else {
                            questionTextWidget.add(TextSpan(
                                text: questionTextArray[i] + ' ',
                                style: TextStyle(color: Colors.black)));
                          }
                        }

                        var answerTextArray = _summaryReportData['sentenceAnswerArray'][index].split(' ');
                        List<TextSpan> answerTextWidget = [];
                        for (var i = 0; i < answerTextArray.length; i++) {
                          if (_summaryReportData['sentenceAnswerErrorArray'][index].contains(answerTextArray[i])) {
                            answerTextWidget.add(TextSpan(
                                text: answerTextArray[i] + ' ',
                                style: TextStyle(color: Colors.red)));
                          } else {
                            answerTextWidget.add(TextSpan(
                                text: answerTextArray[i] + ' ',
                                style: TextStyle(color: Colors.black)));
                          }
                        }

                        return Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: PageTheme.app_theme_blue,
                                width: 1,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('題目${index + 1}'),
                                const Divider(
                                  thickness: 1,
                                  color: PageTheme.app_theme_blue,
                                ),
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text('Bot',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ))),
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
                                      child: Text('You',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
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
                                    child: Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Column(
                                        children: [
                                          AutoSizeText(
                                            _summaryReportData[
                                                'sentenceQuestionArray'][index],
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          AutoSizeText(
                                            _summaryReportData[
                                                    'sentenceQuestionIPAArray']
                                                [index],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          AutoSizeText(
                                            _summaryReportData[
                                                    'sentenceQuestionChineseArray']
                                                [index],
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _summaryReportData[
                                                    'sentenceQuestionChineseArray']
                                                [index]
                                            .toString()
                                            .contains('原句:')
                                        ? Container()
                                        : Expanded(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  PageTheme.app_theme_blue,
                                              radius: 30.0,
                                              child: IconButton(
                                                icon: Icon(
                                                    Icons.analytics_outlined,
                                                    size: 30),
                                                color: Colors.white,
                                                onPressed: () {
                                                  AutoRouter.of(context).push(
                                                      SentenceAnalysisIndexRoute(
                                                          analysisor:
                                                              _summaryReportData[
                                                                      'sentenceQuestionArray']
                                                                  [index]));
                                                },
                                              ),
                                            ),
                                          ),
                                  ],
                                ))
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                            padding: const EdgeInsets.all(8.0));
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('統整'),
                              const Divider(
                                thickness: 1,
                                color: PageTheme.app_theme_blue,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        '答對數/總題數：${_summaryReportData['scoreArray'].where((score) => score == 100).toList().length} / ${_summaryReportData['scoreArray'].length} ( ${(_summaryReportData['scoreArray'].where((score) => score == 100).toList().length / _summaryReportData['scoreArray'].length * 100).toStringAsFixed(1)} %)',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      AutoSizeText(
                                        '答錯數/總題數：${_summaryReportData['scoreArray'].where((score) => score != 100).toList().length} / ${_summaryReportData['scoreArray'].length} ( ${(_summaryReportData['scoreArray'].where((score) => score != 100).toList().length / _summaryReportData['scoreArray'].length * 100).toStringAsFixed(1)} %)',
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
                                  ),
                                  (isWeb) ?
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                          PageTheme.app_theme_blue,
                                          radius: 30.0,
                                          child: IconButton(
                                            icon: Icon(
                                                Icons.save,
                                                size: 30),
                                            color: Colors.white,
                                            onPressed: () async {
                                              //下載PDF
                                              final pdf = pw.Document();
                                              //寫入PDF
                                              final ByteData fontData = await rootBundle.load(_PDFttfPath);
                                              final pw.Font customFont = pw.Font.ttf(fontData);

                                              List<pw.TableRow> tableRows = [];
                                              List<pw.Table> pwTables = [];

                                              //處理錯誤句子紅字
                                              for (int index = 0; index < _summaryReportData['sentenceQuestionArray'].length; index++) {

                                                var questionTextArray = _summaryReportData['sentenceQuestionArray'][index].split(' ');
                                                List<List<pw.TextSpan>> questionTextWidget = List<List<pw.TextSpan>>.filled(_summaryReportData['sentenceQuestionArray'].length, []);
                                                for (var i = 0; i < questionTextArray.length; i++) {
                                                  if (_summaryReportData['sentenceQuestionErrorArray'][index].contains(questionTextArray[i])) {
                                                    questionTextWidget[index].add(pw.TextSpan(text: questionTextArray[i] + ' ', style: pw.TextStyle(font: customFont,color: PdfColors.red)),);
                                                  } else {
                                                    questionTextWidget[index].add(pw.TextSpan(text: questionTextArray[i] + ' ', style: pw.TextStyle(font: customFont,color: PdfColors.black)),);
                                                  }
                                                }

                                                var answerTextArray = _summaryReportData['sentenceAnswerArray'][index].split(' ');
                                                List<List<pw.TextSpan>> answerTextWidget = List<List<pw.TextSpan>>.filled(_summaryReportData['sentenceQuestionArray'].length, []);
                                                for (var i = 0; i < answerTextArray.length; i++) {
                                                  if (_summaryReportData['sentenceAnswerErrorArray'][index].contains(answerTextArray[i])) {
                                                    answerTextWidget[index].add(pw.TextSpan(text: answerTextArray[i] + ' ', style: pw.TextStyle(font: customFont,color: PdfColors.red)),);
                                                  } else {
                                                    answerTextWidget[index].add(pw.TextSpan(text: answerTextArray[i]+ ' ', style: pw.TextStyle(font: customFont,color: PdfColors.black)),);
                                                  }
                                                }

                                                tableRows.add(
                                                  pw.TableRow(
                                                    verticalAlignment: pw.TableCellVerticalAlignment.middle,
                                                    decoration:pw.BoxDecoration(color: PdfColor.fromHex('#FFFFFF'),
                                                    ),
                                                    children: <pw.Widget>[
                                                      pw.Align(
                                                        alignment: pw.Alignment.center,
                                                        child: pw.Text('Bot', style: pw.TextStyle(font: customFont)),
                                                      ),
                                                      pw.Padding(
                                                        padding: pw.EdgeInsets.only(left: 5),
                                                        child: pw.Align(
                                                          alignment: pw.Alignment.centerLeft,
                                                          child: pw.RichText(text: pw.TextSpan(children: questionTextWidget[index])),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                tableRows.add(
                                                  pw.TableRow(
                                                    verticalAlignment: pw.TableCellVerticalAlignment.middle,
                                                    decoration:pw.BoxDecoration(color: PdfColor.fromHex('#E0E0E0')),
                                                    children: <pw.Widget>[
                                                      pw.Align(
                                                        alignment: pw.Alignment.center,
                                                        child: pw.Text('You', style: pw.TextStyle(font: customFont)),
                                                      ),
                                                      pw.Padding(
                                                        padding: pw.EdgeInsets.only(left: 5),
                                                        child: pw.Align(
                                                          alignment: pw.Alignment.centerLeft,
                                                          child: pw.RichText(text: pw.TextSpan(children: answerTextWidget[index])),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                pwTables.add(pw.Table(
                                                    border: pw.TableBorder.all(),
                                                    columnWidths: {0:pw.FixedColumnWidth(10.0)},
                                                    children: [
                                                      pw.TableRow(
                                                        verticalAlignment: pw.TableCellVerticalAlignment.middle,
                                                        decoration:pw.BoxDecoration(color: PdfColor.fromHex('#EEF2F8')),
                                                          children: [
                                                            pw.Align(
                                                              alignment: pw.Alignment.center,
                                                              child: pw.Text((index+1).toString(),style:pw.TextStyle(font: customFont)),
                                                            ),
                                                        pw.Table(
                                                          columnWidths: {0:pw.FixedColumnWidth(10.0),1:pw.FixedColumnWidth(80.0)},
                                                          border: pw.TableBorder.all(),
                                                          children: tableRows,
                                                        ),
                                                      ]
                                                      )
                                                    ]
                                                ),);
                                            
                                                tableRows = [];
                                              }

                                              List<pw.Widget> pageWidgetList = [];

                                              //安排每個部分排列
                                              pageWidgetList.add(
                                                pw.Align(
                                                  child: pw.Column(
                                                    children: <pw.Widget>[
                                                      pw.Text('英語口語練習結果', style: pw.TextStyle(font: customFont)),
                                                      pw.Text('Shadow Speaking Practice result', style: pw.TextStyle(font: customFont)),
                                                    ],
                                                  ),
                                                ),
                                                );

                                              pageWidgetList.add(
                                                pw.Container(height: 20),
                                              );

                                              pageWidgetList.add(
                                                pw.Column(
                                                  children:pwTables,
                                                ),
                                              );

                                              pageWidgetList.add(
                                                pw.Container(height: 20),
                                              );

                                              pageWidgetList.add(
                                                pw.Align(
                                                    alignment: pw.Alignment.centerLeft,
                                                    child: pw.Column(
                                                        children: <pw.Widget>[
                                                          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text('答對數/總題數：${_summaryReportData['scoreArray'].where((score) => score == 100).toList().length} / ${_summaryReportData['scoreArray'].length} ( ${(_summaryReportData['scoreArray'].where((score) => score == 100).toList().length / _summaryReportData['scoreArray'].length * 100).toStringAsFixed(1)} %)', style: pw.TextStyle(font: customFont)),),
                                                          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text('答錯數/總題數：${_summaryReportData['scoreArray'].where((score) => score != 100).toList().length} / ${_summaryReportData['scoreArray'].length} ( ${(_summaryReportData['scoreArray'].where((score) => score != 100).toList().length / _summaryReportData['scoreArray'].length * 100).toStringAsFixed(1)} %)', style: pw.TextStyle(font: customFont)),),
                                                          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text('設定語速：${_summaryReportData['ttsRateString']}', style: pw.TextStyle(font: customFont)),),
                                                          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text('您的平均語速：${(_summaryReportData['userAnswerRate'].fold(0, (p, c) => p + c) / _summaryReportData['scoreArray'].length).toStringAsFixed(2)} wps', style: pw.TextStyle(font: customFont)),),
                                                          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text('測驗開始時間：${_summaryReportData['startTime']}', style: pw.TextStyle(font: customFont)),),
                                                          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text('測驗結束時間：${_summaryReportData['endTime']}', style: pw.TextStyle(font: customFont)),),
                                                          pw.Align(alignment: pw.Alignment.centerLeft,child:pw.Text('總測驗時間：${formatDuration(Duration(seconds: DateTime.parse(_summaryReportData['endTime']).difference(DateTime.parse(_summaryReportData['startTime'])).inSeconds))}', style: pw.TextStyle(font: customFont)),),
                                                        ]
                                                    )
                                                ),
                                              );

                                              //創造PDF
                                              pdf.addPage(
                                                pw.MultiPage(
                                                  build: (pw.Context context) {
                                                    return pageWidgetList;
                                                  },
                                                ),
                                              );
                                              //電腦版下載PDF
                                              if(isWeb){
                                                final uint8List = Uint8List.fromList(await pdf.save());
                                                //final blob = Blob([uint8List]);
                                                //final url = Url.createObjectUrlFromBlob(blob);
                                                //final anchor = AnchorElement(href: url)
                                                //  ..target = 'webdownload'
                                                //  ..download = 'file.pdf' // 指定文件名
                                                //  ..click();
                                                //Url.revokeObjectUrl(url);;
                                                downloadPDF(uint8List);
                                              }
                                              if(isAndroid){
                                                //final directory = await getApplicationDocumentsDirectory();
                                                //final pdfFile = File('${directory.path}/example.pdf');
                                                //// 将PDF内容写入文件
                                                //await pdfFile.writeAsBytes(await pdf.save());
                                                downloadPDF(await pdf.save());
                                              }
                                            },
                                          ),
                                        ),
                                        AutoSizeText('儲存報表'),
                                      ],
                                    ),
                                  ) : Container(),
                                  Padding(padding: EdgeInsets.all(15))
                                ],
                              )
                            ],
                          ),
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
                ]))));
  }

  // Define the function
  String formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(0, '2');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
