// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../pages/account_info_page.dart' as _i3;
import '../pages/purchase_page.dart' as _i4;
import '../pages/sign_in_page/sign_in_page.dart' as _i1;
import '../sels_app_home_page.dart' as _i2;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SignInPage());
    },
    SELSAppHomeRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.SELSAppHomePage());
    },
    AccountInfoRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.AccountInfoPage());
    },
    PurchaseRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.PurchasePage());
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(SignInRoute.name, path: '/'),
        _i5.RouteConfig(SELSAppHomeRoute.name, path: '/home'),
        _i5.RouteConfig(AccountInfoRoute.name, path: '/accountInfo'),
        _i5.RouteConfig(PurchaseRoute.name, path: '/purchase')
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i5.PageRouteInfo<void> {
  const SignInRoute() : super(SignInRoute.name, path: '/');

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.SELSAppHomePage]
class SELSAppHomeRoute extends _i5.PageRouteInfo<void> {
  const SELSAppHomeRoute() : super(SELSAppHomeRoute.name, path: '/home');

  static const String name = 'SELSAppHomeRoute';
}

/// generated route for
/// [_i3.AccountInfoPage]
class AccountInfoRoute extends _i5.PageRouteInfo<void> {
  const AccountInfoRoute() : super(AccountInfoRoute.name, path: '/accountInfo');

  static const String name = 'AccountInfoRoute';
}

/// generated route for
/// [_i4.PurchasePage]
class PurchaseRoute extends _i5.PageRouteInfo<void> {
  const PurchaseRoute() : super(PurchaseRoute.name, path: '/purchase');

  static const String name = 'PurchaseRoute';
}
