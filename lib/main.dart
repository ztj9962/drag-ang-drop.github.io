import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:alicsnet_app/model/purchase_provider_model.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alicsnet_app/page/page_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp(isSignin: prefs.getBool("isSignIn"),)));
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  bool? isSignin;
  MyApp({bool? isSignin}):isSignin = isSignin;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PurchaseProviderModel>(create: (context) => PurchaseProviderModel()),
    ],
    child:
    MaterialApp.router(
      title: 'English Study',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: PageTheme.fontName,
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      routerDelegate: _appRouter.delegate(initialRoutes: [isSignin == true ? IndexRoute() : SignInRoute(),]),
      routeInformationParser:_appRouter.defaultRouteParser(),
    ),);
  }
}