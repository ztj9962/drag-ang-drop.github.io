import 'package:auto_route/auto_route.dart';
import 'package:sels_app/sels_app/pages/account_info_page.dart';
import 'package:sels_app/sels_app/pages/sign_in_page/sign_in_page.dart';
import 'package:sels_app/sels_app/sels_app_home_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SignInPage, path: '/', initial: true),
    AutoRoute(page: SELSAppHomePage, path: '/home'),
    AutoRoute(page: AccountInfoPage,path:'/accountInfo')
  ],
)
class $AppRouter {}