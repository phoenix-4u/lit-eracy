// # File: frontend/lib/domain/entities/user_points.dart

import 'package:equatable/equatable.dart';

class UserPoints extends Equatable {
  final int knowledgeGems;
  final int wordCoins;
  final int imaginationSparks;
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;

  const UserPoints({
    required this.knowledgeGems,
    required this.wordCoins,
    required this.imaginationSparks,
    required this.totalPoints,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
  });

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      knowledgeGems: json['knowledge_gems'] ?? 0,
      wordCoins: json['word_coins'] ?? 0,
      imaginationSparks: json['imagination_sparks'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
      longestStreak: json['longest_streak'] ?? 0,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.parse(json['last_activity_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'knowledge_gems': knowledgeGems,
      'word_coins': wordCoins,
      'imagination_sparks': imaginationSparks,
      'total_points': totalPoints,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_activity_date': lastActivityDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        knowledgeGems,
        wordCoins,
        imaginationSparks,
        totalPoints,
        currentStreak,
        longestStreak,
        lastActivityDate,
      ];
}
