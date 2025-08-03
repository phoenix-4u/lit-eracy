// ## File: frontend/lib/data/repositories/content_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/content.dart';
import '../../domain/repositories/content_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/content_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;

  ContentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Lesson>>> getLessons({int? grade}) async {
    try {
      final lessons = await remoteDataSource.getLessons(grade: grade);
      final lessonEntities =
          lessons.map((json) => Lesson.fromJson(json)).toList();

      // Cache lessons locally
      await localDataSource.cacheLessons(lessonEntities);

      return Right(lessonEntities);
    } on NetworkException {
      // Try to get cached lessons
      try {
        final cachedLessons = await localDataSource.getCachedLessons();
        return Right(cachedLessons);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

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
  Future<Either<Failure, List<Content>>> getContent() async {
    try {
      final content = await remoteDataSource.getContent();
      final contentEntities =
          content.map((json) => Content.fromJson(json)).toList();

      return Right(contentEntities);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Lesson>> getLessonById(int id) async {
    try {
      final lessonJson = await remoteDataSource.getLessonById(id);
      final lesson = Lesson.fromJson(lessonJson);

      return Right(lesson);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Content>> getContentById(int id) async {
    try {
      final contentJson = await remoteDataSource.getContentById(id);
      final content = Content.fromJson(contentJson);

      return Right(content);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
