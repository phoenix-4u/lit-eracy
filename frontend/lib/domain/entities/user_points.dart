// # File: frontend/lib/domain/entities/user_points.dart

import 'package:equatable/equatable.dart';

class UserPoints extends Equatable {
  final int userId;
  final int knowledgeGems;
  final int wordCoins;
  final int imaginationSparks;
  final int totalPoints;
  final int streakDays;
  final DateTime lastActivityDate;
  final int level;
  final int experiencePoints;
  final Map<String, int> subjectPoints;

  const UserPoints({
    required this.userId,
    required this.knowledgeGems,
    required this.wordCoins,
    required this.imaginationSparks,
    required this.totalPoints,
    required this.streakDays,
    required this.lastActivityDate,
    required this.level,
    required this.experiencePoints,
    this.subjectPoints = const {},
  });

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      userId: json['user_id'] as int,
      knowledgeGems: json['knowledge_gems'] as int? ?? 0,
      wordCoins: json['word_coins'] as int? ?? 0,
      imaginationSparks: json['imagination_sparks'] as int? ?? 0,
      totalPoints: json['total_points'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      lastActivityDate: DateTime.parse(json['last_activity_date'] as String),
      level: json['level'] as int? ?? 1,
      experiencePoints: json['experience_points'] as int? ?? 0,
      subjectPoints:
          Map<String, int>.from(json['subject_points'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'knowledge_gems': knowledgeGems,
      'word_coins': wordCoins,
      'imagination_sparks': imaginationSparks,
      'total_points': totalPoints,
      'streak_days': streakDays,
      'last_activity_date': lastActivityDate.toIso8601String(),
      'level': level,
      'experience_points': experiencePoints,
      'subject_points': subjectPoints,
    };
  }

  UserPoints copyWith({
    int? userId,
    int? knowledgeGems,
    int? wordCoins,
    int? imaginationSparks,
    int? totalPoints,
    int? streakDays,
    DateTime? lastActivityDate,
    int? level,
    int? experiencePoints,
    Map<String, int>? subjectPoints,
  }) {
    return UserPoints(
      userId: userId ?? this.userId,
      knowledgeGems: knowledgeGems ?? this.knowledgeGems,
      wordCoins: wordCoins ?? this.wordCoins,
      imaginationSparks: imaginationSparks ?? this.imaginationSparks,
      totalPoints: totalPoints ?? this.totalPoints,
      streakDays: streakDays ?? this.streakDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      subjectPoints: subjectPoints ?? this.subjectPoints,
    );
  }

  UserPoints addPoints({
    int knowledgeGems = 0,
    int wordCoins = 0,
    int imaginationSparks = 0,
    String? subject,
  }) {
    final newSubjectPoints = Map<String, int>.from(subjectPoints);
    if (subject != null) {
      newSubjectPoints[subject] = (newSubjectPoints[subject] ?? 0) +
          knowledgeGems +
          wordCoins +
          imaginationSparks;
    }

    final newTotalPoints =
        totalPoints + knowledgeGems + wordCoins + imaginationSparks;
    final newLevel = calculateLevel(newTotalPoints);

    return copyWith(
      knowledgeGems: this.knowledgeGems + knowledgeGems,
      wordCoins: this.wordCoins + wordCoins,
      imaginationSparks: this.imaginationSparks + imaginationSparks,
      totalPoints: newTotalPoints,
      level: newLevel,
      experiencePoints: newTotalPoints,
      subjectPoints: newSubjectPoints,
      lastActivityDate: DateTime.now(),
    );
  }

  UserPoints updateStreak() {
    final now = DateTime.now();
    final lastActivity = DateTime(
      lastActivityDate.year,
      lastActivityDate.month,
      lastActivityDate.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(lastActivity).inDays;

    int newStreakDays;
    if (difference == 0) {
      // Same day, no change
      newStreakDays = streakDays;
    } else if (difference == 1) {
      // Consecutive day, increment streak
      newStreakDays = streakDays + 1;
    } else {
      // Streak broken, reset
      newStreakDays = 1;
    }

    return copyWith(
      streakDays: newStreakDays,
      lastActivityDate: now,
    );
  }

  static int calculateLevel(int totalPoints) {
    // Level calculation: every 100 points = 1 level
    return (totalPoints / 100).floor() + 1;
  }

  int get pointsToNextLevel {
    final nextLevelPoints = level * 100;
    return nextLevelPoints - totalPoints;
  }

  double get levelProgress {
    final currentLevelPoints = (level - 1) * 100;
    final nextLevelPoints = level * 100;
    final progress = (totalPoints - currentLevelPoints) /
        (nextLevelPoints - currentLevelPoints);
    return progress.clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        userId,
        knowledgeGems,
        wordCoins,
        imaginationSparks,
        totalPoints,
        streakDays,
        lastActivityDate,
        level,
        experiencePoints,
        subjectPoints,
      ];

  @override
  String toString() {
    return 'UserPoints(userId: $userId, totalPoints: $totalPoints, level: $level, streak: $streakDays)';
  }
}
