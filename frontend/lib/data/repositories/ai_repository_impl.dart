import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../datasources/remote/ai_remote_datasource.dart';
import '../../domain/repositories/ai_repository.dart';
import '../models/task_model.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDataSource remoteDataSource;

  AIRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Task>> generateTaskForLesson(int lessonId) async {
    try {
      final model = await remoteDataSource.generateTaskForLesson(lessonId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
