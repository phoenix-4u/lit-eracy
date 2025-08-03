// # File: frontend/lib/data/repositories/progress_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/remote/content_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ContentRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;

  ProgressRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, void>> updateProgress(int userId, int contentId,
      double completionPercentage, int timeSpent) async {
    try {
      await remoteDataSource.updateProgress(
          userId, contentId, completionPercentage, timeSpent);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update progress: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getUserProgress(int userId) async {
    try {
      final progress = await remoteDataSource.getUserProgress(userId);
      return Right(progress);
    } catch (e) {
      return Left(
          ServerFailure('Failed to get user progress: ${e.toString()}'));
    }
  }
}
