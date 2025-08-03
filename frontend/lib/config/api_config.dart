// # File: frontend/lib/config/api_config.dart

class ApiConfig {
  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl$apiVersion/auth/login';
  static const String registerEndpoint = '$baseUrl$apiVersion/auth/register';
  static const String refreshTokenEndpoint = '$baseUrl$apiVersion/auth/refresh';
  static const String logoutEndpoint = '$baseUrl$apiVersion/auth/logout';

  // User endpoints
  static const String usersEndpoint = '$baseUrl$apiVersion/users';
  static const String userProfileEndpoint = '$baseUrl$apiVersion/user/profile';
  static const String updateProfileEndpoint =
      '$baseUrl$apiVersion/user/profile';

  // Content endpoints
  static const String lessonsEndpoint = '$baseUrl$apiVersion/content/lessons';
  static const String quizzesEndpoint = '$baseUrl$apiVersion/content/quizzes';
  static const String achievementsEndpoint =
      '$baseUrl$apiVersion/content/achievements';

  // Progress endpoints
  static const String progressEndpoint = '$baseUrl$apiVersion/progress';
  static const String updateProgressEndpoint =
      '$baseUrl$apiVersion/progress/update';

  // AI endpoints
  static const String aiChatEndpoint = '$baseUrl$apiVersion/ai/chat';
  static const String generateContentEndpoint =
      '$baseUrl$apiVersion/ai/generate';

  // File upload endpoints
  static const String uploadEndpoint = '$baseUrl$apiVersion/upload';

  // Request timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // API Keys (should be stored securely in production)
  static const String apiKey = 'your-api-key-here';

  // Headers
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Key': apiKey,
      };

  static Map<String, String> authHeaders(String token) => {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };
}
