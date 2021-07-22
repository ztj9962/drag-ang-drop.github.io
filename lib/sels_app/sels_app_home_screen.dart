import 'models/tabIcon_data.dart';
import 'training/training_screen.dart';
import 'utils/SharedPreferencesUtil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'sels_app_theme.dart';
import 'my_diary/my_diary_screen.dart';
import 'homepage/homepage_screen.dart';
import 'others/others_screen.dart';


class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {


  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = HomePageScreen(animationController: animationController);
    super.initState();

    _initApplicationSettingsData();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      HomePageScreen(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      SettingScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }

  _initApplicationSettingsData() async {
    /*
    await SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsVolume').then((value) {
      (value);
    });
    await SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsPitch').then((value) {
      (value);
    });
    await SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsRate').then((value) {
      (value);
    });
    */

/*
    SharedPreferences prefs = await _prefs;

    prefs.setString("applicationSettingsDataListenAndSpeakLevel", (prefs.getString('applicationSettingsDataListenAndSpeakLevel') ?? 'A1'));
*/
    await SharedPreferencesUtil.getData<String>('applicationSettingsDataListenAndSpeakLevel').then((value) {
      (value ?? SharedPreferencesUtil.saveData<String>('applicationSettingsDataListenAndSpeakLevel', 'A1'));
    });
    await SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsVolume').then((value) {
      (value ?? SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsVolume', 1.0));
    });
    await SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsPitch').then((value) {
      (value ?? SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsPitch', 1.0));
    });
    await SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsRate').then((value) {
      (value ?? SharedPreferencesUtil.saveData<double>('applicationSettingsDataTtsRate', 0.5));
    });



  }


}
