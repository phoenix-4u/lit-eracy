import 'package:dio/dio.dart';
import '../models/token_response.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8000';

  Future<TokenResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/auth/login-email',
        data: {'email': email, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return TokenResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }


  Future<void> register(String email, String password) async {
    try {
      await _dio.post(
        '$_baseUrl/users/',
        data: {'email': email, 'password': password},
      );
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
