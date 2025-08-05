// // ## File: frontend/lib/data/repositories/ai_repository_impl.dart

// import 'package:dartz/dartz.dart';
// import '../../core/error/exceptions.dart';
// import '../../core/error/failures.dart';
// import '../../data/datasources/remote/ai_remote_datasource.dart';
// import '../../domain/repositories/ai_repository.dart';

// // FIX 1: Import the task entity with the SAME prefix as the abstract repository.
// import '../../domain/entities/task.dart' as entity;
// // FIX 2: Import the task model to be used internally.
// import '../../data/models/task_model.dart';

// class AIRepositoryImpl implements AIRepository {
//   final AIRemoteDataSource remoteDataSource;

//   AIRepositoryImpl({required this.remoteDataSource});

//   @override
//   // FIX 3: The signature now perfectly matches the contract, using 'entity.Task'.
//   Future<Either<Failure, entity.Task>> generateTaskForLesson(int lessonId) async {
//     try {
//       // The remote data source returns a TaskModel.
//       final TaskModel taskModel = await remoteDataSource.generateTaskForLesson(lessonId);

//       // The .toEntity() method converts the model to the required entity type.
//       // This 'Right' now contains an 'entity.Task', which matches the signature.
//       return Right(taskModel.toEntity());
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }
// }

// ## File: frontend/lib/domain/repositories/ai_repository.dart (Final Corrected Version)

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

// FIX: Import the task entity with the SAME 'entity' prefix.
// This ensures both files are talking about the exact same class.
import '../entities/task.dart' as entity;

// This is the abstract "contract" that all implementations must follow.
abstract class AIRepository {
  // FIX: This signature now perfectly matches your implementation.
  // It uses the 'entity.Task' prefix and defines the exact return type.
  Future<Either<Failure, entity.Task>> generateTaskForLesson(int lessonId);
}
