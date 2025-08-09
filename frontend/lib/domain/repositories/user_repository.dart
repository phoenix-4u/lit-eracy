import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/user_points.dart';

abstract class UserRepository {
  Future<Either<Failure, UserPoints>> getUserPoints(String userId);
  Future<Either<Failure, User>> getUserProfile(String userId);
}
