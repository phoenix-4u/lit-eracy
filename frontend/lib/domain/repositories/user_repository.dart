// # File: frontend/lib/domain/repositories/user_repository.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/user_points.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile(int userId);
  Future<Either<Failure, UserPoints>> getUserPoints(int userId);
  Future<Either<Failure, void>> updateUserPoints(int userId, UserPoints points);
}
