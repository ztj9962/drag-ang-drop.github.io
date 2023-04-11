import 'dart:convert';

import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alicsnet_app/model/auth_respository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class emailPasswordDialog extends StatefulWidget {
  @override
  _emailPasswordDialogState createState() => _emailPasswordDialogState();
}

class _emailPasswordDialogState extends State<emailPasswordDialog> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  bool _showPassword = false;
  String _errorType = "";
  String _errorMessage = "";

  @override
  void initState() {
    // TODO: implement initState
    //initDynamicLinks();
    super.initState();
  }

  /*void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri deepLink = dynamicLink!.link;
          if (deepLink != null) {
             await authRespository.siginLink(deepLink, "m220131133@gmail.com");
             AutoRouter.of(context).replaceNamed("/home");
          }
        }, onError: ( e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();

    if (data!.link != null) {
      await authRespository.siginLink(data.link, "m220131133@gmail.com");
      AutoRouter.of(context).replaceNamed("/home");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Align(
      alignment: Alignment.center,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 15, bottom: 15, right: 30, left: 30),
              child: Text(
                "使用 Email與密碼 登入/註冊",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent[200],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 15, bottom: 15, right: 30, left: 30),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.7,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(200, 200, 214, 255),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.email,
                          size: 25,
                          color: Colors.indigo,
                        ),
                        hintText: "email",
                        border: InputBorder.none,
                      ),
                    ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 15, bottom: 15, right: 30, left: 30),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.7,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(200, 200, 214, 255),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _passwordcontroller,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          size: 25,
                          color: Colors.indigo,
                        ),
                        hintText: "password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: (!_showPassword)
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          color: Colors.indigo,
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  )
              ),
            ),
            Visibility(
                visible: _errorType != "",
                child: Text("${_errorType}: ${_errorMessage}",
                  style: TextStyle(color: Colors.red),)
            ),
            Visibility(
                visible: _errorType == "wrong-password",
                child:
                TextButton(
                    onPressed: () {
                      _sendPasswordResetLink(_emailcontroller.text);
                    },
                    child: const Text(
                        "忘記密碼？", style: TextStyle(color: Colors.blue))
                )
            ),
            Visibility(
                visible: _errorType == "notverified",
                child:
                TextButton(
                    onPressed: () {
                      _sendEmailVerificationLink(_emailcontroller.text);
                    },
                    child: const Text(
                        "重新發送 Email 驗證信", style: TextStyle(color: Colors.blue))
                )
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 15, bottom: 15, right: 30, left: 30),
              child: ElevatedButton(
                onPressed: () async {
                  String result = await authRespository.signInWithEmailPassword(
                      _emailcontroller.text, _passwordcontroller.text);
                  print("result: $result");

                  if (result == "success") {
                    setState(() {
                      _errorType = "";
                      _errorMessage = "";
                    });
                    bool signIn = await authRespository.isSignedIn();
                    if (signIn == true) {
                      await SharedPreferencesUtil.saveData<bool>(
                          'isSignin', true);
                      AutoRouter.of(context).pop();
                      AutoRouter.of(context).push(IndexRoute());
                      AutoRouter.of(context).replaceAll([IndexRoute()]);
                      context.router.popUntilRoot();
                    }
                  } else {
                    String errorType = result;
                    String errorMessage = result;

                    if (errorType == "empty") {
                      errorMessage = "請輸入Email與密碼";
                    } else if (errorType == "notverified") {
                      errorMessage = "此帳號已註冊，請前往驗證Email";
                    } else if (errorType == "invalid-email") {
                      errorMessage = "請輸入正確的Email格式";
                    } else if (errorType == "wrong-password") {
                      errorMessage = "密碼錯誤";
                    } else if (errorType == "weak-password") {
                      errorMessage = "密碼太簡單";
                    } else if (errorType == "too-many-requests") {
                      errorMessage = "請稍後再試";
                    } else {
                      errorMessage = "發生錯誤";
                    }


                    setState(() {
                      _errorType = errorType;
                      _errorMessage = errorMessage;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  maximumSize: Size(150, 50),
                  minimumSize: Size(150, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  primary: Colors.indigoAccent,
                ),
                child: Text("登入/註冊"),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  void _sendPasswordResetLink(String email) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.sendPasswordResetLink(email);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('已發送重設密碼信'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
  }

  void _sendEmailVerificationLink(String email) async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    var responseJSONDecode;
    try {
      int doLimit = 1;
      do {
        String responseJSON = await APIUtil.sendEmailVerificationLink(email);
        responseJSONDecode = jsonDecode(responseJSON.toString());
        if (responseJSONDecode['apiStatus'] != 'success') {
          doLimit += 1;
          if (doLimit > 1)
            throw Exception(
                'API: ' + responseJSONDecode['apiMessage']); // 只測 1 次
          await Future.delayed(Duration(seconds: 1));
        }
      } while (responseJSONDecode['apiStatus'] != 'success');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('已發送驗證信'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
    EasyLoading.dismiss();
  }
}