import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_points.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../../domain/entities/dashboard_entity.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserPoints>> getUserPoints(String userId) async {
    try {
      final userPoints = await remoteDataSource.getUserPoints(userId);
      return Right(userPoints);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    try {
      final user = await remoteDataSource.getUserProfile(userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DashboardEntity>> fetchStudentDashboard(
      String token) async {
    try {
      final dashboardModel = await remoteDataSource.getStudentDashboard(token);
      return Right(DashboardEntity.fromModel(dashboardModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
