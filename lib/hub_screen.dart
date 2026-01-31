import 'package:flutter/material.dart';
import 'hub_links_screen.dart';
import 'hub_rules_screen.dart';
import 'hub_settings_screen.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  int index = 0;

  final pages = [
    const HubLinksScreen(),
    const HubRulesScreen(),
    const HubSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("insta"),
        bottom: TabBar(
          onTap: (i) => setState(() => index = i),
          tabs: const [
            Tab(text: "Links"),
            Tab(text: "Rules"),
            Tab(text: "Settings"),
          ],
          controller: TabController(
            length: 3,
            vsync: ScaffoldState(),
          ),
        ),
      ),
      body: pages[index],
    );
  }
}
