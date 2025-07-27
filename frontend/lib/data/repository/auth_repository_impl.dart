import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/core/config.dart'; // Add this import
import 'package:lit_eracy/domain/models/user.dart';
import 'package:lit_eracy/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl)); // ✅ Use config

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      // ✅ Use form data format for OAuth2PasswordRequestForm
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      final response = await _dio.post(
        '/api/auth/login', // ✅ Correct endpoint path
        data: formData,
      );

      // ✅ The response contains access_token, not user data directly
      // You might need to get user data separately or update your User model
      return Right(User.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Login failed'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> register(
      String username, String password) async {
    try {
      await _dio.post(
        '/api/auth/register', // ✅ Correct endpoint path
        data: {
          'username': username,
          'password': password,
          'email': username, // ✅ Your backend expects email field
        },
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
