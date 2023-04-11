import 'dart:io';

import 'package:alicsnet_app/page/login/email_password_dialog.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alicsnet_app/model/auth_respository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class SigninButton extends StatelessWidget {
  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              await authRespository.signInWithGoogle();
              bool signIn = await authRespository.isSignedIn();
              if (signIn == true) {
                await SharedPreferencesUtil.saveData<bool>('isSignin', true);
                AutoRouter.of(context).pop();
              }
            },
            style: TextButton.styleFrom(
              maximumSize: Size(250, 50),
              minimumSize: Size(250, 50),
              backgroundColor: Colors.indigoAccent[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              primary: Colors.grey,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 30,
                ),
                Text("使用 Google 登入",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            )
        ),
        SizedBox(
          height: 30,
        ),
        if (isIOS)
          TextButton(
              onPressed: () async {
                await authRespository.signInWithApple();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool signIn = await authRespository.isSignedIn();
                if (signIn == true) {
                  //print(authRespository.getUid());
                  await SharedPreferencesUtil.saveData<bool>('isSignin', true);
                  //AutoRouter.of(context).replaceNamed("/index");
                  AutoRouter.of(context).pop();
                }
              },
              style: TextButton.styleFrom(
                maximumSize: Size(250, 50),
                minimumSize: Size(250, 50),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                primary: Colors.grey,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.apple,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text("使用 Apple ID 登入",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              )
          ),
        if (isIOS)
          SizedBox(height: 30),
        TextButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (_){
                    return emailPasswordDialog();
                    //return emailDialog();
                  },
                  barrierDismissible: false
              );
            },
            style: TextButton.styleFrom(
              maximumSize: Size(250, 50),
              minimumSize: Size(250, 50),
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              primary: Colors.grey,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 30,
                ),
                Text("使用 Email 與密碼",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            )
        ),
        SizedBox(height: 30),
        TextButton(
            onPressed: () {
              AutoRouter.of(context).pop();
            },
            style: TextButton.styleFrom(
              maximumSize: Size(250, 50),
              minimumSize: Size(250, 50),
              backgroundColor: Colors.indigoAccent[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              primary: Colors.grey,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                FaIcon(
                  FontAwesomeIcons.angleLeft,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 30,
                ),
                Text("返回上一頁",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            )),
        SizedBox(
          height: 30,
        ),
        /*
        TextButton(
            onPressed: () async {
              await authRespository.signInWithTwitter();
              if(authRespository.isSignedIn()== true){
                AutoRouter.of(context).replaceNamed("/home");
              }
            },
            style: TextButton.styleFrom(
              maximumSize: Size(250, 50),
              minimumSize: Size(250, 50),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              primary: Colors.grey,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                FaIcon(
                  FontAwesomeIcons.twitter,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 30,
                ),
                Text("Sign in With Twitter",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            )),
        SizedBox(height: 30),
        TextButton(
            onPressed: () async {
             authRespository.signInWithFacebook();
             if(authRespository.isSignedIn()== true){
               AutoRouter.of(context).replaceNamed("/home");
             }
            },
            style: TextButton.styleFrom(
              maximumSize: Size(250, 50),
              minimumSize: Size(250, 50),
              backgroundColor: Colors.indigo[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              primary: Colors.grey,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                FaIcon(
                  FontAwesomeIcons.facebookF,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 30,
                ),
                Text("Sign in With Facebook",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            )),
        SizedBox(height: 30),
        TextButton(
            onPressed: () async {
                  showDialog(context: context, builder: (_){return emailDialog();},barrierDismissible: false);
                  //showGeneralDialog(context: context, pageBuilder:(_,__,___){return emailDialog();});
            },
            style: TextButton.styleFrom(
              maximumSize: Size(250, 50),
              minimumSize: Size(250, 50),
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              primary: Colors.grey,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 30,
                ),
                Text("Sign in With Email",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ))
            */
      ],
    );
  }
}
