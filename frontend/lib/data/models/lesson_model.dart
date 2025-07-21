class LessonModel {
  final int id;
  final int grade;
  final String title;
  final String content;

  LessonModel({
    required this.id,
    required this.grade,
    required this.title,
    required this.content,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
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
