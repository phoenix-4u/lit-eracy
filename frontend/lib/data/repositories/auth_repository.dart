import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8000'; // Replace with your API base URL

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/token',
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return response.data['access_token'];
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
