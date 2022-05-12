
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sels_app/view/title_view.dart';
import '../page_theme.dart';
class _BarChart extends StatelessWidget {

  List data = [];
  _BarChart(List data);
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 30,


      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: const EdgeInsets.all(0),
      tooltipMargin: 8,
      rotateAngle: -90,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xffFFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return Center(child: RotatedBox(quarterTurns: -1,
    child:Text(text, style: style) ,));
  }
  Widget rightTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xffFFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 20) {
      text = '10K';
    } else {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: RotatedBox(quarterTurns: -1,
        child:Text(text, style: style) ,),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 42,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true,reservedSize: 28,getTitlesWidget: rightTitles),
    ),
  );

  FlBorderData get borderData =>  FlBorderData(
    show: true,
    border: Border(
      top: BorderSide.none,
        right: BorderSide(
            color: Color(0xffd6e0ef),
            width: 2
        ),
        bottom: BorderSide(
            color: Color(0xffd6e0ef),
            width: 2
        ),left: BorderSide.none,
    ),
  );

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: 20,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: 6,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: 20,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 14,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 10,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 19,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 20,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 10,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY:12,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 10,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];
}

class BarChartSample3 extends StatefulWidget {
  List data=[];

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}
class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: PageTheme.cutom_article_practice_background,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10,left: 15),
              child: Text("單字等級對照表",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 20,),
            Expanded(child:  Padding(
              padding: const EdgeInsets.only(left: 5,right: 20,),
              child: RotatedBox(child:_BarChart(widget.data), quarterTurns: 1,),
            ),),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
}