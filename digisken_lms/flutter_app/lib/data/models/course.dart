class Course {
  final int id;
  final String title;
  final String description;
  final String instructor;
  final int lessons;
  final String category;
  final double rating;
  final int students;
  final String duration;
  final double price;
  final double progress;
  final String thumbnailEmoji;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.lessons,
    required this.category,
    required this.rating,
    required this.students,
    required this.duration,
    required this.price,
    required this.progress,
    required this.thumbnailEmoji,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      lessons: json['lessons'],
      category: json['category'] ?? 'General',
      rating: (json['rating'] ?? 0).toDouble(),
      students: json['students'] ?? 0,
      duration: json['duration'] ?? '4 weeks',
      price: (json['price'] ?? 0).toDouble(),
      progress: (json['progress'] ?? 0).toDouble(),
      thumbnailEmoji: json['thumbnailEmoji'] ?? '📚',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'lessons': lessons,
      'category': category,
      'rating': rating,
      'students': students,
      'duration': duration,
      'price': price,
      'progress': progress,
      'thumbnailEmoji': thumbnailEmoji,
    };
  }
}
