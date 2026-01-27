import 'package:flutter/material.dart';

class PublicHubScreen extends StatelessWidget {
  const PublicHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Hub')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('Instagram'),
            subtitle: Text('instagram.com/you'),
          ),
          ListTile(
            title: Text('GitHub'),
            subtitle: Text('github.com/you'),
          ),
        ],
      ),
    );
  }
}
