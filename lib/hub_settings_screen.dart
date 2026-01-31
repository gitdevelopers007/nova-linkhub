import 'package:flutter/material.dart';

class HubSettingsScreen extends StatelessWidget {
  const HubSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Public Hub"),
          value: true,
          onChanged: (v) {},
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Delete Hub"),
        )
      ],
    );
  }
}
