// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import 'package:sels_app/sels_app/pages/account_info_page.dart' as _i3;
import 'package:sels_app/sels_app/pages/sign_in_page/sign_in_page.dart' as _i1;
import 'package:sels_app/sels_app/sels_app_home_page.dart' as _i2;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SignInPage());
    },
    SELSAppHomeRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.SELSAppHomePage());
    },
    AccountInfoRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.AccountInfoPage());
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(SignInRoute.name, path: '/'),
        _i4.RouteConfig(SELSAppHomeRoute.name, path: '/home'),
        _i4.RouteConfig(AccountInfoRoute.name, path: '/accountInfo')
      ];
}

/// generated route for [_i1.SignInPage]
class SignInRoute extends _i4.PageRouteInfo<void> {
  const SignInRoute() : super(name, path: '/');

  static const String name = 'SignInRoute';
}

/// generated route for [_i2.SELSAppHomePage]
class SELSAppHomeRoute extends _i4.PageRouteInfo<void> {
  const SELSAppHomeRoute() : super(name, path: '/home');

  static const String name = 'SELSAppHomeRoute';
}

/// generated route for [_i3.AccountInfoPage]
class AccountInfoRoute extends _i4.PageRouteInfo<void> {
  const AccountInfoRoute() : super(name, path: '/accountInfo');

  static const String name = 'AccountInfoRoute';
}
