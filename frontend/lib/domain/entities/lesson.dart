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
  final int estimatedDuration; // in minutes
  final List<String> objectives;
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
      // Backend uses 'subject' but you may want that in description
      description: json['subject'] as String? ?? '',
      // No 'content' field in JSON: use empty string or map a field if available
      content: json['content_data'] as String? ?? '',
      // Map 'grade_level' to your 'grade' property
      grade: json['grade_level'] as int,
      subject: json['subject'] as String,
      // Map 'difficulty_level' (int) to your 'difficulty' (String)
      difficulty: json['difficulty_level']?.toString() ?? '1',
      estimatedDuration: json['estimated_duration'] as int,
      objectives: const [],
      imageUrl: null,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'grade': grade,
      'subject': subject,
      'difficulty': difficulty,
      'estimated_duration': estimatedDuration,
      'objectives': objectives,
      'image_url': imageUrl,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Lesson copyWith({
    int? id,
    String? title,
    String? description,
    String? content,
    int? grade,
    String? subject,
    String? difficulty,
    int? estimatedDuration,
    List<String>? objectives,
    String? imageUrl,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      objectives: objectives ?? this.objectives,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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
