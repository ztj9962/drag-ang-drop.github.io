import 'package:alicsnet_app/page/page_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GrammarCorrectionMainPage extends StatefulWidget {
  @override
  _GrammarCorrectionMainPage createState() => _GrammarCorrectionMainPage();
}

class _GrammarCorrectionMainPage extends State<GrammarCorrectionMainPage>
    with TickerProviderStateMixin {
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
        backgroundColor: PageTheme.grammar_correction_background,
        centerTitle: true,
        title: Column(
          children: const [
            Text("文法校正"),
            Text("Grammar Correction", style: TextStyle(fontSize: 12.0)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(10)),
            Divider(
              thickness: 1,
              color: PageTheme.grammar_correction_background,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  AutoSizeText(
                    '請輸入想要校正的文法:',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 20,
                        color: PageTheme.grammar_correction_background),
                  ),
                  Expanded(
                      flex: 3,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.close,
                            size: 40,
                            color: PageTheme.grammar_correction_background,
                          ))),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(70)),
            Row(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                CircleAvatar(
                  backgroundColor: PageTheme.grammar_correction_background,
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Divider(
              thickness: 1,
              color: PageTheme.grammar_correction_background,
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 60,
              color: PageTheme.grammar_correction_background,
            ),
            Divider(
              thickness: 1,
              color: PageTheme.grammar_correction_background,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(10)),
                AutoSizeText(
                  '這裡是建議的結果:',
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 20,
                      color: PageTheme.grammar_correction_background),
                ),
                Expanded(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.content_copy,
                          size: 40,
                          color: PageTheme.grammar_correction_background,
                        ))),
              ],
            ),
            Container(
              padding: EdgeInsets.all(50),
              child: AutoSizeText('請打出想要校正的文法'),
            ),
            Divider(
              thickness: 1,
              color: PageTheme.grammar_correction_background,
            ),
          ],
        ),
      ),
    );
  }
}
