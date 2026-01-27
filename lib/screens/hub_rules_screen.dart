import 'package:flutter/material.dart';

class HubRulesScreen extends StatelessWidget {
  HubRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.rule),
          title: Text('Only logged-in users can edit'),
        ),
        ListTile(
          leading: Icon(Icons.visibility),
          title: Text('Public users can view links'),
        ),
      ],
    );
  }
}
