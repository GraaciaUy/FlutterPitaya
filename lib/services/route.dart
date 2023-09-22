import 'package:flutter/material.dart';
import 'package:pitayaclinic/dashboard.dart';
import 'package:pitayaclinic/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/mainauth':
        return MaterialPageRoute(builder: (_) => const MainAuthPage());

      default:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
    }
  }
}
