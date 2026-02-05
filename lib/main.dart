import 'package:flutter/material.dart';
import 'package:nova_linkhub/theme/app_theme.dart';
import 'package:nova_linkhub/login_page.dart';
import 'package:nova_linkhub/dashboard_page.dart';
import 'package:nova_linkhub/public_page.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy(); // Enable clean URLs without #
  runApp(const NovaApp());
}

class NovaApp extends StatelessWidget {
  const NovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NOVA LinkHub',
      theme: AppTheme.darkTheme,
      initialRoute: '/login', // Start at login
      onGenerateRoute: (settings) {
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
        if (settings.name == '/dashboard') {
          return MaterialPageRoute(builder: (_) => const DashboardPage());
        }

        // Dynamic Public Route: /username (clean URLs)
        final uri = Uri.parse(settings.name ?? '');
        if (uri.pathSegments.length == 1 &&
            uri.pathSegments[0] != 'login' &&
            uri.pathSegments[0] != 'dashboard') {
          final username = uri.pathSegments[0];
          return MaterialPageRoute(
            builder: (_) => PublicPage(username: username),
          );
        }

        return MaterialPageRoute(builder: (_) => const LoginPage());
      },
    );
  }
}
