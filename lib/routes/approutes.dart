import 'package:flutter/material.dart';

import '../pages/home.dart';
import '../pages/sentlink.dart';
import '../pages/welcome.dart';

class AppRoutes {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case WelcomePage.route:
        return MaterialPageRoute(builder: (_) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: WelcomePage(),
          );
        });
      case VerificationPage.route:
        return MaterialPageRoute(builder: (_) {
          routeSettings.arguments as List<String>;
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: VerificationPage(),
          );
        });
      case HomePage.route:
        return MaterialPageRoute(builder: (_) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: HomePage(),
          );
        });
      default:
        return MaterialPageRoute(builder: (_) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Container(),
          );
        });
    }
  }
}
