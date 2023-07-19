import 'package:alicsnet_app/page/index/index_page.dart';
import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alicsnet_app/model/auth_respository.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexAccountPage extends StatefulWidget {
  const IndexAccountPage({Key? key}) : super(key: key);

  @override
  _IndexAccountPageState createState() => _IndexAccountPageState();
}

class _IndexAccountPageState extends State<IndexAccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(0),
              child: accountBanner(),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
            ),
            /*
            Container(
              padding: const EdgeInsets.all(0),
              child: accountOptions(),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
            ),
             */
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 24)),
                  shape: MaterialStateProperty.all(const StadiumBorder(
                      side: BorderSide(style: BorderStyle.solid))), //圆角弧度
                ),
                child: const Text('刪除帳號'),
                onPressed: () async {
                  clickDeleteAccountButton(context);
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 24)),
                  shape: MaterialStateProperty.all(const StadiumBorder(
                      side: BorderSide(style: BorderStyle.solid))), //圆角弧度
                ),
                child: const Text('登        出'),
                onPressed: () async {
                  authRespository.SignOut();
                  await SharedPreferencesUtil.saveData<bool>('isSignin', false);
                  AutoRouter.of(context).push(IndexRoute());
                  AutoRouter.of(context).replaceAll([IndexRoute()]);
                  context.router.popUntilRoot();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountBanner() {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 64,
                      height: 64,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            FirebaseAuth.instance.currentUser?.photoURL ??
                                'https://picsum.photos/100/100'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            '${FirebaseAuth.instance.currentUser?.displayName}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            '${FirebaseAuth.instance.currentUser?.email}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            '${FirebaseAuth.instance.currentUser?.uid}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 1,
                          )
                        ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(''),
                  ),
                  /*
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5B34E),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset('assets/icon/leaderboard.svg'),
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            AutoSizeText(
                              '排行榜',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: 1.0
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),

                   */
                ],
              )),
          /*
          Expanded(
            flex: 1,
            child: Container(
                color: Color(0xFFECF1F9),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget> [
                          Expanded(
                            flex: 1,
                            child: Center(child: Text('等級', style: TextStyle(color:Color(0xFF3B52A2), fontSize: 14, fontWeight: FontWeight.bold))),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('一般', style: TextStyle(color:Color(0xFF3B52A2), fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(child: Text('剩餘天數', style: TextStyle(color:Color(0xFF3B52A2), fontSize: 14, fontWeight: FontWeight.bold))),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('60天', style: TextStyle(color:Color(0xFF3B52A2), fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFFD5E492), Color(0xFF6FACDE)]),

                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: const Text(
                              '加購學習天數',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Color(0xFF000000),
                                  fontSize: 16,
                                  letterSpacing: 3.0
                              )
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),


                  ],
                )
            ),
          ),
          */
        ],
      ),
    );
  }

  Widget accountOptions() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          height: 50,
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('英語測驗',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: Transform.rotate(
                      angle: 0.5,
                      child:
                          SvgPicture.asset('assets/icon/drop_down_arrow.svg'),
                    ),
                  ),
                  onTap: () {
                    //print('aa');
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
          color: Colors.black,
        ),
        Container(
          height: 50,
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('個人資訊',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: Transform.rotate(
                      angle: 0.5,
                      child:
                          SvgPicture.asset('assets/icon/drop_down_arrow.svg'),
                    ),
                  ),
                  onTap: () {
                    //print('aa');
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
          color: Colors.black,
        ),
        Container(
          height: 50,
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('學習提醒',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: Transform.rotate(
                      angle: 0.5,
                      child:
                          SvgPicture.asset('assets/icon/drop_down_arrow.svg'),
                    ),
                  ),
                  onTap: () {
                    //print('aa');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void clickDeleteAccountButton(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('確定要刪除帳號嗎？'),
            content: Text(
                '刪除帳號後，所有資料將無法復原，包含：\n- 會員資料\n- 過往AlicsPro訂購資訊\n- 其它一切與帳號相關的任何資料'),
            actions: <Widget>[
              TextButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('確定'),
                onPressed: () async {
                  authRespository.deleteAccount();
                  await SharedPreferencesUtil.saveData<bool>('isSignin', false);
                  AutoRouter.of(context).push(IndexRoute());
                  AutoRouter.of(context).replaceAll([IndexRoute()]);
                  context.router.popUntilRoot();
                },
              ),
            ],
          );
        });
  }
}
