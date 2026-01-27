import 'package:flutter/material.dart';

class HubSettingsScreen extends StatelessWidget {
  HubSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Private Hub'),
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text('Delete Hub'),
        ),
      ],
    );
  }
}
