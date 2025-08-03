// # File: frontend/lib/domain/usecases/user/get_user_profile_usecase.dart

import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';

class GetUserProfileUseCase implements UseCase<User, GetUserProfileParams> {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserProfileParams params) async {
    return await repository.getUserProfile(params.userId);
  }
}

class GetUserProfileParams {
  final String userId;

  GetUserProfileParams({required this.userId});
}
