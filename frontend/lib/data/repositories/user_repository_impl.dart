// # File: frontend/lib/data/repositories/content_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/remote/content_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;

  ContentRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<dynamic>>> getLessons(
      {String? subject, int? gradeLevel}) async {
    try {
      final lessons = await remoteDataSource.getLessons(
          subject: subject, gradeLevel: gradeLevel);
      return Right(lessons);
    } catch (e) {
      return Left(ServerFailure('Failed to get lessons: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getContent(
      {String? subject, int? gradeLevel}) async {
    try {
      final content = await remoteDataSource.getContent(
          subject: subject, gradeLevel: gradeLevel);
      return Right(content);
    } catch (e) {
      return Left(ServerFailure('Failed to get content: ${e.toString()}'));
    }
  }
}
