import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/models/user.dart';
import 'package:lit_eracy/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final response = await _dio
          .post('/login', data: {'username': username, 'password': password});
      return Right(User.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Login failed'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, void>> register(
      String username, String password) async {
    try {
      await _dio.post('/users/register',
          data: {'username': username, 'password': password});
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}
