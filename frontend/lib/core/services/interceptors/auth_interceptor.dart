// # File: frontend/lib/core/services/interceptors/auth_interceptor.dart

import 'package:dio/dio.dart';
import '../storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = StorageService.getString('token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired or invalid
      StorageService.remove('token');
      StorageService.remove('user');
    }
    handler.next(err);
  }
}
