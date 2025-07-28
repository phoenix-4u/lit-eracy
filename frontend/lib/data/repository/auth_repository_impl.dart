import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/config/api_config.dart';
import 'package:lit_eracy/domain/models/user.dart';
import 'package:lit_eracy/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      // Use form data format for OAuth2PasswordRequestForm
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      final response = await _dio.post(
        '/api/auth/login', // Correct endpoint path
        data: formData,
      );

      // Extract and store the token
      final accessToken = response.data['access_token'];
      final tokenType = response.data['token_type'];

      // Store token for future requests
      await _storeToken(accessToken);

      return Right(User(
        accessToken: accessToken,
        tokenType: tokenType,
      ));
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
        '/api/auth/register', // Correct endpoint path
        data: {
          'email': username, // Using username as email
          'username': username,
          'password': password,
          'full_name': null, // Optional field
        },
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // Helper method to store token
  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Helper method to retrieve stored token
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Helper method to clear token (for logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}
