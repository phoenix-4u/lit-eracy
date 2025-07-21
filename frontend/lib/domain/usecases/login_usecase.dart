import '../../data/repositories/auth_repository.dart';
import '../entities/user.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<Either<Failure, User>> execute(String username, String password) async {
    try {
      final userModel = await _repo.login(username, password);
      return Right(User(id: userModel.id, username: userModel.username, token: userModel.accessToken));
    } catch (e) {
      return Left(Failure("Login failed"));
    }
  }
}
