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
