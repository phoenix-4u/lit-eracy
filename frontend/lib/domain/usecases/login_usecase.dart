import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/models/user.dart';
import 'package:lit_eracy/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> execute(
      String username, String password) async {
    return await repository.login(username, password);
  }
}
