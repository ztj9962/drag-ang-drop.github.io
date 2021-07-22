import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
    this.icon = '',
    this.selectedIcon = '',
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  var icon;
  String selectedIcon;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/sels_app/tab_1.png',
      selectedImagePath: 'assets/sels_app/tab_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
      icon: Icon(Icons.home),
    ),
    TabIconData(
      imagePath: 'assets/sels_app/tab_2.png',
      selectedImagePath: 'assets/sels_app/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,
      icon: Icon(Icons.info),
    ),
  ];
}
