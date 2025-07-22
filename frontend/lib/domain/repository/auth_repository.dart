import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String email, String password);
  Future<Either<Failure, void>> register(String email, String password);
}
