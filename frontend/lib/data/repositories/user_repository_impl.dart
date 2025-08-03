// # File: frontend/lib/data/repositories/content_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    try {
      final userData = await remoteDataSource.getUserProfile(userId);
      final user = User.fromJson(userData);

      // Cache user data
      await localDataSource.cacheUser(user);

      return Right(user);
    } on NetworkException {
      try {
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        } else {
          return const Left(CacheFailure('No cached user data'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile(User user) async {
    try {
      final userData = await remoteDataSource.updateUserProfile(user.toJson());
      final updatedUser = User.fromJson(userData);

      // Update cached user data
      await localDataSource.cacheUser(updatedUser);

      return Right(updatedUser);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    try {
      await remoteDataSource.deleteUser(userId);
      await localDataSource.clearAll();
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers({int? page, int? limit}) async {
    try {
      final usersData =
          await remoteDataSource.getUsers(page: page, limit: limit);
      final users =
          usersData.map((userData) => User.fromJson(userData)).toList();
      return Right(users);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
