import 'package:dio/dio.dart';
import 'package:lit_eracy/core/services/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage = TokenStorageImpl();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip adding token to auth endpoints
    if (_shouldSkipAuth(options.path)) {
      handler.next(options);
      return;
    }

    try {
      final token = await _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Silently fail if token is not found
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle unauthorized errors
    if (err.response?.statusCode == 401) {
      // Token is invalid or expired
      await _tokenStorage.clearToken();

      // You can emit an event here to navigate to login
      // or trigger a logout event in your BLoC
    }

    handler.next(err);
  }

  bool _shouldSkipAuth(String path) {
    final authPaths = [
      '/api/auth/login',
      '/api/auth/register',
    ];

    return authPaths.any((authPath) => path.contains(authPath));
  }
}
