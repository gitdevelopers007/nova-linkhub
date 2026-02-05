import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nova_linkhub/models/hub_model.dart';
import 'package:nova_linkhub/services/api_service.dart';
import 'package:nova_linkhub/public_page.dart';

class HubEditorPage extends StatefulWidget {
  final Hub hub;
  const HubEditorPage({super.key, required this.hub});

  @override
  State<HubEditorPage> createState() => _HubEditorPageState();
}

class _HubEditorPageState extends State<HubEditorPage> {
  late Hub hub;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    hub = widget.hub;
  }

  Future<void> _addLink(String label, String url) async {
    final newLinks = [...hub.links, LinkItem(label: label, url: url)];
    await _updateHubLinks(newLinks);
  }

  Future<void> _deleteLink(int index) async {
    final newLinks = [...hub.links];
    newLinks.removeAt(index);
    await _updateHubLinks(newLinks);
  }

  Future<void> _addLinkRule(int index, LinkRule rule) async {
    final link = hub.links[index];
    final updatedLink = LinkItem(
      label: link.label,
      url: link.url,
      clicks: link.clicks,
      rules: [...link.rules, rule],
    );
    final newLinks = [...hub.links];
    newLinks[index] = updatedLink;
    await _updateHubLinks(newLinks);
  }

  Future<void> _updateHubLinks(List<LinkItem> links) async {
    setState(() => isLoading = true);
    try {
      // Backend expects 'links': [{label, url, ...}]
      final linkData = links
          .map(
            (e) => {
              'label': e.label,
              'url': e.url,
              'rules': e.rules.map((r) => r.toJson()).toList(),
            },
          )
          .toList();

      await ApiService.put('/hubs/${hub.id}', {'links': linkData});

      setState(() {
        // Create new Hub object with updated links
        hub = Hub(
          id: hub.id,
          title: hub.title,
          username: hub.username,
          bio: hub.bio,
          views: hub.views,
          links: links,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showShareDialog(BuildContext context) {
    // Construct the public link (clean URL without hash)
    final String shareLink = "/${hub.username}";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        title: const Text("Share Hub", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Your unique public link:",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
              ),
              child: SelectableText(
                "https://your-site.netlify.app$shareLink",
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "(Replace 'your-site' with your Netlify URL)",
              style: TextStyle(color: Colors.white30, fontSize: 10),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy, size: 16),
            label: const Text("Copy Link"),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: shareLink));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Link copied!")));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(hub.title),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(text: "Links"),
              Tab(text: "Settings"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.greenAccent),
              onPressed: () => _showShareDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.public),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PublicPage(username: hub.username),
                  ),
                );
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _LinksTab(
                    links: hub.links,
                    onAdd: _addLink,
                    onDelete: _deleteLink,
                    onAddRule: _addLinkRule,
                  ),
                  _SettingsTab(hub: hub),
                ],
              ),
      ),
    );
  }
}

class _LinksTab extends StatelessWidget {
  final List<LinkItem> links;
  final Function(String, String) onAdd;
  final Function(int) onDelete;
  final Function(int, LinkRule) onAddRule;

  const _LinksTab({
    required this.links,
    required this.onAdd,
    required this.onDelete,
    required this.onAddRule,
  });

  void _showAddDialog(BuildContext context) {
    final labelCtrl = TextEditingController();
    final urlCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        title: const Text("Add Link", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Label"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "URL"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (labelCtrl.text.isNotEmpty && urlCtrl.text.isNotEmpty) {
                onAdd(labelCtrl.text, urlCtrl.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showRuleDialog(BuildContext context, int linkIndex, LinkItem link) {
    String ruleType = 'time';
    String? startTime;
    String? endTime;
    String? device = 'mobile';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF111111),
          title: const Text("Add Rule", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: ruleType,
                dropdownColor: const Color(0xFF222222),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'time', child: Text("Time Based")),
                  DropdownMenuItem(
                    value: 'device',
                    child: Text("Device Based"),
                  ),
                ],
                onChanged: (v) => setState(() => ruleType = v!),
              ),
              if (ruleType == 'time') ...[
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Start Time (HH:MM)",
                    hintText: "09:00",
                  ),
                  onChanged: (v) => startTime = v,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "End Time (HH:MM)",
                    hintText: "17:00",
                  ),
                  onChanged: (v) => endTime = v,
                ),
              ],
              if (ruleType == 'device')
                DropdownButton<String>(
                  value: device,
                  dropdownColor: const Color(0xFF222222),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(
                      value: 'mobile',
                      child: Text("Mobile Only"),
                    ),
                    DropdownMenuItem(
                      value: 'desktop',
                      child: Text("Desktop Only"),
                    ),
                  ],
                  onChanged: (v) => setState(() => device = v),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final rule = LinkRule(
                  type: ruleType,
                  startTime: startTime,
                  endTime: endTime,
                  device: device,
                );
                onAddRule(linkIndex, rule);
                Navigator.pop(context);
              },
              child: const Text("Save Rule"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: links.isEmpty
          ? const Center(
              child: Text(
                "No links yet",
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: links.length,
              itemBuilder: (context, index) {
                final link = links[index];
                return Card(
                  color: const Color(0xFF111111),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.link, color: Colors.white54),
                    title: Text(
                      link.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          link.url,
                          style: const TextStyle(color: Colors.white38),
                        ),
                        if (link.rules.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Wrap(
                              spacing: 8,
                              children: link.rules
                                  .map(
                                    (r) => Chip(
                                      label: Text(
                                        r.type == 'time'
                                            ? "${r.startTime}-${r.endTime}"
                                            : "${r.device}",
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      backgroundColor: Colors.green.withOpacity(
                                        0.2,
                                      ),
                                      labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.rule,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () =>
                              _showRuleDialog(context, index, link),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => onDelete(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _SettingsTab extends StatefulWidget {
  final Hub hub;
  const _SettingsTab({required this.hub});

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  late TextEditingController titleCtrl;
  late TextEditingController bioCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.hub.title);
    bioCtrl = TextEditingController(text: widget.hub.bio);
  }

  Future<void> _save() async {
    try {
      await ApiService.put('/hubs/${widget.hub.id}', {
        'title': titleCtrl.text,
        'bio': bioCtrl.text,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Saved!")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: titleCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: "Hub Title"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: bioCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: "Bio / Description"),
            maxLines: 3,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text("Save Changes"),
            ),
          ),
        ],
      ),
    );
  }
}
