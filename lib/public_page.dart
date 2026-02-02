import 'package:flutter/material.dart';
import 'package:nova_linkhub/models/hub_model.dart';
import 'package:nova_linkhub/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb, defaultTargetPlatform

class PublicPage extends StatefulWidget {
  final String username;
  const PublicPage({super.key, required this.username});

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
  Hub? hub;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchHub();
  }

  bool _shouldShowLink(LinkItem link) {
    if (link.rules.isEmpty) return true;

    for (final rule in link.rules) {
      if (rule.type == 'time') {
        if (!_checkTimeRule(rule)) return false;
      } else if (rule.type == 'device') {
        if (!_checkDeviceRule(rule)) return false;
      }
    }
    return true;
  }

  bool _checkTimeRule(LinkRule rule) {
    if (rule.startTime == null || rule.endTime == null) return true;

    final now = TimeOfDay.now();
    final start = _parseTime(rule.startTime!);
    final end = _parseTime(rule.endTime!);

    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  bool _checkDeviceRule(LinkRule rule) {
    bool isMobile = false;

    if (kIsWeb) {
      // Simple UA check or width check could happen here,
      // but for Flutter Web 'defaultTargetPlatform' often returns correct value
      // based on UA.
      isMobile =
          (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);
    } else {
      isMobile =
          (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);
    }

    if (rule.device == 'mobile' && !isMobile) return false;
    if (rule.device == 'desktop' && isMobile) return false;

    return true;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _fetchHub() async {
    try {
      final res = await ApiService.get('/hubs/public/${widget.username}');
      setState(() {
        hub = Hub.fromJson(res);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!url.startsWith('http')) url = 'https://$url';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not launch URL")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null || hub == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            error ?? "Hub not found",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar / Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                hub!.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              if (hub!.bio.isNotEmpty)
                Text(
                  hub!.bio,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 48),

              // Links
              ...hub!.links
                  .where((link) => _shouldShowLink(link))
                  .map((link) => _linkButton(link)),

              const Spacer(),
              const Text(
                "Powered by NOVA",
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linkButton(LinkItem link) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchUrl(link.url),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Icon placeholder
                    const Icon(Icons.link, color: Colors.white, size: 20),
                    const SizedBox(width: 16),
                    Text(
                      link.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_outward,
                  color: Colors.white54,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
