// # File: frontend/lib/data/repositories/achievements_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/achievements_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/content_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  final ContentRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;

  AchievementsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Achievement>>> getAchievements() async {
    try {
      final achievements = await remoteDataSource.getAchievements();
      final achievementEntities =
          achievements.map((json) => Achievement.fromJson(json)).toList();

      // Cache achievements locally
      await localDataSource.cacheAchievements(achievementEntities);

      return Right(achievementEntities);
    } on NetworkException {
      // Try to get cached achievements
      try {
        final cachedAchievements =
            await localDataSource.getCachedAchievements();
        return Right(cachedAchievements);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> unlockAchievement(
      String userId, String achievementId) async {
    try {
      await remoteDataSource.unlockAchievement(userId, achievementId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getUserAchievements(
      String userId) async {
    try {
      final achievements = await remoteDataSource.getUserAchievements(userId);
      final achievementEntities =
          achievements.map((json) => Achievement.fromJson(json)).toList();
      return Right(achievementEntities);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
