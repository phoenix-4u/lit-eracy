// File: frontend/lib/data/models/dashboard_model.dart

import 'dart:convert';

class Points {
  final int knowledgeGems;
  final int wordCoins;
  final int imaginationSparks;
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final String? lastActivityDate;

  Points({
    required this.knowledgeGems,
    required this.wordCoins,
    required this.imaginationSparks,
    required this.totalPoints,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
  });

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      knowledgeGems: json['knowledge_gems'],
      wordCoins: json['word_coins'],
      imaginationSparks: json['imagination_sparks'],
      totalPoints: json['total_points'],
      currentStreak: json['current_streak'],
      longestStreak: json['longest_streak'],
      lastActivityDate: json['last_activity_date'],
    );
  }
}

class LessonInfo {
  final int id;
  final String title;
  final String subject;
  final int gradeLevel;
  final int pointsReward;
  final int estimatedDuration;

  LessonInfo({
    required this.id,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    required this.pointsReward,
    required this.estimatedDuration,
  });

  factory LessonInfo.fromJson(Map<String, dynamic> json) {
    return LessonInfo(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      gradeLevel: json['grade_level'],
      pointsReward: json['points_reward'],
      estimatedDuration: json['estimated_duration'],
    );
  }
}

class Dashboard {
  final int numLessons;
  final Points points;
  final List<LessonInfo> recentLessons;
  final List<LessonInfo> recommendedContent;

  Dashboard({
    required this.numLessons,
    required this.points,
    required this.recentLessons,
    required this.recommendedContent,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      numLessons: json['num_lessons'],
      points: Points.fromJson(json['points']),
      recentLessons: (json['recent_lessons'] as List)
          .map((e) => LessonInfo.fromJson(e))
          .toList(),
      recommendedContent: (json['recommended_content'] as List)
          .map((e) => LessonInfo.fromJson(e))
          .toList(),
    );
  }

  static Dashboard fromRawJson(String str) =>
      Dashboard.fromJson(json.decode(str));
}
