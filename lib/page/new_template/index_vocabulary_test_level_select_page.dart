import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class IndexVocabularyTestLevelSelectPage extends StatefulWidget {
  const IndexVocabularyTestLevelSelectPage({Key? key}) : super(key: key);

  @override
  _IndexVocabularyTestLevelSelectPage createState() =>
      _IndexVocabularyTestLevelSelectPage();
}

class _IndexVocabularyTestLevelSelectPage
    extends State<IndexVocabularyTestLevelSelectPage> {
  List<Widget> listViews = <Widget>[];

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(8),
                child: AutoSizeText('選擇您的測試級別',
                    style: PageTheme.index_vocabulary_test_index_text,maxLines: 1,)),
            const Padding(
                padding: EdgeInsets.all(8),
                child: AutoSizeText('Please select your test level．',
                    style: PageTheme.index_vocabulary_test_index_text,maxLines: 1,)),
            const Padding(
                padding: EdgeInsets.all(8),
                child: AutoSizeText('友情提示:為確保結果的準確性，不會的請點擊選項E。',maxLines: 2,
                    style: PageTheme.index_vocabulary_test_index_text)),
            Center(
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
          ],
        ),
      ),
    );
  }

  void addAllListData() {
    for (var i = 0; i < 6; i++) {
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
                    child: AutoSizeText("1. 350  Kindergarten",maxLines: 1,),
                  )),
              Flexible(fit: FlexFit.tight, child: SizedBox()),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.play_arrow,size: 30,),
              )
            ],
          ),
          onPressed: () {
          },
        ),
      ));
    }
  }
}
