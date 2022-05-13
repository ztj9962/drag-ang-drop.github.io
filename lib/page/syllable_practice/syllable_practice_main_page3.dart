import 'package:alicsnet_app/page/page_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SyllablePracticeMainPage3 extends StatefulWidget {
  @override
  _SyllablePracticeMainPage3 createState() => _SyllablePracticeMainPage3();
}

class _SyllablePracticeMainPage3 extends State<SyllablePracticeMainPage3>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> list=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PageTheme.syllable_main_page_background,
        centerTitle: true,
        title: Column(
          children: const [
            Text("音標練習"),
            Text("Minimal Pair", style: TextStyle(fontSize: 12.0)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(15)),
            Container(
              width: 350,
              decoration: BoxDecoration(
                border:
                    Border.all(color: PageTheme.syllable_main_page_background),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton(
                style: TextStyle(fontSize: 20),
                isExpanded: true,
                iconSize: 40,
                hint: AutoSizeText(
                  '   請選擇第一個字元',
                  style:
                      TextStyle(color: PageTheme.syllable_main_page_background),
                  maxLines: 1,
                ),
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

                onChanged: (String? value) {},
                underline: Container(
                  height: 0,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Container(
              width: 350,
              decoration: BoxDecoration(
                border:
                    Border.all(color: PageTheme.syllable_main_page_background),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton(
                style: TextStyle(fontSize: 20),
                isExpanded: true,
                iconSize: 40,
                hint: AutoSizeText(
                  '   請選擇第二個字元',
                  style:
                      TextStyle(color: PageTheme.syllable_main_page_background),
                  maxLines: 1,
                ),
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {},
                underline: Container(
                  height: 0,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(20)),
            CircleAvatar(
              radius: 30,
              backgroundColor: PageTheme.syllable_search_background,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 50,
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            Padding(padding: EdgeInsets.all(20)),
            Divider(
              thickness: 1,
              color: PageTheme.syllable_search_background,
            ),
            Padding(padding: EdgeInsets.all(5)),
            Container(
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                      child: AutoSizeText(
                    '選擇訓練要呈現的格式',
                    style: TextStyle(
                        color: PageTheme.syllable_search_background,
                        fontSize: 20),
                    maxLines: 1,
                  )),
                  Padding(padding: EdgeInsets.all(30)),
                  AutoSizeText('顯示',
                      style: TextStyle(
                          color: PageTheme.syllable_search_background,
                          fontSize: 20),
                      maxLines: 1),
                  Padding(padding: EdgeInsets.all(5)),
                  Container(
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: PageTheme.syllable_main_page_background),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AutoSizeText(
                        '1',
                        style: TextStyle(
                            color: PageTheme.syllable_search_background,
                            fontSize: 20),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      )),
                  Padding(padding: EdgeInsets.all(5)),
                  AutoSizeText('組',
                      style: TextStyle(
                          color: PageTheme.syllable_search_background,
                          fontSize: 20),
                      maxLines: 1),
                  Padding(padding: EdgeInsets.all(10)),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Divider(
              thickness: 1,
              color: PageTheme.syllable_search_background,
            ),
            Padding(padding: EdgeInsets.all(15)),
            Container(
              width: 350,
              child: ElevatedButton(
                  child: const AutoSizeText(
                    '開始練習相似字音節訓練',
                    maxLines: 1,
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: PageTheme.syllable_main_page_background,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shadowColor: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {}),
            ),
            Padding(padding: EdgeInsets.all(15)),
            Container(
              width: 350,
              child: ElevatedButton(
                child: const AutoSizeText(
                  '開始尋找單詞相似字',
                  style: TextStyle(fontSize: 20),
                  maxLines: 1,
                ),
                style: ElevatedButton.styleFrom(
                    primary: PageTheme.syllable_main_page_background,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shadowColor: Colors.black,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}