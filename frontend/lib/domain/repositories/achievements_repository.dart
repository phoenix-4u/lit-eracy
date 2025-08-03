// # File: frontend/lib/domain/repositories/achievements_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/achievement.dart';
import '../../core/error/failures.dart';

abstract class AchievementsRepository {
  Future<Either<Failure, List<Achievement>>> getAchievements();
  Future<Either<Failure, void>> unlockAchievement(
      String userId, String achievementId);
  Future<Either<Failure, List<Achievement>>> getUserAchievements(String userId);
}
