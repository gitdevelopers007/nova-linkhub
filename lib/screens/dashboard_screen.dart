import 'package:flutter/material.dart';
import '../routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Hubs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.login);
            },
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          _openCreateHub(context);
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            HubCard(title: 'gani'),
            HubCard(title: 'nova'),
          ],
        ),
      ),
    );
  }

  void _openCreateHub(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const CreateHubDialog(),
    );
  }
}

/* ================= HUB CARD ================= */

class HubCard extends StatelessWidget {
  final String title;
  const HubCard({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.links);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Public Hub',
              style: TextStyle(color: Colors.greenAccent),
            )
          ],
        ),
      ),
    );
  }
}

/* ================= CREATE HUB MODAL ================= */

class CreateHubDialog extends StatelessWidget {
  const CreateHubDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text('Create Hub'),
      content: TextField(
        decoration: InputDecoration(
          labelText: 'Hub name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
