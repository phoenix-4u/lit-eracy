// ## File: frontend/lib/data/datasources/remote/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../config/api_config.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  // Helper function to safely parse FastAPI error details
  // String _parseErrorDetail(dynamic detail) {
  //   if (detail is String) {
  //     return detail;
  //   }
  //   if (detail is List && detail.isNotEmpty) {
  //     final firstError = detail[0];
  //     if (firstError is Map && firstError.containsKey('msg')) {
  //       return firstError['msg'];
  //     }
  //   }
  //   return 'An unknown server error occurred.';
  // }

  String _parseErrorDetail(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('detail')) {
      final detail = responseData['detail'];
      if (detail is String) {
        return detail;
      }
      if (detail is List && detail.isNotEmpty) {
        final firstError = detail[0];
        if (firstError is Map && firstError.containsKey('msg')) {
          return firstError['msg'];
        }
      }
    }
    return 'An unknown server error occurred.';
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };

      final response = await dio.post(
        ApiConfig.loginEndpoint,
        data: requestBody,
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw ServerException(
            'Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // THIS IS THE CRITICAL SECTION
      // When an error occurs, we must throw an exception.
      // We should not let the execution continue or return null.
      if (e.response?.statusCode == 401) {
        final errorMessage = _parseErrorDetail(e.response?.data);
        throw AuthenticationException(errorMessage);
      }
      final errorMessage = _parseErrorDetail(e.response?.data);
      throw ServerException(errorMessage);
    } catch (e) {
      // This catches non-Dio errors, like the TypeError if it happens before the call.
      // This confirms the error is happening before the dio.post call.
      throw ServerException(
          'An unexpected client-side error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await dio.post(
        ApiConfig.registerEndpoint,
        data: userData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw ServerException(
            'Registration failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // FIX: Use the robust error parser
      final errorMessage = _parseErrorDetail(e.response?.data['detail']);
      if (e.response?.statusCode == 422) {
        throw ValidationException(errorMessage);
      }
      throw ServerException(errorMessage);
    } catch (e) {
      throw const ServerException('An unexpected error occurred.');
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await dio.post(
        ApiConfig.logoutEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      // Don't throw errors on logout failure
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiConfig.refreshTokenEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw ServerException(
            'Token refresh failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMessage = _parseErrorDetail(e.response?.data['detail']);
      if (e.response?.statusCode == 401) {
        throw AuthenticationException(errorMessage);
      }
      throw ServerException(errorMessage);
    } catch (e) {
      throw const ServerException('An unexpected error occurred.');
    }
  }
}
