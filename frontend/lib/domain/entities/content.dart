// File: frontend/lib/domain/entities/content.dart

import 'package:equatable/equatable.dart';

class Content extends Equatable {
  final int id;
  final String title;
  final String type; // lesson, quiz, story, activity
  final String content;
  final String? description;
  final int grade;
  final String subject;
  final String difficulty;
  final Map<String, dynamic>? metadata;
  final List<String> tags;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Content({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    this.description,
    required this.grade,
    required this.subject,
    required this.difficulty,
    this.metadata,
    this.tags = const [],
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      description: json['description'] as String?,
      grade: json['grade'] as int,
      subject: json['subject'] as String,
      difficulty: json['difficulty'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'content': content,
      'description': description,
      'grade': grade,
      'subject': subject,
      'difficulty': difficulty,
      'metadata': metadata,
      'tags': tags,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        content,
        description,
        grade,
        subject,
        difficulty,
        metadata,
        tags,
        imageUrl,
        isActive,
        createdAt,
        updatedAt,
      ];
}
