import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/models/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, void>> register(String username, String password);
}
