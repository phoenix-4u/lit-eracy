// # File: frontend/lib/domain/repositories/achievements_repository.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class AchievementsRepository {
  Future<Either<Failure, List<dynamic>>> getAchievements(int userId);
  Future<Either<Failure, void>> unlockAchievement(
      int userId, int achievementId);
}
