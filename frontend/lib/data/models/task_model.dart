import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required int id,
    required String title,
    required String description,
    required bool isCompleted,
  }) : super(
          id: id,
          title: title,
          description: description,
          isCompleted: isCompleted,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }
}
