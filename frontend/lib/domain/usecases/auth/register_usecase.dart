// # File: frontend/lib/domain/usecases/auth/register_usecase.dart

import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(params.userData);
  }
}

class RegisterParams {
  final Map<String, dynamic> userData;

  RegisterParams({required this.userData});
}
