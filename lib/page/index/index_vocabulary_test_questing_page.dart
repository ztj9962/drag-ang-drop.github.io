import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class IndexVocabularyTestQuestingPage extends StatefulWidget {
  const IndexVocabularyTestQuestingPage({Key? key}) : super(key: key);

  @override
  _IndexVocabularyTestQuestingPage createState() =>
      _IndexVocabularyTestQuestingPage();
}

class _IndexVocabularyTestQuestingPage
    extends State<IndexVocabularyTestQuestingPage> {
  List<Widget> listViews = <Widget>[];
  List<String> text = ['A','B','C','D','E'];

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
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: 24,
          bottom: 62,
        ),
        itemCount: listViews.length,
        itemBuilder: (BuildContext context, index) {
          return listViews[index];
        },
      )),
    );
  }

  void addAllListData() {
    listViews.add(Container(
      margin: EdgeInsets.all(10),
      child: OutlinedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red))),
            side: MaterialStateProperty.all(BorderSide(
                //color: Colors.blue,
                width: 2.0,
                style: BorderStyle.solid)),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 24))),
        child: Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("第一題"),
                )),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            Align(
              alignment: Alignment.centerRight,
              child: Text("1/50"),
            )
          ],
        ),
        onPressed: () {
          //APIUtil.getConversationTokenAndID();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('重置成功！'),
          ));
        },
      ),
    ));
    listViews.add(Container(
      margin: EdgeInsets.all(10),
      child: OutlinedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red))),
            side: MaterialStateProperty.all(BorderSide(
                //color: Colors.blue,
                width: 2.0,
                style: BorderStyle.solid)),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 24))),
        child: Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(50.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("題目"),
                )),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
          ],
        ),
        onPressed: () {},
      ),
    ));
    for (var i = 0; i < 5; i++) {
      listViews.add(Container(
        margin: EdgeInsets.all(10),
        child: OutlinedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red))),
              side: MaterialStateProperty.all(BorderSide(
                  //color: Colors.blue,
                  width: 2.0,
                  style: BorderStyle.solid)),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              textStyle:
                  MaterialStateProperty.all(const TextStyle(fontSize: 24))),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(text[i]+"選項"),
                  )),
              Flexible(fit: FlexFit.tight, child: SizedBox()),
            ],
          ),
          onPressed: () {
            //APIUtil.getConversationTokenAndID();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('重置成功！'),
            ));
          },
        ),
      ));
    }
  }
}
