class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String statusAnnouncement;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.statusAnnouncement,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      statusAnnouncement: json['statusAnnouncement'],
    );
  }
}
