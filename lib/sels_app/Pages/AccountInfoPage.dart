import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sels_app/sels_app/Router/router.gr.dart';
import 'package:sels_app/sels_app/models/auth_Respository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_route/auto_route.dart';
class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String? name = FirebaseAuth.instance.currentUser!.displayName;
    String? email = FirebaseAuth.instance.currentUser!.email;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("帳戶資訊"),
          backgroundColor: Colors.indigoAccent[200],
        ),
        body: Stack(
          children: [
            ListView(
              children: ListTile.divideTiles(
                  color: Colors.black12,
                  context: context,
                  tiles: [
                    ListTile(
                      title: Text("UID"),
                      subtitle: Text('${uid}'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    ListTile(
                      title: Text("名稱"),
                      subtitle: Text('${name}'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    ListTile(
                      title: Text("電子信箱"),
                      subtitle: Text('${email}'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    )
                  ]).toList(),
            ),
            Positioned(
              top: 300,
              right: 50,
              left: 50,
              child: TextButton(
                child: Text(
                  "登出",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  authRespository.SignOut();
                  signOutState();
                  AutoRouter.of(context).replaceAll([SignInRoute()]);
                },
                style: TextButton.styleFrom(
                  maximumSize: Size(250, 50),
                  minimumSize: Size(250, 50),
                  backgroundColor: Colors.indigoAccent,
                  primary: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ));
  }
  signOutState()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isSignIn", false);
  }
}
