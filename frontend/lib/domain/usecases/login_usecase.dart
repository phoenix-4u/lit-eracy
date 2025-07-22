// lib/domain/usecases/login_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/repositories/auth_repository.dart';


class LoginUseCase {
  final AuthRepository _repo;

  LoginUseCase(this._repo);

  Future<Either<Failure, String>> execute(String email, String password) async {
    try {
      final tokenResp = await _repo.login(email, password);
      return Right(tokenResp.accessToken);  // Success case
    } catch (e) {
      return Left(Failure("Login failed: ${e.toString()}"));  // Failure case
    }
  }
}
