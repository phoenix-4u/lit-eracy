// ## File: frontend/lib/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      final user = User.fromJson(result['user']);

      // Store tokens locally
      await localDataSource.storeToken(result['token']);
      if (result['refresh_token'] != null) {
        await localDataSource.storeRefreshToken(result['refresh_token']);
      }

      // Cache user data
      await localDataSource.cacheUser(user);

      return Right(user);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> register(Map<String, dynamic> userData) async {
    try {
      final result = await remoteDataSource.register(userData);
      final user = User.fromJson(result['user']);

      // Store tokens locally
      await localDataSource.storeToken(result['token']);
      if (result['refresh_token'] != null) {
        await localDataSource.storeRefreshToken(result['refresh_token']);
      }

      // Cache user data
      await localDataSource.cacheUser(user);

      return Right(user);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        await remoteDataSource.logout(token);
      }

      // Clear local data
      await localDataSource.clearAll();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Logout failed'));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthenticationFailure('No refresh token available'));
      }

      final result = await remoteDataSource.refreshToken(refreshToken);
      await localDataSource.storeToken(result['token']);

      return Right(result['token']);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Token refresh failed'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await localDataSource.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await localDataSource.getCachedUser();
    } catch (e) {
      return null;
    }
  }
}
