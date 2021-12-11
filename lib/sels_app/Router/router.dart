import 'package:auto_route/auto_route.dart';
import 'package:sels_app/sels_app/Pages/AccountInfoPage.dart';
import 'package:sels_app/sels_app/Pages/SignInPage/SignInPage.dart';

import '../SELSAppHomePage.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SignInPage, path: '/', initial: true),
    AutoRoute(page: SELSAppHomePage, path: '/home'),
    AutoRoute(page: AccountInfoPage,path:'/accountInfo')
  ],
)
class $AppRouter {}