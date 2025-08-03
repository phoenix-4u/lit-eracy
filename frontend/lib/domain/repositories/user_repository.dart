// # File: frontend/lib/domain/repositories/user_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/error/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile(String userId);
  Future<Either<Failure, User>> updateUserProfile(User user);
  Future<Either<Failure, void>> deleteUser(String userId);
  Future<Either<Failure, List<User>>> getUsers({int? page, int? limit});
}
