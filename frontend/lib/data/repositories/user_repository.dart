import 'package:dio/dio.dart';

class UserRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8000'; // Replace with your API base URL

  Future<void> createUser(String email, String password) async {
    try {
      await _dio.post(
        '$_baseUrl/users/',
        data: {'email': email, 'password': password},
      );
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}
