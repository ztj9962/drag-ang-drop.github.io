import 'package:alicsnet_app/page/new_template/index_learn_record_index_page.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/index/index_account_page.dart';
import 'package:alicsnet_app/page/index/index_home_page.dart';
import 'package:alicsnet_app/page/index/index_setting_page.dart';
import 'package:alicsnet_app/page/index/index_vocabulary_test_page.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int selectedIndex = 0;
  String selectedTitle = '';
  Widget tabBody = Container();
  List<Widget> containerList = [
    Container(
      color: PageTheme.index_body_background,
      child: const IndexHomePage(),
    ),
    /*
    Container(
      //color: PageTheme.index_body_background,
      child: const IndexLearnRecordIndexPage(),
    ),
     */
    Container(
      //color: PageTheme.index_body_background,
      child: const IndexVocabularyTestPage(),
    ),
    Container(
      //color: PageTheme.index_body_background,
      child: const IndexAccountPage(),
    ),
    Container(
      //color: PageTheme.index_body_background,
      child: const IndexSettingPage(),
    ),
  ];

  bool? _isSignin = false;

  @override
  void initState() {
    changePage(0);
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
        backgroundColor: PageTheme.app_theme_black,
        title: AutoSizeText(
          selectedTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 3.0,
            color: Color(0xFFFEFEFE),
          ),
          maxLines: 1,
        ),
        leadingWidth: 96,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: GestureDetector(
            child: SvgPicture.asset(
              'assets/sels_app/logo.svg',
              width: 40,
              //color: const Color(0xFFFEFEFE),
            ),
            onTap: () {
              //print('Tap logo');
            },
          ),
        ),
        actions: <Widget>[
          /*
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/icon/microphone.svg',
                width: 40,
                color: const Color(0xFFFEFEFE),
              ),
              onTap: (){
                //print('Tap microphone');
              },
            ),
          ),
           */
        ],
      ),
      body: tabBody,
      bottomNavigationBar: BottomNavigationBar(
        /// 这个很重要
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) {
          changePage(index);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/home.svg',
                width: 40,
                color: selectedIndex == 0
                    ? PageTheme.index_bottom_bar_icon_select
                    : PageTheme.index_bottom_bar_icon_no_select),
            label: '—',
          ),
          /*
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
                'assets/icon/learning_record.svg',
                width: 40,
                color: selectedIndex == 1 ? PageTheme.index_bottom_bar_icon_select : PageTheme.index_bottom_bar_icon_no_select
            ),
            label: '—',
          ),
           */
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/test.svg',
                width: 40,
                color: selectedIndex == 1
                    ? PageTheme.index_bottom_bar_icon_select
                    : PageTheme.index_bottom_bar_icon_no_select),
            label: '—',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/account.svg',
                width: 40,
                color: selectedIndex == 2
                    ? PageTheme.index_bottom_bar_icon_select
                    : PageTheme.index_bottom_bar_icon_no_select),
            label: '—',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/setting.svg',
                width: 40,
                color: selectedIndex == 3
                    ? PageTheme.index_bottom_bar_icon_select
                    : PageTheme.index_bottom_bar_icon_no_select),
            label: '—',
          ),
        ],
      ),
    );
  }

  Future<void> changePage(int index) async {
    await SharedPreferencesUtil.getData<bool>('isSignin').then((value) {
      setState(() => _isSignin = value);
    });

    int newIndex = index;
    String newTitle = "";

    switch (index) {
      /*
      case 1:
        newTitle = "學習記錄";
        break;
       */
      case 1:
        newTitle = "詞彙測驗";
        break;
      case 2:
        if (_isSignin != true) {
          AutoRouter.of(context).push(SignInRoute());
          changePage(0);
        }
        newTitle = "帳戶";
        break;
      case 3:
        newTitle = "設定";
        break;
      case 0:
      default:
        newIndex = 0;
        newTitle = "首頁";
    }

    setState(() {
      selectedIndex = newIndex;
      selectedTitle = newTitle;
      tabBody = containerList[newIndex];
    });
  }
}
