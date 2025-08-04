// ## File: frontend/lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/local/local_storage_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;
  final Dio dio;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.dio,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // This is the success path
      final tokenResponseData = await remoteDataSource.login(email, password);

      final token = tokenResponseData['access_token'] as String?;
      if (token == null || token.isEmpty) {
        return const Left(AuthenticationFailure(
            'Login successful but no token was received.'));
      }

      await localDataSource.storeToken(token);

      final userProfileResponse = await dio.get(
        '/api/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final userModel = UserModel.fromJson(userProfileResponse.data);
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on AuthenticationException catch (e) {
      // This is the expected failure path for wrong credentials
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      // This is the expected failure path for other server errors
      return Left(ServerFailure(e.message));
    } catch (e) {
      // THIS IS THE MOST LIKELY PLACE THE ERROR IS BEING CAUGHT
      // This will catch the TypeError and wrap it in a Failure object.
      // The error message you see is coming from here.
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> register(Map<String, dynamic> userData) async {
    try {
      final newUserMap = await remoteDataSource.register(userData);
      final newUserModel = UserModel.fromJson(newUserMap);
      return Right(newUserModel);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
          ServerFailure('An unexpected error occurred during registration.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        await remoteDataSource.logout(token);
      }
    } catch (e) {
      // Don't block logout if server fails
    } finally {
      await localDataSource.clearAll();
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthenticationFailure('No refresh token available.'));
      }

      // FIX: The remote source returns a Map, we must extract the token from it.
      final responseData = await remoteDataSource.refreshToken(refreshToken);
      final newAccessToken = responseData['access_token'] as String;

      await localDataSource.storeToken(newAccessToken);
      return Right(newAccessToken);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Token refresh failed.'));
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
