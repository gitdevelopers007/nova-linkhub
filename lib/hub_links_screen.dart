import 'package:flutter/material.dart';

class HubLinksScreen extends StatelessWidget {
  const HubLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Add Link"),
      ),
    );
  }
}
