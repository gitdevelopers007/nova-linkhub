import 'package:flutter/material.dart';
import 'package:nova_linkhub/theme/app_theme.dart';
import 'package:nova_linkhub/login_page.dart';
import 'package:nova_linkhub/dashboard_page.dart';

void main() {
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
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
