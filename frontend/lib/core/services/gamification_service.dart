// # File: frontend/lib/core/services/gamification_service.dart

import 'dart:async';
import 'storage_service.dart';

abstract class GamificationService {
  Future<int> getUserPoints();
  Future<void> addPoints(int points, String reason);
  Future<Map<String, int>> getPointsBreakdown();
  Future<List<Map<String, dynamic>>> getAchievements();
  Future<void> unlockAchievement(String achievementId);
  Future<int> getUserLevel();
  Future<int> getStreakDays();
  Future<void> updateStreak();
}

class GamificationServiceImpl implements GamificationService {
  final StorageService storageService;

  static const String _pointsKey = 'user_points';
  static const String _pointsBreakdownKey = 'points_breakdown';
  static const String _achievementsKey = 'achievements';
  static const String _levelKey = 'user_level';
  static const String _streakKey = 'streak_days';
  static const String _lastActivityKey = 'last_activity';

  GamificationServiceImpl({required this.storageService});

  @override
  Future<int> getUserPoints() async {
    return await storageService.get<int>(_pointsKey) ?? 0;
  }

  @override
  Future<void> addPoints(int points, String reason) async {
    final currentPoints = await getUserPoints();
    final newPoints = currentPoints + points;

    await storageService.store(_pointsKey, newPoints);

    // Update points breakdown
    final breakdown = await getPointsBreakdown();
    breakdown[reason] = (breakdown[reason] ?? 0) + points;
    await storageService.store(_pointsBreakdownKey, breakdown);

    // Check for level up
    await _checkLevelUp(newPoints);
  }

  @override
  Future<Map<String, int>> getPointsBreakdown() async {
    final breakdown =
        await storageService.get<Map<String, dynamic>>(_pointsBreakdownKey);
    return breakdown?.cast<String, int>() ?? <String, int>{};
  }

  @override
  Future<List<Map<String, dynamic>>> getAchievements() async {
    final achievements =
        await storageService.get<List<dynamic>>(_achievementsKey);
    return achievements?.cast<Map<String, dynamic>>() ??
        <Map<String, dynamic>>[];
  }

  @override
  Future<void> unlockAchievement(String achievementId) async {
    final achievements = await getAchievements();
    final existingIndex =
        achievements.indexWhere((a) => a['id'] == achievementId);

    if (existingIndex >= 0) {
      achievements[existingIndex]['unlocked'] = true;
      achievements[existingIndex]['unlockedAt'] =
          DateTime.now().toIso8601String();
    } else {
      achievements.add({
        'id': achievementId,
        'unlocked': true,
        'unlockedAt': DateTime.now().toIso8601String(),
      });
    }

    await storageService.store(_achievementsKey, achievements);
  }

  @override
  Future<int> getUserLevel() async {
    return await storageService.get<int>(_levelKey) ?? 1;
  }

  @override
  Future<int> getStreakDays() async {
    return await storageService.get<int>(_streakKey) ?? 0;
  }

  @override
  Future<void> updateStreak() async {
    final lastActivity = await storageService.get<String>(_lastActivityKey);
    final today = DateTime.now();
    final todayString = _dateString(today);

    if (lastActivity == null) {
      // First time
      await storageService.store(_streakKey, 1);
      await storageService.store(_lastActivityKey, todayString);
      return;
    }

    final lastActivityDate = DateTime.parse(lastActivity);
    final yesterday = today.subtract(const Duration(days: 1));

    if (_dateString(lastActivityDate) == _dateString(yesterday)) {
      // Continuing streak
      final currentStreak = await getStreakDays();
      await storageService.store(_streakKey, currentStreak + 1);
      await storageService.store(_lastActivityKey, todayString);
    } else if (_dateString(lastActivityDate) != todayString) {
      // Streak broken
      await storageService.store(_streakKey, 1);
      await storageService.store(_lastActivityKey, todayString);
    }
  }

  Future<void> _checkLevelUp(int points) async {
    final currentLevel = await getUserLevel();
    final newLevel = _calculateLevel(points);

    if (newLevel > currentLevel) {
      await storageService.store(_levelKey, newLevel);
      // Could trigger level up achievement here
    }
  }

  int _calculateLevel(int points) {
    // Simple level calculation: every 100 points = 1 level
    return (points / 100).floor() + 1;
  }

  String _dateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
