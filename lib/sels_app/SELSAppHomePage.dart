import 'package:sels_app/sels_app/Pages/HomePage.dart';
import 'package:sels_app/sels_app/Pages/OthersPage.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';
import 'package:sels_app/sels_app/models/auth_Respository.dart';
import 'package:sels_app/sels_app/models/tabIcon_data.dart';
import 'package:sels_app/sels_app/utils/SharedPreferencesUtil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sels_app/sels_app/OtherViews/bottom_bar_view.dart';
import 'package:sels_app/sels_app/sels_app_theme.dart';
import 'package:uuid/uuid.dart';

class SELSAppHomePage extends StatefulWidget {
  @override
  _SELSAppHomePageState createState() => _SELSAppHomePageState();
}

class _SELSAppHomePageState extends State<SELSAppHomePage>
    with TickerProviderStateMixin {


  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _applicationSettingsSELSAppHomePageIntroduce = true;


  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: SELSAppTheme.background,
  );

  @override
  void initState() {
    _initApplicationSettingsData();

    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = HomePage(animationController: animationController);
    super.initState();

  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(
        //  centerTitle: true,
        //  title: Text('文法校正' ),
        //),
        body: Stack(
        children: <Widget>[
          Container(
            color: SELSAppTheme.background,
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
          ),

          Visibility(
            visible: _applicationSettingsSELSAppHomePageIntroduce,
            child: Stack(
                children: <Widget>[
                  Dismissible(
                      key: ValueKey('SELSAppHomePage_Introduce_01'),
                      onDismissed: (DismissDirection direction){
                        setState(() => _applicationSettingsSELSAppHomePageIntroduce = false);
                        SharedPreferencesUtil.saveData<bool>('applicationSettingsSELSAppHomePageIntroduce', _applicationSettingsSELSAppHomePageIntroduce);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('讓我們開始吧！'),
                        ));
                      },
                      child: ConstrainedBox(
                        child: Image.asset(
                          'assets/sels_app/SELSAppHomePage/SELSAppHomePage_Introduce_01.png',
                          fit: BoxFit.fill,
                        ),
                        constraints: new BoxConstraints.expand(),
                      )
                  ),
                ]
            ),
          ),


        ]
      )
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
                      HomePage(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      OthersPage(animationController: animationController);
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
    await SharedPreferencesUtil.getData<String>('applicationSettingsDataUUID').then((value) {
      (value ?? SharedPreferencesUtil.saveData<String>('applicationSettingsDataUUID', authRespository.getUid()));
    });
    SharedPreferencesUtil.saveData<String>('applicationSettingsDataUUID', authRespository.getUid());
    await SharedPreferencesUtil.getData<String>('applicationSettingsDataListenAndSpeakLevel').then((value) {
      (value ?? SharedPreferencesUtil.saveData<String>('applicationSettingsDataListenAndSpeakLevel', 'A1'));
    });
    await SharedPreferencesUtil.getData<double>('applicationSettingsDataListenAndSpeakRanking').then((value) {
      (value ?? SharedPreferencesUtil.saveData<double>('applicationSettingsDataListenAndSpeakRanking', 9602));
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
    await SharedPreferencesUtil.getData<String>('applicationSettingsDataAccessToken').then((value) {
      (value ?? APIUtil.getConversationTokenAndID());
    });
    await SharedPreferencesUtil.getData<String>('applicationSettingsDataConversationID').then((value) {
      (value ?? APIUtil.getConversationTokenAndID());
    });

    // 頁面介紹
    await SharedPreferencesUtil.getData<bool>('applicationSettingsSELSAppHomePageIntroduce').then((value) {
      (value ?? SharedPreferencesUtil.saveData<bool>('applicationSettingsSELSAppHomePageIntroduce', true));
    });
    await SharedPreferencesUtil.getData<bool>('applicationSettingsGrammarCheckPageIntroduce').then((value) {
      (value ?? SharedPreferencesUtil.saveData<bool>('applicationSettingsGrammarCheckPageIntroduce', true));
    });
    await SharedPreferencesUtil.getData<bool>('applicationSettingsPhoneticExercisesNewPageIntroduce').then((value) {
      (value ?? SharedPreferencesUtil.saveData<bool>('applicationSettingsPhoneticExercisesNewPageIntroduce', true));
    });



    SharedPreferencesUtil.getData<bool>('applicationSettingsSELSAppHomePageIntroduce').then((value) {
      setState(() => _applicationSettingsSELSAppHomePageIntroduce = value!);
    });



  }


}
