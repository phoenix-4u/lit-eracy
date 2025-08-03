// # File: frontend/lib/data/repositories/achievements_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/achievements_repository.dart';
import '../datasources/remote/content_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  final ContentRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;

  AchievementsRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<dynamic>>> getAchievements(int userId) async {
    try {
      final achievements = await remoteDataSource.getAchievements(userId);
      return Right(achievements);
    } catch (e) {
      return Left(ServerFailure('Failed to get achievements: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> unlockAchievement(
      int userId, int achievementId) async {
    try {
      await remoteDataSource.unlockAchievement(userId, achievementId);
      return const Right(null);
    } catch (e) {
      return Left(
          ServerFailure('Failed to unlock achievement: ${e.toString()}'));
    }
  }
}
