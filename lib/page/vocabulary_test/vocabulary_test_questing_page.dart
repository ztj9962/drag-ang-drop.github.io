import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VocabularyTestQuestingPage extends StatefulWidget {
  const VocabularyTestQuestingPage({Key? key}) : super(key: key);

  @override
  _VocabularyTestQuestingPage createState() =>
      _VocabularyTestQuestingPage();
}

class _VocabularyTestQuestingPage
    extends State<VocabularyTestQuestingPage> {
  List<Widget> listViews = <Widget>[];
  List<String> text = ['A', 'B', 'C', 'D', 'E'];

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
                  child: AutoSizeText(
                    "第一題",
                    maxLines: 1,
                  ),
                )),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                "1/50",
                maxLines: 1,
              ),
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
        child: Padding(
          padding: const EdgeInsets.all(70.0),
          child: AutoSizeText(
            "題目",
            maxLines: 1,
          ),
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
                    child: AutoSizeText(text[i] + "選項",maxLines: 1,),
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
