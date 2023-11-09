import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:alicsnet_app/view/outlined_button_card_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class IndexVocabularyTestPage extends StatefulWidget {
  const IndexVocabularyTestPage({Key? key}) : super(key: key);

  @override
  _IndexVocabularyTestPageState createState() =>
      _IndexVocabularyTestPageState();
}

class _IndexVocabularyTestPageState extends State<IndexVocabularyTestPage> {
  bool? _isSignin = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateSignStatus() async {
    await SharedPreferencesUtil.getData<bool>('isSignin').then((value) {
      setState(() => _isSignin = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var titleTextSizeGroup = AutoSizeGroup();
    var descripTextSizeGroup = AutoSizeGroup();
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Test your English vocabulary size.',
                    style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                    'In order to master basic language skills you must first focus on common vocabulary to help you lay a good foundation.',
                    style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                    'To learn vocabulary is to understand a word, its pronunciation and meaning.',
                    style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(
                padding: EdgeInsets.all(8),
                child: Text('測驗您的英文單字量',
                    style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(
                padding: EdgeInsets.all(8),
                child: Text('為了掌握基本的語言技能，首先你必須專注於常見的詞彙，幫助你打好基礎．',
                    style: PageTheme.index_vocabulary_test_index_text)),
            const Padding(
                padding: EdgeInsets.all(8),
                child: Text('學習詞彙，也就是了解一個詞、他的語音和意義．',
                    style: PageTheme.index_vocabulary_test_index_text)),
            Center(
              child: Column(
                children: [
                  /*
                  OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(
                            //color: Colors.blue,
                            width: 2.0,
                            style: BorderStyle.solid)),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 24))),
                    child: const Text('  開始測驗  '),
                    onPressed: () async {
                      AutoRouter.of(context).pushNamed("/vocabulary_test_index");
                    },
                  ),*/
                  OutlinedButtonCardView(
                    showDevelopTag: true,
                    imagePath: 'assets/icon/matchUp.svg',
                    titleText: 'Vocabulary Match Up',
                    descripText: '單字連連看',
                    titleTextSizeGroup: titleTextSizeGroup,
                    descripTextSizeGroup: descripTextSizeGroup,
                    onTapFunction: () async {
                      await updateSignStatus();
                      if (_isSignin != true) {
                        AutoRouter.of(context).push(SignInRoute());
                        //changePage(0);
                      }else{
                        AutoRouter.of(context).push(VocabularyMatchUpIndexRoute());
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
