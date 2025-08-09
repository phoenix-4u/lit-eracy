import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/user_points.dart';
import '../../repositories/user_repository.dart';

class GetUserPointsUseCase implements UseCase<UserPoints, String> {
  final UserRepository repository;

  GetUserPointsUseCase(this.repository);

  @override
  Future<Either<Failure, UserPoints>> call(String params) async {
    return await repository.getUserPoints(params);
  }
}
