import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class IntroductionUtil extends StatefulWidget {
  final List<Widget> listViews = <Widget>[];

  //final List<String> routeName;
  final List<String> svgName;

  final List<String> titleChinese;
  final List<String> titleEnglish;

  final List<String> introductionChinese;
  final List<String> introductionEnglish;

  IntroductionUtil({
    Key? key,
    //required this.routeName,
    required this.svgName,
    required this.titleChinese,
    required this.titleEnglish,
    required this.introductionChinese,
    required this.introductionEnglish,
  }) : super(key: key);

  @override
  _IntroductionUtilState createState() => _IntroductionUtilState();
}

class _IntroductionUtilState extends State<IntroductionUtil> {
  int _testIndex = 0;

  //late List<String> _routeName = widget.routeName;
  late List<String> _svgName = widget.svgName;

  List<Widget> _languageContent = <Widget>[Text('中文'), Text('English')];
  List<bool> _languageSelect = <bool>[true, false];

  /*
  String _practice = '';
  String _practiceChinese = '開始練習';
  String _practiceEnglish = 'Start Practice';
  */

  late List<String> _title = widget.titleChinese;
  late List<String> _titleChinese = widget.titleChinese;
  late List<String> _titleEnglish = widget.titleEnglish;

  late List<String> _introduction = widget.introductionChinese;
  late List<String> _introductionChinese = widget.introductionChinese;
  late List<String> _introductionEnglish = widget.introductionEnglish;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
        introducePronunciationPractice();
      },
    );
  }

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
              height: MediaQuery.of(context).size.height * 0.9,
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
                                      //_practice = _practiceEnglish;
                                    } else {
                                      _title = _titleChinese;
                                      _introduction = _introductionChinese;
                                      //_practice = _practiceChinese;
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
                            /*
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                /*  直接導向練習畫面
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
                                */
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                              ],
                            ),
                            */
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        //padding: EdgeInsets.only(top: 10),
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
                                child: Visibility(
                                  visible: _introduction.length > 1,
                                  child: Text(
                                    '(${_testIndex + 1}/${_introduction.length})',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: PageTheme.app_theme_blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                )),
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
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            //margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: PageTheme
                                        .cutom_article_practice_background)
                              ],
                            ),
                            child: TextButton(
                              child: Text(
                                '我知道了',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
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
