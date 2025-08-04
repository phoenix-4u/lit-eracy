// # File: frontend/lib/core/utils/constants.dart

class AppConstants {
  // App Information
  static const String appName = 'Lit-eracy';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';

  // Gamification Points
  static const int lessonCompletionPoints = 10;
  static const int quizCompletionPoints = 25;
  static const int aiInteractionPoints = 15;
  static const int dailyStreakPoints = 5;

  // Time Constants
  static const int apiTimeoutSeconds = 30;
  static const int splashDuration = 3;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxUsernameLength = 30;

  // Achievement IDs
  static const String firstLessonAchievement = 'first_lesson';
  static const String weekStreakAchievement = 'week_streak';
  static const String quizMasterAchievement = 'quiz_master';
  static const String aiFriendAchievement = 'ai_friend';

  // Colors (as hex strings)
  static const String primaryBlueHex = '#4A90E2';
  static const String primaryGreenHex = '#7ED321';
  static const String primaryOrangeHex = '#F5A623';
  static const String primaryPurpleHex = '#9013FE';
  static const String primaryYellowHex = '#F8E71C';
}
