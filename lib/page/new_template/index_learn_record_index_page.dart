import 'package:alicsnet_app/page/new_template/index_learn_record_score_page.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/page/page_theme.dart';

import 'dart:ui';

class IndexLearnRecordIndexPage extends StatefulWidget {
  const IndexLearnRecordIndexPage({Key? key}) : super(key: key);

  @override
  _IndexLearnRecordIndexPageState createState() =>
      _IndexLearnRecordIndexPageState();
}

class _IndexLearnRecordIndexPageState extends State<IndexLearnRecordIndexPage>
    with SingleTickerProviderStateMixin {
  late TabController mController; // tab控制器
  late Widget tabBody;
  int selectedIndex = 0;
  List<Widget> containerList = [
    Container(
      color: PageTheme.index_body_background,
      child: const IndexLearnRecordScorePage(),
    ),
    Container(
      color: PageTheme.index_body_background,
      //child: const IndexLearnRecordIndexPage(),

    ),
  ];
  final List<Tab> titleTabs = <Tab>[
    const Tab(
      child: Text(
        '測驗分數',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24,
          letterSpacing: 3.0,
        ),
      ),
    ),
    const Tab(
      child: Text(
        '我的收藏',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24,
          letterSpacing: 3.0,
        ),
      ),
    ),
  ];



  @override
  void initState() {
    changePage(0);
    mController =
        TabController(initialIndex: 0, length: titleTabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    mController.dispose(); // 当整个页面dispose时，记得把控制器也dispose掉，释放内存
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: mController,
        labelColor: PageTheme.learn_record_index_top_bar_select,
        unselectedLabelColor: PageTheme.learn_record_index_top_bar_no_select,
        indicatorColor: PageTheme.learn_record_index_top_bar_select,
        tabs: titleTabs,
        onTap: (int index) {
          changePage(index);
        },
      ),
      body: tabBody,
    );
  }

  void changePage(int index) {
    int newIndex = index;
    String newTitle = "";
    switch (index) {
      case 1:
        newTitle = "學習記錄";
        break;
      case 2:
        newTitle = "測驗";
        break;
      case 3:
        newTitle = "帳戶";
        break;
      case 4:
        newTitle = "設定";
        break;
      case 0:
      default:
        newIndex = 0;
        newTitle = "Home";
    }

    setState(() {
      selectedIndex = newIndex;
      tabBody = containerList[newIndex];
    });
  }
}
