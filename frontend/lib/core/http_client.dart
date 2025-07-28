import 'package:dio/dio.dart';
import 'package:lit_eracy/config/api_config.dart';
import 'package:lit_eracy/core/services/token_storage.dart';

class HttpClient {
  static Dio? _dio;
  static final TokenStorage _tokenStorage = TokenStorageImpl();

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add authentication interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth for login/register endpoints
        if (!_isAuthEndpoint(options.path)) {
          final token = await _tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle token expiration
        if (error.response?.statusCode == 401) {
          await _tokenStorage.clearToken();
          // You can add navigation to login page here
        }
        handler.next(error);
      },
    ));

    // Add logging interceptor for development
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
    ));

    return dio;
  }

  static bool _isAuthEndpoint(String path) {
    return path.contains('/api/auth/login') ||
        path.contains('/api/auth/register');
  }

  static void resetInstance() {
    _dio = null;
  }
}
