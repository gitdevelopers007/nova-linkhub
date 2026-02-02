class Hub {
  final String id;
  final String title;
  final String username;
  final String bio;
  final List<LinkItem> links;
  final int views;

  Hub({
    required this.id,
    required this.title,
    required this.username,
    this.bio = '',
    this.links = const [],
    this.views = 0,
  });

  factory Hub.fromJson(Map<String, dynamic> json) {
    return Hub(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled Hub',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      views: json['views'] ?? 0,
      links:
          (json['links'] as List?)?.map((x) => LinkItem.fromJson(x)).toList() ??
          [],
    );
  }
}

class LinkItem {
  final String label;
  final String url;
  final int clicks;
  final List<LinkRule> rules;

  LinkItem({
    required this.label,
    required this.url,
    this.clicks = 0,
    this.rules = const [],
  });

  factory LinkItem.fromJson(Map<String, dynamic> json) {
    return LinkItem(
      label: json['label'] ?? '',
      url: json['url'] ?? '',
      clicks: json['clicks'] ?? 0,
      rules:
          (json['rules'] as List?)?.map((x) => LinkRule.fromJson(x)).toList() ??
          [],
    );
  }
}

class LinkRule {
  final String type; // 'time' or 'device'
  final String? startTime;
  final String? endTime;
  final String? device; // 'mobile' or 'desktop'

  LinkRule({required this.type, this.startTime, this.endTime, this.device});

  factory LinkRule.fromJson(Map<String, dynamic> json) {
    return LinkRule(
      type: json['type'] ?? '',
      startTime: json['startTime'],
      endTime: json['endTime'],
      device: json['device'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      if (device != null) 'device': device,
    };
  }
}
