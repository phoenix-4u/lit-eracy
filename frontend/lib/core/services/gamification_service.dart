// # File: frontend/lib/core/services/gamification_service.dart

import '../utils/constants.dart';

class GamificationService {
  static const Map<String, int> pointValues = {
    'lesson_completion': 10,
    'quiz_completion': 25,
    'ai_interaction': 15,
    'daily_streak': 5,
  };

  static int calculateKnowledgeGems(int lessonsCompleted) {
    return lessonsCompleted * pointValues['lesson_completion']!;
  }

  static int calculateWordCoins(int quizzesCompleted) {
    return quizzesCompleted * pointValues['quiz_completion']!;
  }

  static int calculateImaginationSparks(int aiInteractions) {
    return aiInteractions * pointValues['ai_interaction']!;
  }

  static int calculateStreakBonus(int streakDays) {
    return streakDays * pointValues['daily_streak']!;
  }

  static int calculateTotalPoints({
    required int knowledgeGems,
    required int wordCoins,
    required int imaginationSparks,
    required int streakBonus,
  }) {
    return knowledgeGems + wordCoins + imaginationSparks + streakBonus;
  }

  static List<String> getUnlockedAchievements({
    required int lessonsCompleted,
    required int quizzesCompleted,
    required int streakDays,
    required int aiInteractions,
    required int totalPoints,
  }) {
    final List<String> achievements = [];

    // First lesson
    if (lessonsCompleted >= 1) {
      achievements.add('first_lesson');
    }

    // Week streak
    if (streakDays >= 7) {
      achievements.add('week_streak');
    }

    // Quiz master
    if (quizzesCompleted >= 10) {
      achievements.add('quiz_master');
    }

    // AI friend
    if (aiInteractions >= 20) {
      achievements.add('ai_friend');
    }

    // Point milestones
    if (totalPoints >= 100) {
      achievements.add('century_club');
    }
    if (totalPoints >= 500) {
      achievements.add('point_champion');
    }
    if (totalPoints >= 1000) {
      achievements.add('learning_legend');
    }

    return achievements;
  }

  static String getAchievementTitle(String achievementId) {
    switch (achievementId) {
      case 'first_lesson':
        return 'First Steps';
      case 'week_streak':
        return 'Week Streak Champion';
      case 'quiz_master':
        return 'Quiz Master';
      case 'ai_friend':
        return 'AI Friend';
      case 'century_club':
        return 'Century Club';
      case 'point_champion':
        return 'Point Champion';
      case 'learning_legend':
        return 'Learning Legend';
      default:
        return 'Achievement';
    }
  }

  static String getAchievementDescription(String achievementId) {
    switch (achievementId) {
      case 'first_lesson':
        return 'Completed your first lesson!';
      case 'week_streak':
        return 'Learned for 7 days in a row!';
      case 'quiz_master':
        return 'Completed 10 quizzes with excellence!';
      case 'ai_friend':
        return 'Had 20 meaningful conversations with AI!';
      case 'century_club':
        return 'Earned 100 total points!';
      case 'point_champion':
        return 'Earned 500 total points!';
      case 'learning_legend':
        return 'Earned 1000 total points!';
      default:
        return 'Keep up the great work!';
    }
  }
}
