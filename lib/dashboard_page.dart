import 'package:flutter/material.dart';
import 'package:nova_linkhub/models/hub_model.dart';
import 'package:nova_linkhub/services/api_service.dart';
import 'package:nova_linkhub/widgets/create_hub_modal.dart';
import 'package:nova_linkhub/hub_editor_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Hub> hubs = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchHubs();
  }

  Future<void> _fetchHubs() async {
    setState(() => isLoading = true);
    try {
      final res = await ApiService.get('/hubs');
      if (res is List) {
        setState(() {
          hubs = res.map((x) => Hub.fromJson(x)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void openCreateHub() {
    showDialog(
      context: context,
      builder: (_) => CreateHubModal(
        onCreate: (title, description) async {
          try {
            // Need to generate a username or ask for it.
            // For now, let's generate one from title + random
            final username =
                "${title.replaceAll(' ', '').toLowerCase()}${DateTime.now().millisecondsSinceEpoch % 1000}";

            await ApiService.post('/hubs', {
              'title': title,
              'bio': description,
              'username': username,
            });
            _fetchHubs(); // Refresh
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error creating hub: $e")));
          }
        },
      ),
    );
  }

  void _logout() async {
    await ApiService.logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
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
                  children: [
                    Icon(
                      Icons.link,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Your Hubs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: openCreateHub,
                      icon: const Icon(Icons.add),
                      label: const Text("New Hub"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text("Logout"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white54,
                        side: const BorderSide(color: Colors.white24),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                  ? Center(
                      child: Text(
                        "Error: $error",
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : hubs.isEmpty
                  ? _empty()
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 1.5,
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
          const Icon(Icons.link_off, size: 60, color: Colors.white12),
          const SizedBox(height: 16),
          const Text(
            "No hubs yet",
            style: TextStyle(color: Colors.white38, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: openCreateHub,
            child: const Text("Create your first hub"),
          ),
        ],
      ),
    );
  }

  Widget _hubCard(Hub hub) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.hub, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hub.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              hub.bio.isEmpty ? "No description" : hub.bio,
              style: const TextStyle(color: Colors.white54, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HubEditorPage(hub: hub)),
                  ).then((_) => _fetchHubs()); // Refresh on return
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text("Edit"),
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.visibility,
                      size: 14,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${hub.views}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
