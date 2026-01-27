import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/hub_links_screen.dart';

class Routes {
  static const login = '/';
  static const signup = '/signup';
  static const dashboard = '/dashboard';
  static const links = '/hub';

  static Map<String, WidgetBuilder> get all => {
        login: (_) => const LoginScreen(),
        signup: (_) => const SignupScreen(),
        dashboard: (_) => const DashboardScreen(),
        links: (_) => const HubLinksScreen(),
      };
}
