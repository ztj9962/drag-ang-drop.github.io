import 'dart:convert';

import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TongueTwistersIndexPage extends StatefulWidget {
  const TongueTwistersIndexPage({Key? key}) : super(key: key);

  @override
  _TongueTwistersIndexPage createState() => _TongueTwistersIndexPage();
}

class _TongueTwistersIndexPage extends State<TongueTwistersIndexPage> {
  @override
  void initState() {
    super.initState();
    //initTongueTwistersIndexPage();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PageTheme.app_theme_black,
          centerTitle: true,
          title: AutoSizeText(
            '英語繞口令練習',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: SingleChildScrollView(

        )
    );
  }
}