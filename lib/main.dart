import 'package:flutter/material.dart';

void main() {
  runApp(const NovaLinkHub());
}

class NovaLinkHub extends StatelessWidget {
  const NovaLinkHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nova LinkHub',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.greenAccent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/' || settings.name == null) {
          return MaterialPageRoute(builder: (_) => const HomePage());
        }

        final uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 1) {
          final username = uri.pathSegments.first;
          return MaterialPageRoute(
            builder: (_) => ProfilePage(username: username),
          );
        }

        return MaterialPageRoute(builder: (_) => const HomePage());
      },
    );
  }
}

/* ---------------- HOME PAGE ---------------- */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.link, size: 72, color: Colors.greenAccent),
              const SizedBox(height: 16),
              const Text(
                'Nova LinkHub',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'One smart link for everything',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/gani'),
                child: const Text('View @gani'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/nova'),
                child: const Text('View @nova'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- PROFILE PAGE ---------------- */

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int totalClicks = 0;

  final List<Map<String, String>> links = [
    {'title': 'GitHub', 'url': 'https://github.com'},
    {'title': 'LinkedIn', 'url': 'https://linkedin.com'},
    {'title': 'Portfolio', 'url': 'https://example.com'},
  ];

  void trackClick() {
    setState(() {
      totalClicks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('@${widget.username}'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.greenAccent,
              child: Text(
                widget.username[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '@${widget.username}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Clicks: $totalClicks',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView.separated(
                itemCount: links.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      trackClick();
                    },
                    child: Text(links[index]['title']!),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
            Text(
              'Share: /${widget.username}',
              style: const TextStyle(color: Colors.greenAccent),
            ),
          ],
        ),
      ),
    );
  }
}