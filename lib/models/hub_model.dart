class Hub {
  final String id;
  String title;
  String description;
  bool isPublic;

  Hub({
    required this.id,
    required this.title,
    required this.description,
    this.isPublic = true,
  });
}
