import 'package:equatable/equatable.dart';

class Progress extends Equatable {
  final String id;
  final String userId;
  final String contentId;
  final double completionPercentage;
  final int timeSpent; // in minutes
  final DateTime lastAccessed;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Progress({
    required this.id,
    required this.userId,
    required this.contentId,
    required this.completionPercentage,
    required this.timeSpent,
    required this.lastAccessed,
    required this.createdAt,
    this.updatedAt,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      contentId: json['content_id'] as String,
      completionPercentage: (json['completion_percentage'] as num).toDouble(),
      timeSpent: json['time_spent'] as int,
      lastAccessed: DateTime.parse(json['last_accessed'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content_id': contentId,
      'completion_percentage': completionPercentage,
      'time_spent': timeSpent,
      'last_accessed': lastAccessed.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Progress copyWith({
    String? id,
    String? userId,
    String? contentId,
    double? completionPercentage,
    int? timeSpent,
    DateTime? lastAccessed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Progress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contentId: contentId ?? this.contentId,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      timeSpent: timeSpent ?? this.timeSpent,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        contentId,
        completionPercentage,
        timeSpent,
        lastAccessed,
        createdAt,
        updatedAt,
      ];
}
