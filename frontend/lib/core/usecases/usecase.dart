// # File: frontend/lib/core/usecases/usecase.dart

import 'package:dartz/dartz.dart';
import '../../domain/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
