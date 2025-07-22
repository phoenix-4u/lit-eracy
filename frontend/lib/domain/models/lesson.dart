class Lesson {
  final int id;
  final int grade;
  final String title;
  final String content;

  Lesson({
    required this.id,
    required this.grade,
    required this.title,
    required this.content,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      grade: json['grade'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grade': grade,
      'title': title,
      'content': content,
    };
  }
}
