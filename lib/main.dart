import 'package:flutter/material.dart';

void main() {
  runApp(const LinkCentralApp());
}

class LinkCentralApp extends StatelessWidget {
  const LinkCentralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LinkCentral',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF22C55E),
        fontFamily: 'Arial',
      ),
      home: const LoginPage(),
    );
  }
}

/* ---------------- LOGIN ---------------- */

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String error = '';

  void login() {
    if (!email.text.contains('@') || password.text.length < 6) {
      setState(() => error = 'Invalid email or password');
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('LinkCentral',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22C55E))),
              const SizedBox(height: 20),
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child:
                      Text(error, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                  ),
                  onPressed: login,
                  child: const Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- DASHBOARD ---------------- */

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<String> hubs = [];

  void createHub(String name) {
    setState(() => hubs.add(name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Your Hubs'),
        actions: [
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => CreateHubDialog(onCreate: createHub),
              );
            },
            icon: const Icon(Icons.add, color: Color(0xFF22C55E)),
            label: const Text('New Hub',
                style: TextStyle(color: Color(0xFF22C55E))),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: hubs.isEmpty
          ? const Center(
              child: Text('No hubs yet',
                  style: TextStyle(color: Colors.white54)),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: hubs
                    .map(
                      (h) => HubCard(
                        title: h,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => HubEditorPage(hubName: h)),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}

class HubCard extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;

  const HubCard({super.key, required this.title, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(onPressed: onEdit, child: const Text('Edit')),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PublicPage(title: title)),
                  );
                },
                child: const Text('View Public'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/* ---------------- CREATE HUB ---------------- */

class CreateHubDialog extends StatefulWidget {
  final Function(String) onCreate;
  const CreateHubDialog({super.key, required this.onCreate});

  @override
  State<CreateHubDialog> createState() => _CreateHubDialogState();
}

class _CreateHubDialogState extends State<CreateHubDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text('Create New Hub'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Hub Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              widget.onCreate(controller.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Create',
              style: TextStyle(color: Color(0xFF22C55E))),
        )
      ],
    );
  }
}

/* ---------------- HUB EDITOR ---------------- */

class HubEditorPage extends StatefulWidget {
  final String hubName;
  const HubEditorPage({super.key, required this.hubName});

  @override
  State<HubEditorPage> createState() => _HubEditorPageState();
}

class _HubEditorPageState extends State<HubEditorPage> {
  int tab = 0;
  bool isPublic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hubName),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tabBtn('Links', 0),
              tabBtn('Rules', 1),
              tabBtn('Settings', 2),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: getTab()),
        ],
      ),
    );
  }

  Widget tabBtn(String text, int i) {
    return TextButton(
      onPressed: () => setState(() => tab = i),
      child: Text(text,
          style: TextStyle(
              color:
                  tab == i ? const Color(0xFF22C55E) : Colors.white54)),
    );
  }

  Widget getTab() {
    if (tab == 0) {
      return const Center(child: Text('Add / Edit Links UI here'));
    }
    if (tab == 1) {
      return const Center(
          child: Text('Rules: Time / Device / Location'));
    }
    return Center(
      child: SwitchListTile(
        title: const Text('Public'),
        value: isPublic,
        onChanged: (v) => setState(() => isPublic = v),
      ),
    );
  }
}

/* ---------------- PUBLIC PAGE ---------------- */

class PublicPage extends StatelessWidget {
  final String title;
  const PublicPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.link, size: 60, color: Color(0xFF22C55E)),
          const SizedBox(height: 20),
          Text(title,
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          linkBtn('Instagram'),
          linkBtn('YouTube'),
          linkBtn('GitHub'),
          linkBtn('LinkedIn'),
          const SizedBox(height: 40),
          const Text('Powered by LinkCentral',
              style: TextStyle(color: Colors.white54))
        ]),
      ),
    );
  }

  Widget linkBtn(String name) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(name, textAlign: TextAlign.center),
    );
  }
}
