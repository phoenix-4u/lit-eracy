// # File: frontend/lib/data/repositories/progress_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../domain/entities/progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/content_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ContentRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;

  ProgressRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> updateProgress(
    String userId,
    String contentId,
    double completionPercentage,
    int timeSpent,
  ) async {
    try {
      await remoteDataSource.updateProgress(
          userId, contentId, completionPercentage, timeSpent);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Progress>> getUserProgress(String userId) async {
    try {
      final progressData = await remoteDataSource.getUserProgress(userId);
      final progress = Progress.fromJson(progressData);
      return Right(progress);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Progress>>> getProgressByContent(
      String contentId) async {
    try {
      final progressList =
          await remoteDataSource.getProgressByContent(contentId);
      final progress =
          progressList.map((data) => Progress.fromJson(data)).toList();
      return Right(progress);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
