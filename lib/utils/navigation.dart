import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NavigationRouteStyle {
  cupertino,
  material,
}

class Navigation {
  static Future<Future<T?>> navigateTo<T>({
    required BuildContext context,
    required Widget screen,
    required NavigationRouteStyle style,
  }) async {
    Route<T> route;
    if (style == NavigationRouteStyle.cupertino) {
      route = CupertinoPageRoute<T>(builder: (_) => screen);
      return Navigator.push<T>(context, route);
    } else if (style == NavigationRouteStyle.material) {
      route = MaterialPageRoute<T>(builder: (_) => screen);
      return Navigator.push<T>(context, route);
    } else {
      route = MaterialPageRoute<T>(builder: (_) => screen);
      return Navigator.push<T>(context, route);
    }
  }
}
