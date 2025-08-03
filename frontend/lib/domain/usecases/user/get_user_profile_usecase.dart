// # File: frontend/lib/domain/usecases/user/get_user_profile_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class GetUserProfileUseCase implements UseCase<User, GetUserProfileParams> {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserProfileParams params) async {
    return await repository.getUserProfile(params.userId);
  }
}

class GetUserProfileParams extends Equatable {
  final int userId;

  const GetUserProfileParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
