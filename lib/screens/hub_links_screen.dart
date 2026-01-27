import 'package:flutter/material.dart';

class HubLinksScreen extends StatelessWidget {
  const HubLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('gani'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Links'),
              Tab(text: 'Rules'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Links coming soon')),
            Center(child: Text('Rules coming soon')),
            Center(child: Text('Settings coming soon')),
          ],
        ),
      ),
    );
  }
}
