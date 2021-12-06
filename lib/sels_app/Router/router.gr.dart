// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../Pages/SignInPage/SignInPage.dart' as _i1;
import '../SELSAppHomePage.dart' as _i2;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SignInPage());
    },
    SELSAppHomeRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.SELSAppHomePage());
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(SignInRoute.name, path: '/'),
        _i3.RouteConfig(SELSAppHomeRoute.name, path: '/home')
      ];
}

/// generated route for [_i1.SignInPage]
class SignInRoute extends _i3.PageRouteInfo<void> {
  const SignInRoute() : super(name, path: '/');

  static const String name = 'SignInRoute';
}

/// generated route for [_i2.SELSAppHomePage]
class SELSAppHomeRoute extends _i3.PageRouteInfo<void> {
  const SELSAppHomeRoute() : super(name, path: '/home');

  static const String name = 'SELSAppHomeRoute';
}
