import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';

class PieChartWidget extends StatefulWidget {
  final List data  ;
  const PieChartWidget({Key? key, required this.data}) : super(key: key);
  @override
  _PieChartWidget createState() => _PieChartWidget();
}

class _PieChartWidget extends State<PieChartWidget> {
  List indicatorList=[];
  List _data = [];
  List<PieChartSectionData> sectionList = [];
  List colorList = [Color(0xff0293ee),Color(0xfff8b250),Color(0xff845bef),Color(0xff13d38e),Color(0xffFF8040),Color(0xff00E3E3),Color(0xff2626FF),Color(0xffFF7575),];
  @override
  void initState() {
    _data = widget.data;
    _data.asMap().forEach((index,element) {
      if(element['pct'] != null){
        indicatorList.add(
          Indicator(
            color: colorList[index],
            text:element['level'] ,
            isSquare: true,
          ),
        );
        sectionList.add(
            PieChartSectionData(
              color:  colorList[index],
              value: double.parse(element['pct']),
              title: '${(double.parse(element['pct'])*100).round()}%',
              radius: 50,
              titleStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff000000)),
              titlePositionPercentageOffset: ((double.parse(element['pct'])*100).round())<3 ? 1.3:0.5,
            ),
        );
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5,right: 5),
      height: 250,
      child: Card(
        color: Colors.white,
        child: Row(
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
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  <Widget>[
                Expanded(child: Container(),flex: 2,),
                for (var item in indicatorList) Padding(padding:EdgeInsets.only(bottom: 3),child:item ,),
                Expanded(child: Container(),flex: 2,),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }
}