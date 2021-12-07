import 'package:auto_route/auto_route.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sels_app/sels_app/models/auth_Respository.dart';
import 'package:simple_animations/simple_animations.dart';
import 'FadeAnimation.dart';
import 'SigninButton.dart';


class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {

  /*void initState() {
    // TODO: implement initState
    initDynamicLinks();
    super.initState();
  }
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri deepLink = dynamicLink!.link;
          if (deepLink != null) {
            await authRespository.siginLink(deepLink, "m220131133@gmail.com");
            AutoRouter.of(context).replaceNamed("/home");
          }
        }, onError: (OnLinkErrorException e) async {
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
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
        body: Stack(
      children: [
         Positioned(
            top: 0,
            right: 0,
            child:opacityAnimation(1.0, Image.asset(
              "assets/sels_app/LoginPage/top1.png",
              width: size.width,
            ))),
        Positioned(
            top: 0,
            right: 0,
            child: opacityAnimation(1.0,Image.asset(
              "assets/sels_app/LoginPage/top2.png",
              width: size.width,
            ))),
        Positioned(
            bottom: 0,
            left: 0,
            child:opacityAnimation(1.0,Image.asset(
              "assets/sels_app/LoginPage/bottom1.png",
              width: size.width,
              color: Colors.indigoAccent[100],
            ))),
        Positioned(
            bottom: 0,
            left: 0,
            child: opacityAnimation(1.0,Image.asset(
              "assets/sels_app/LoginPage/bottom2.png",
              width: size.width,
            ))),
        Center(
          child: FadeAnimation(1.0,Container(
            width: size.width * 0.8,
            //height: size.height * 0.6,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(79, 112, 240, 200),
                    blurRadius: 20.0,
                  )
                ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.indigoAccent[400],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Choose login method"),
              SizedBox(height: 25),
              SigninButton(),
              SizedBox(height: 35,),
            ]),
          ))
          ),
      ],
    ));
  }
}
