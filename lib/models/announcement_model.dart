class AnnouncementModel {
  final String id;
  final String title;
  final String? body;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    this.body,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
