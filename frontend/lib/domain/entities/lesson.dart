//  File: frontend/lib/domain/entities/lesson.dart

import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final int id;
  final String title;
  final String description;
  final String content;
  final int grade;
  final String subject;
  final String difficulty;
  final int estimatedDuration;
  final List objectives;
  final String? imageUrl;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.grade,
    required this.subject,
    required this.difficulty,
    required this.estimatedDuration,
    this.objectives = const [],
    this.imageUrl,
    this.isCompleted = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      // FIX: map the backend 'content' field, not 'content_data'
      content: json['content'] as String? ?? '',
      grade: json['grade_level'] as int,
      subject: json['subject'] as String,
      difficulty: json['difficulty_level']?.toString() ?? '1',
      estimatedDuration: json['estimated_duration'] as int,
      objectives: const [],
      imageUrl: json['image_url'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'grade_level': grade,
      'subject': subject,
      'difficulty_level': difficulty,
      'estimated_duration': estimatedDuration,
      'objectives': objectives,
      'image_url': imageUrl,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        grade,
        subject,
        difficulty,
        estimatedDuration,
        objectives,
        imageUrl,
        isCompleted,
        createdAt,
        updatedAt,
      ];
}
