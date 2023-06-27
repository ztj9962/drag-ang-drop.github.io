import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:alicsnet_app/view/outlined_button_card_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/view/title_view.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:alicsnet_app/util/introduction_util.dart';

class IndexPronunciationPage extends StatefulWidget {
  const IndexPronunciationPage({Key? key}) : super(key: key);

  @override
  _IndexPronunciationPageState createState() => _IndexPronunciationPageState();
}

class _IndexPronunciationPageState extends State<IndexPronunciationPage> {
  List<Widget> listViews = <Widget>[];
  bool? _isSignin = false;
  int _testIndex = 0;

  List<String> _routeName = [
    'ipa_grapheme_pair_index_page',
    'contraction_index_page',
    'minimal_pair_index',
    'harvard_index_page',
    'tongue_twisters_index_page'
  ];
  List<String> _svgName = [
    'practicePronunciation',
    'practiceIPA',
    'practiceContraction',
    'practiceMinimalPair',
    'practiceHarvard',
    'practiceTongueTwisters',
    'practicePronunciation'
  ];

  List<Widget> _languageContent = <Widget>[Text('中文'), Text('English')];
  List<bool> _languageSelect = <bool>[true, false];

  String _practice = '';
  String _practiceChinese = '開始練習';
  String _practiceEnglish = 'Start Practice';

  List<String> _title = [];
  List<String> _titleChinese = [
    '發音練習有什麼?',
    'IPA字素練習',
    '縮寫練習',
    '相似字音練習',
    'Harvard句子練習',
    '英語繞口令練習',
    '總結'
  ];
  List<String> _titleEnglish = [
    'What about pronunciation practice?',
    'IPA Grapheme Practice',
    'Contraction Practice',
    'Minimal Pair Practice',
    'Harvard Sentence Practice',
    'Tongue Twisters Practice',
    'Summarize'
  ];

  List<String> _introduction = [];
  List<String> _introductionChinese = [
    '英語是源自拉丁字母的語言，擁有26個字母。\n\n'
        '然而，由於從其他語言如德語、法語和希臘語借用詞彙，英語發展出了44個音素。\n\n'
        '這造成了拼寫和發音之間的不匹配，字母可以代表多個音素，而音素也可以用多個字母表示。\n\n'
        '這種複雜性使得英語學習者在掌握這門語言時面臨挑戰。\n\n'
        '為了幫助您提高英語發音，我們的發音課程提供了幾種練習方法。',
    '首先，您可以識別並練習國際音標（IPA）的音素-字母對照。\n\n'
        '國際音標（IPA）使用符號表示人類語言的各種音素。\n\n'
        '通過將每個國際音標音素對照到相應的字母或字母組合，您可以理解英語中音素和字母之間的關係，並提高準確發音的能力。',
    '其次，您可以練習說縮略詞。縮略詞涉及將多個單詞合併為一個詞。\n\n'
        '練習縮略詞有助於您學會更流暢地將單詞連接在一起，達到更流利的口語。\n\n'
        '使用縮略詞是英語會話的一個常見特點。\n\n'
        '通過學會正確使用縮略詞，您在講英語時可以聽起來更自然。',
    '第三，您可以練習最小對立詞。最小對立詞是僅在一個音素上有所不同的詞對。\n\n'
        '通過練習最小對立詞，您可以幫助自己識別和產生英語發音中的細微差異。',
    '第四，您可以練習哈佛句子。哈佛句子是一組720個示例短語，每10個句子分為一個列表，用於語音網絡電話、蜂窩和其他電話系統的標準測試。\n\n'
        '哈佛句子設計成可以快速清晰地朗讀。這可以幫助您提高發音的速度和清晰度。',
    '最後，您可以練習繞口令。繞口令是一種短小而重複的詞語，旨在迅速而正確地說出來會比較困難。\n\n'
        '練習繞口令有助於訓練口腔和舌頭重複發出相同的音素，這可以提高您發音困難的音素和詞語的準確性。',
    '這些練習方法每一個都可以通過專注於語言的特定方面來幫助您提高英語發音。\n\n'
        '通過將這些方法融入您的學習計劃中，您可以在說英語時變得更加自信和熟練。\n\n'
        '希望這些方法能幫助您提高英語發音。',
  ];
  List<String> _introductionEnglish = [
    'The English language is derived from the Latin alphabet, which has 26 letters.\n\n'
        'However, due to borrowing words from other languages such as German, French, and Greek, the English language has developed 44 sounds.\n\n'
        'This has created a mismatch between spelling and pronunciation, where letters can represent multiple sounds, and sounds can be represented by multiple letters.\n\n'
        'This complexity can make it challenging for English learners to master the language.\n\n'
        'To help you improve your English pronunciation, our pronunciation program offers several practicing approaches.',
    'First, you can identify and practice IPA sound-letter mapping.\n\n'
        'The International Phonetic Alphabet (IPA) uses symbols to represent the various sounds of human language.\n\n'
        'By mapping each IPA sound to a corresponding letter or group of letters, you can understand the relationship between sounds and letters in English, and improve your ability to pronounce words accurately.',
    'Second, you can practice saying contractions.\n\n'
        'Contractions involve merging multiple words into one.\n\n'
        'Practicing contractions helps you learn to link words together more smoothly and achieve a more fluent speech.\n\n'
        'Using contractions is a common feature of conversational English.\n\n'
        'By learning to use contractions correctly, you can sound more natural when speaking English.',
    'Third, you can practice minimal pairs. Minimal pairs are pairs of words that differ by only one sound.\n\n'
        'By practicing minimal pairs, you can help you identify and produce subtle differences in English pronunciation.',
    'Fourth, you can practice saying Harvard sentences.'
        'The Harvard sentences are a collection of 720 sample phrases, each 10 sentences is divided into a list, used for standardized testing of Voice over IP, cellular, and other telephone systems.\n\n'
        'The Harvard sentences are designed to be read aloud quickly and clearly.\n\n'
        'This can help you to improve your pronunciation speed and clarity.',
    'Finally, you can practice saying tongue twisters.\n\n'
        'Tongue twisters are short, repetitive phrases that are designed to be difficult to say quickly and correctly.\n\n'
        'Practicing tongue twisters can assist in training your mouth and tongue to produce the same sounds repeatedly, which can enhance your pronunciation of challenging sounds and words.',
    'In summary, each of these practices helps you improve your English pronunciation by focusing on specific aspects of the language.\n\n'
        'By incorporating these practices into your study routine, you can become more confident and proficient in speaking English.\n\n'
        'We hope these approaches help you improve your English pronunciation.'
  ];

  @override
  void initState() {
    addAllListData();
    super.initState();
    _title = _titleChinese;
    _introduction = _introductionChinese;
    _practice = _practiceChinese;
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
            child: Container(
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IntroductionUtil(
                  svgName: _svgName,
                  titleChinese:_titleChinese,
                  titleEnglish:_titleEnglish,
                  introductionChinese:_introductionChinese,
                  introductionEnglish:_introductionEnglish
              )
              /*ElevatedButton(
                child: Icon(Icons.question_mark_outlined),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(10, 10),
                  shape: CircleBorder(),
                  //padding: EdgeInsets.all(10),
                  backgroundColor: PageTheme.app_theme_black,
                  foregroundColor: PageTheme.white,
                ),
                onPressed: () {
                  setState(() {
                    _testIndex = 0;
                  });
                },
              ),
              */
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
        descripText: 'IPA發音練習',
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

  /*
  void introducePronunciationPractice() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: EdgeInsets.all(30),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Text(
                            _title[_testIndex],
                            style: TextStyle(
                                fontSize: 16, color: PageTheme.app_theme_blue),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: Divider(
                              thickness: 1,
                              color: PageTheme.app_theme_blue,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ToggleButtons(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                selectedBorderColor: PageTheme.app_theme_blue,
                                selectedColor: Colors.white,
                                fillColor: PageTheme.app_theme_blue,
                                color: PageTheme.app_theme_blue,
                                isSelected: _languageSelect,
                                children: _languageContent,
                                textStyle: TextStyle(fontSize: 12),
                                onPressed: (int index) {
                                  setState(() {
                                    // The button that is tapped is set to true, and the others to false.
                                    for (int i = 0;
                                        i < _languageSelect.length;
                                        i++) {
                                      _languageSelect[i] = i == index;
                                    }
                                    if (index == 1) {
                                      _title = _titleEnglish;
                                      _introduction = _introductionEnglish;
                                      _practice = _practiceEnglish;
                                    } else {
                                      _title = _titleChinese;
                                      _introduction = _introductionChinese;
                                      _practice = _practiceChinese;
                                    }
                                    Navigator.pop(context);
                                    introducePronunciationPractice();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.content_copy_outlined,
                                ),
                                color: Colors.grey,
                                alignment: Alignment.center,
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: _introduction[_testIndex]));
                                  final snackBar = SnackBar(
                                      content: Text('Copied to Clipboard'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                              ),
                              /*
                              Expanded(
                                flex: 1,
                                child: ToggleButtons(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  selectedBorderColor: PageTheme.app_theme_blue,
                                  selectedColor: Colors.white,
                                  fillColor: PageTheme.app_theme_blue,
                                  color: PageTheme.app_theme_blue,
                                  isSelected: _languageSelect,
                                  children: _languageContent,
                                  textStyle: TextStyle(fontSize: 12),
                                  onPressed: (int index) {
                                    setState(() {
                                      // The button that is tapped is set to true, and the others to false.
                                      for (int i = 0; i < _languageSelect.length; i++) {
                                        _languageSelect[i] = i == index;
                                      }
                                      if (index == 1){
                                        _title = _titleEnglish;
                                        _introduction = _introductionEnglish;
                                        _practice = _practiceEnglish;
                                      } else{
                                        _title = _titleChinese;
                                        _introduction = _introductionChinese;
                                        _practice = _practiceChinese;
                                      }
                                      Navigator.pop(context);
                                      introducePronunciationPractice();
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(Icons.content_copy_outlined,),
                                  color: Colors.grey,
                                  alignment: Alignment.center,
                                  onPressed: (){
                                    Clipboard.setData(ClipboardData(text: _introduction[_testIndex]));
                                    final snackBar = SnackBar(content: Text('Copied to Clipboard'));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                ),
                              ),
                              */
                            ],
                          )
                        ],
                      )),
                  Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icon/${_svgName[_testIndex]}.svg',
                              height: 150,
                            ),
                            Padding(padding: EdgeInsets.all(6)),
                            Text(
                              _introduction[_testIndex],
                              style: TextStyle(fontSize: 14),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Visibility(
                                    visible: (_testIndex != 0) &
                                        (_testIndex < _introduction.length - 1),
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: PageTheme
                                                  .cutom_article_practice_background)
                                        ],
                                      ),
                                      child: TextButton(
                                        child: Text(
                                          _practice,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        onPressed: () {
                                          AutoRouter.of(context).pushNamed(
                                              "/${_routeName[_testIndex - 1]}");
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Visibility(
                                  visible: _testIndex != 0,
                                  child: CircleAvatar(
                                    backgroundColor: PageTheme.app_theme_blue,
                                    radius: 24.0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.navigate_before,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _testIndex -= 1;
                                          Navigator.pop(context);
                                          introducePronunciationPractice();
                                        });
                                      },
                                    ),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '(${_testIndex + 1}/${_introduction.length})',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: PageTheme.app_theme_blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Visibility(
                                  visible:
                                      _testIndex < _introduction.length - 1,
                                  child: CircleAvatar(
                                    backgroundColor: PageTheme.app_theme_blue,
                                    radius: 24.0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.navigate_next,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _testIndex += 1;
                                          Navigator.pop(context);
                                          introducePronunciationPractice();
                                        });
                                      },
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }
  */
}
