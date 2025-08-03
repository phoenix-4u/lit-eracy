// This file provides backward compatibility for imports
export '../entities/lesson.dart';

class Lesson {
  final int id;
  final String title;
  final String? description;
  final String contentType;
  final int? difficultyLevel;
  final String? ageGroup;
  final String? contentData;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Lesson({
    required this.id,
    required this.title,
    this.description,
    required this.contentType,
    this.difficultyLevel,
    this.ageGroup,
    this.contentData,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  // ✅ Add missing getters that your UI expects
  String? get content => contentData; // Map contentData to content
  int? get grade => difficultyLevel; // Map difficultyLevel to grade

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      contentType: json['content_type'] as String,
      difficultyLevel: json['difficulty_level'] as int?,
      ageGroup: json['age_group'] as String?,
      contentData: json['content_data'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
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
      'content_type': contentType,
      'difficulty_level': difficultyLevel,
      'age_group': ageGroup,
      'content_data': contentData,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
