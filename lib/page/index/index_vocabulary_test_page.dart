import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class IndexVocabularyTestPage extends StatefulWidget {
  const IndexVocabularyTestPage({Key? key}) : super(key: key);

  @override
  _IndexVocabularyTestPageState createState() => _IndexVocabularyTestPageState();
}

class _IndexVocabularyTestPageState extends State<IndexVocabularyTestPage> {

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
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            const Padding(padding: EdgeInsets.all(8), child: Text('Test your English vocabulary size.', style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(padding: EdgeInsets.all(8), child: Text('In order to master basic language skills you must first focus on common vocabulary to help you lay a good foundation.', style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(padding: EdgeInsets.all(8), child: Text('To learn vocabulary is to understand a word, its pronunciation and meaning.', style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(padding: EdgeInsets.all(8), child: Text('測驗您的英文單字量', style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(padding: EdgeInsets.all(8), child: Text('為了掌握基本的語言技能，首先你必須專注於常見的詞彙，幫助你打好基礎．', style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(padding: EdgeInsets.all(8), child: Text('學習詞彙，也就是了解一個詞、他的語音和意義．', style: PageTheme.index_vocabulary_test_index_text)),
            Center(
              child: OutlinedButton(
                style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(
                      //color: Colors.blue,
                      width: 2.0,
                      style: BorderStyle.solid)
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 24))
                ),
                child: const Text('  開始測驗  '),
                onPressed: () {
                  AutoRouter.of(context).pushNamed("/vocabulary_test_index");
                },
              ),
            ),

          ],
        ),
      ),




    );
  }
}