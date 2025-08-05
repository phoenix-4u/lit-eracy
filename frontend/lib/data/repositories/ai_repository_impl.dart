
import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/error/exceptions.dart';
import 'package:lit_eracy/core/error/failures.dart';
import 'package:lit_eracy/data/datasources/remote/ai_remote_datasource.dart';
import 'package:lit_eracy/domain/repositories/ai_repository.dart';
import '../../domain/entities/task.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDataSource remoteDataSource;

  AIRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Task>> generateTaskForLesson(int lessonId) async {
    try {
      final task = await remoteDataSource.generateTaskForLesson(lessonId);
      return Right(task);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
