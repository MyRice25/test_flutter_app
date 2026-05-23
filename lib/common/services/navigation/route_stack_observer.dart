import 'package:flutter/material.dart';

class RouteStackObserver extends NavigatorObserver {
  RouteStackObserver._();

  static final RouteStackObserver instance = RouteStackObserver._();

  final List<Route<dynamic>> _stack = <Route<dynamic>>[];

  bool contains(String routeName) {
    return _stack.any((route) => route.settings.name == routeName);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      _stack.remove(oldRoute);
    }
    if (newRoute != null) {
      _stack.add(newRoute);
    }
  }
}
