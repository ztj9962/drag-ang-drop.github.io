
import 'package:auto_route/auto_route.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sels_app/sels_app/models/auth_respository.dart';

class emailDialog extends StatefulWidget {
  @override
  _emailDialogState createState() => _emailDialogState();
}

class _emailDialogState extends State<emailDialog> {

  TextEditingController Emailcontroller = TextEditingController();

  @override
  void initState() {
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Passwordliss SignIn",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent[200],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin:
                    EdgeInsets.only(top: 30, bottom: 30, right: 30, left: 30),
                width: size.width * 0.7,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(200, 200, 214, 255),
                ),
                child: Center(
                  child: TextField(
                    controller: Emailcontroller ,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        size: 25,
                        color: Colors.indigo,
                      ),
                      hintText: "enter your email",
                      border: InputBorder.none,
                    ),
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  if(Emailcontroller.text.length>0){
                    authRespository.SendSignInWithEmailLink(Emailcontroller.text);
                  }
                },
                style:ElevatedButton.styleFrom(
                  maximumSize: Size(150,50),
                  minimumSize: Size(150,50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  primary: Colors.indigoAccent,
                ) ,
                child: Text("Submit"),),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
