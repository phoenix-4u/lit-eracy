// # File: frontend/lib/domain/usecases/auth/register_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../entities/user.dart';
import '../../../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      params.username,
      params.email,
      params.password,
      params.fullName,
      params.age,
      params.grade,
    );
  }
}

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String fullName;
  final int? age;
  final int? grade;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    this.age,
    this.grade,
  });

  @override
  List<Object?> get props => [username, email, password, fullName, age, grade];
}
