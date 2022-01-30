import 'package:flutter/material.dart';
import 'package:polynomial/ui/auth/auth_page.dart';
import 'package:polynomial/ui/error/error_screent.dart';
import 'package:polynomial/ui/home/home_page.dart';
import 'package:polynomial/ui/splash/splash_page.dart';

class Routes {
  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      final Object? args = routeSettings.arguments;
      switch (routeSettings.name) {
        case SplashPage.route:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => SplashPage(),
          );
        case AuthPage.route:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AuthPage(),
          );
        case HomePage.route:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => HomePage(),
          );
        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      return errorRoute(routeSettings);
    }
  }

  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => const ErrorScreen(),
    );
  }
}
