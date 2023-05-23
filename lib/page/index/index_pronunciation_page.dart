import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:alicsnet_app/view/outlined_button_card_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IndexPronunciationPage extends StatefulWidget {
  const IndexPronunciationPage({Key? key}) : super(key: key);

  @override
  _IndexPronunciationPageState createState() => _IndexPronunciationPageState();
}

class _IndexPronunciationPageState extends State<IndexPronunciationPage> {
  List<Widget> listViews = <Widget>[];
  bool? _isSignin = false;
  int _testIndex = 0;

  List<String> _title = ['Pronunciation', 'IPA Grapheme', 'Contraction', 'Minimal Pair', 'Harvard', 'Tongue Twisters'];
  List<String> _svgName = ['practicePronunciation', 'practiceIPA', 'practiceContraction', 'practiceMinimalPair', 'practiceHarvard', 'practiceTongueTwisters'];
  List<String> _introduction = [
    '英語源自拉丁字母表，有 26 個字母。 \n\n'
        '然而，由於從德語、法語和希臘語等其他語言中藉詞，英語發展出了 44 個發音。 \n\n'
        '這造成了拼寫和發音之間的不匹配，其中字母可以代表多個聲音，聲音可以由多個字母代表。 \n\n'
        '這種複雜性使英語學習者很難掌握這門語言。',
    '首先，您可以識別和練習 IPA 聲音字母對照。\n\n'
        '國際音標 (IPA) 使用符號來表示人類語言的各種聲音。 \n\n'
        '通過將每個國際音標音映射到對應的字母或字母組，您可以了解英語中音和字母的關係，提高單詞的準確發音能力。',
    '其次，你可以練習說縮略語。收縮涉及將多個詞合併為一個詞。 \n\n'
        '練習縮略語可以幫助您學會更流暢地將單詞連接在一起，並實現更流暢的演講。 \n\n'
        '使用縮略語是英語會話的一個共同特徵。 \n\n'
        '通過學習正確使用縮略語，您可以在說英語時聽起來更自然。',
    '第三，你可以練習最小對數。最小對是只有一個發音不同的詞對。 \n\n'
        '通過練習最小對數，您可以幫助您識別並產生英語發音中的細微差異。',
    '第四，你可以練習說哈佛句子。哈佛句子是 720 個示例短語的集合，分為 10 個列表，用於 IP 語音、蜂窩和其他電話系統的標準化測試。 \n\n'
        '哈佛句子旨在快速清晰地大聲朗讀。 這可以幫助您提高發音速度和清晰度。',
    '最後，你可以練習說繞口令。繞口令是短而重複的短語，旨在難以快速正確地說出來。 \n\n'
        '練習繞口令可以幫助訓練您的嘴巴和舌頭重複發出相同的聲音，這可以增強您對具有挑戰性的聲音和單詞的發音。'];

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PageTheme.app_theme_black,
        centerTitle: true,
        title: AutoSizeText(
          '發音練習',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 3.0,
            color: Color(0xFFFEFEFE),
          ),
          maxLines: 1,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: (){
                setState(() {
                  _testIndex = 0;
                });
                introducePronunciationPractice();
              },
              child: Icon(Icons.question_mark_outlined),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(10, 10),
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                backgroundColor: PageTheme.white,
                foregroundColor: PageTheme.app_theme_black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: ListView.builder(
            padding: EdgeInsets.only(
              top: 24,
              bottom: 62,
            ),
            itemCount: listViews.length,
            itemBuilder: (BuildContext context, int index) {
              return listViews[index];
            }),
      ),
    );
  }

  void addAllListData() {
    var titleTextSizeGroup = AutoSizeGroup();
    var descripTextSizeGroup = AutoSizeGroup();

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/ipa.svg',
        titleText: 'IPA Grapheme Practice',
        descripText: 'IPA字素練習',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/ipa_grapheme_pair_index_page");
        },
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/contraction.svg',
        titleText: 'Contraction Practice',
        descripText: '縮寫練習',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/contraction_index_page");
        },
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/minimal_pair_02.svg',
        titleText: 'Minimal pairs',
        descripText: '相似字音練習',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/minimal_pair_index");
        },
      ),
    );
    
    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/harvard.svg',
        titleText: 'Harvard Sentence Practice',
        descripText: 'Harvard句子練習',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/harvard_index_page");
        },
      ),
    );

    listViews.add(
      OutlinedButtonCardView(
        showDevelopTag: true,
        imagePath: 'assets/icon/tongue_twisters.svg',
        titleText: 'Tongue Twisters Practice',
        descripText: '英語繞口令練習',
        titleTextSizeGroup: titleTextSizeGroup,
        descripTextSizeGroup: descripTextSizeGroup,
        onTapFunction: () async {
          AutoRouter.of(context).pushNamed("/tongue_twisters_index_page");
        },
      ),
    );
  }

  void introducePronunciationPractice() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Container(
              padding: EdgeInsets.all(30),
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.8,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                      child: Column(
                        children: <Widget>[
                          Text('發音練習有什麼?', style: TextStyle(fontSize: 20),),
                          Divider(
                            thickness: 1,
                            color: PageTheme.app_theme_blue,
                          ),
                        ],
                      )
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(

                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/icon/${_svgName[_testIndex]}.svg',
                            height: 100,),
                          Text(_introduction[_testIndex]),
                          //Padding(padding: EdgeInsets.all(10)),
                        ],
                      ),
                    )

                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Visibility(
                            visible: _testIndex != 0,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                child: Text('Last'),
                                onPressed: (){
                                  setState(() {
                                    _testIndex -= 1;
                                    Navigator.pop(context);
                                    introducePronunciationPractice();
                                  });},
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Visibility(
                            visible: _testIndex < _introduction.length -1,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                child: Text('Next'),
                                onPressed: (){
                                  setState(() {
                                    _testIndex += 1;
                                    Navigator.pop(context);
                                    introducePronunciationPractice();
                                  });},
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
