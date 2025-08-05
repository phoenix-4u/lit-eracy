// ## File: frontend/lib/data/models/task_model.dart (Final Corrected Version)

import '../../domain/entities/task.dart'; // Import your actual Task entity

// TaskModel is the concrete data object that extends the abstract Task entity.
class TaskModel extends Task {
  // --- THIS IS THE FIX ---
  // This constructor now uses 'super' to pass the EXACT parameters
  // required by your Task entity's constructor.
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.isCompleted,
    required super.lessonId,
  });

  // This factory constructor parses the JSON from your AI service
  // and creates a TaskModel instance.
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      // We assume the JSON keys from the AI match these names.
      // e.g., { "id": 1, "title": "...", "description": "...", "is_completed": false, "lesson_id": 101 }
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['is_completed'] as bool? ??
          false, // Safely handle null with a default
      lessonId: json['lesson_id'] as int,
    );
  }

  // A helper method to convert the model to the entity type.
  // Because TaskModel extends Task, it can just return itself.
  Task toEntity() {
    return this;
  }
}
