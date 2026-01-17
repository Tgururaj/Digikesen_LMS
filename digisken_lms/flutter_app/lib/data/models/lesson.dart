class Lesson {
  final int id;
  final String title;
  final String content;
  final String? videoUrl;
  final String contentType; // 'text', 'video', 'quiz'
  final int durationMinutes;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    this.videoUrl,
    required this.contentType,
    required this.durationMinutes,
    required this.isCompleted,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      videoUrl: json['videoUrl'],
      contentType: json['contentType'] ?? 'text',
      durationMinutes: json['durationMinutes'] ?? 5,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'videoUrl': videoUrl,
      'contentType': contentType,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
    };
  }
}
