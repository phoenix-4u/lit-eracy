import '../../domain/entities/task.dart' as entity;

class TaskModel {
  final int id;
  final int lessonId;
  final String title;
  final String description;
  final int isCompleted;

  TaskModel(
      {required this.id,
      required this.lessonId,
      required this.title,
      required this.description,
      required this.isCompleted});

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as int,
        lessonId: json['lesson_id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        isCompleted: json['is_completed'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'lesson_id': lessonId,
        'title': title,
        'description': description,
        'is_completed': isCompleted,
      };

  entity.Task toEntity() => entity.Task(
        id: id,
        lessonId: lessonId,
        title: title,
        description: description,
        isCompleted: isCompleted == 1,
      );
}
