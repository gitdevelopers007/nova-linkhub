import 'package:flutter/material.dart';
import 'models/hub_model.dart';
import 'widgets/create_hub_modal.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Hub> hubs = [];

  void openCreateHub() {
    showDialog(
      context: context,
      builder: (_) => CreateHubModal(
        onCreate: (title, desc) {
          setState(() {
            hubs.add(
              Hub(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                description: desc,
              ),
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.link, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      "Your Hubs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: openCreateHub,
                  icon: const Icon(Icons.add),
                  label: const Text("New Hub"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Expanded(
              child: hubs.isEmpty
                  ? _empty()
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: hubs.length,
                      itemBuilder: (_, i) => _hubCard(hubs[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.link, size: 60, color: Colors.white38),
          const SizedBox(height: 16),
          const Text(
            "No hubs yet",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: openCreateHub,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
            ),
            child: const Text("Create Your First Hub"),
          ),
        ],
      ),
    );
  }

  Widget _hubCard(Hub hub) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hub.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hub.description.isEmpty
                ? "No description"
                : hub.description,
            style: const TextStyle(color: Colors.white60),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/hub', arguments: hub);
                },
                child: const Text("Edit"),
              ),
              const Text(
                "View Public",
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
