// # File: frontend/lib/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(Map<String, dynamic> userData);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> refreshToken();
  Future<bool> isLoggedIn();
  Future<User?> getCurrentUser();
}
