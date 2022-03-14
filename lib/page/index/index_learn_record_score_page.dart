import 'package:flutter/material.dart';
import 'package:sels_app/page/page_theme.dart';

class IndexLearnRecordScorePage extends StatefulWidget {
  const IndexLearnRecordScorePage({Key? key}) : super(key: key);

  @override
  _IndexLearnRecordScorePageState createState() => _IndexLearnRecordScorePageState();
}

class _IndexLearnRecordScorePageState extends State<IndexLearnRecordScorePage> {

  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 300,
            color: PageTheme.learn_record_score_green,
            /*
            child: Column(
              children: [
                DropdownButton(
                  items: <DropdownMenuItem<StringAPP>>[
                    DropdownMenuItem(child: Text("1111"), value: "1"),
                    DropdownMenuItem(child: Text("1111"), value: "1"),
                  ],
                  onChanged: (selectValue){//選中後的回撥
                    print(selectValue);
                  },
                ),
              ],
            ),

             */
          ),
          Container(
            height: 250,
            //color: Colors.red,
          ),
          Container(
            height: 250,
            //color: Colors.yellow,
          ),
          Container(
            height: 250,
            //color: Colors.yellow,
          ),
          //Your Widgets
          //Your Widgets,
          //Your Widgets
        ],
      ),
    );
  }

}