import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../page_theme.dart';

class SyllablePracticeSearchPage extends StatefulWidget {

  @override
  _SyllablePracticeSearchPage createState() => _SyllablePracticeSearchPage();
}

class _SyllablePracticeSearchPage extends State<SyllablePracticeSearchPage> {

  List<String> _wordData = ['1','2','3'];

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PageTheme.syllable_search_background,
        title:  AutoSizeText(
          '尋找單詞相似詞',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 3.0,
            color: Color(0xFFFEFEFE),
          ),maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) async {
                },
                decoration: const InputDecoration(
                    labelText: "搜尋相似的單詞",
                    hintText: "搜尋相似的單詞",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))
                    )
                ),
              ),
            ),
      const Divider(
      thickness: 2,

    ),
            Container(
              padding: const EdgeInsets.all(0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: _wordData.length,
                itemBuilder: (context, index) {
                  return Container(

                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:PageTheme.syllable_search_background,
                                    child: IconButton(
                                      iconSize: 45,
                                      icon: Icon(Icons.volume_up),
                                      color: Colors.white,
                                      onPressed: (){
                                      },
                                    ),
                                  )
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      AutoSizeText('word,wear',maxLines: 1, style: TextStyle(fontSize: 24)),
                                      AutoSizeText('[拼音]',maxLines: 1,)
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: PageTheme.syllable_search_background,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 30,
                                      icon: Icon(Icons.mic),
                                      color: Colors.white,
                                      onPressed: (){
                                      },
                                    ),
                                  )
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      AutoSizeText('word,wear',maxLines: 1, style: TextStyle(fontSize: 24)),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index){
                  return const Divider(
                    thickness: 2,
                  );
                },
              ),
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
