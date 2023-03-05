import 'package:alicsnet_app/page/page_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';

class PieChartWidget extends StatefulWidget {
  final List data;
  const PieChartWidget({Key? key, required this.data}) : super(key: key);
  @override
  _PieChartWidget createState() => _PieChartWidget();
}

class _PieChartWidget extends State<PieChartWidget> {
  List indicatorList = [];
  List _data = [];
  List<PieChartSectionData> sectionList = [];
  List wordList = [];
  List colorList = [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Color(0xffFF8040),
    Color(0xff00E3E3),
    Color(0xff2626FF),
    Color(0xffaba6a6),
  ];
  @override
  void initState() {
    _data = widget.data;
    _data.asMap().forEach((index, element) {
      if (element['pct'] != null) {
        print(element);
        List word = element['words'];
        //List word = ['apple','banana'];
        String indicatorName ="";
        switch(element['level']){
          case "國小":
            indicatorName = element['level']+"elementary school";
            break;
          case "國中":
            indicatorName = element['level']+"secondary";
            break;
          case "高中(1)":
            indicatorName = element['level']+"high school(1)";
            break;
          case "高中(2)":
            indicatorName = element['level']+"high school(2)";
            break;
          case "全民英檢":
            indicatorName = element['level']+"GEPT";
            break;
          case "多益":
            indicatorName = element['level']+"Toeic";
            break;
          case "托福":
            indicatorName = element['level']+"Toefl";
            break;
          case "Out of 10K":
            indicatorName = element['level'];
            break;
        }
        indicatorList.add(
          Indicator(
            color: colorList[index],
            text: indicatorName,
            isSquare: true,
            size: 12,
          ),
        );
        sectionList.add(
          PieChartSectionData(
            color: colorList[index],
            value: double.parse(element['pct']),
            title: '${(double.parse(element['pct']) * 100).round()}%',
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
            titlePositionPercentageOffset:
                ((double.parse(element['pct']) * 100).round()) < 3 ? 1.3 : 0.5,
          ),
        );
        wordList.add(
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => WordAlertDialog(word));
              },
              child: Text(
                '${word.length}',
                style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline),
              ),
            )
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      height: 400,
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: sectionList),
                  swapAnimationDuration: Duration(milliseconds: 150),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
           /* Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Level：',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                for (var item in indicatorList)
                  Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: item,
                  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Count：',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                for (var item in wordList)
                    Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: item),
              ],
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Level',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    for (var item in indicatorList)
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: item,
                      ),
                  ],
                ),
                SizedBox(width: 5,),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Count',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    for (var item in wordList)
                      Padding(
                          padding: EdgeInsets.only(bottom: 3),
                          child: item),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class WordAlertDialog extends StatelessWidget {
  List word =[];

  WordAlertDialog(this.word);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Word',
                    style: TextStyle(fontSize: 14, color: Color(0xFF39D2C0)),
                  )
                ],
              ),
              Divider(
                height: 2,
                thickness: 1,
                color: Color(0xFFDBE2E7),
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black54),
                children: [
                for(var item in word)
                  TextSpan(text:  item+",　")
              ]),),
            ],
          ),
        ),
      ),
    );
  }
}
