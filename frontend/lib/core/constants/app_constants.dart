// # File: frontend/lib/core/constants/app_constants.dart

class AppConstants {
  // App Information
  static const String appName = 'Lit-eracy';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'AI-powered educational app for children';

  // API Configuration
  static const String baseUrl = 'http://192.168.2.233:8000';
  static const String apiUrl = '$baseUrl/api';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String offlineDataKey = 'offline_data';

  // Gamification
  static const int knowledgeGemsPerLesson = 10;
  static const int wordCoinsPerQuiz = 25;
  static const int imaginationSparksPerStory = 15;
  static const int streakBonusPoints = 5;

  // Achievement Thresholds
  static const int firstLessonBadgeThreshold = 1;
  static const int weekStreakChampionThreshold = 7;
  static const int quizMasterThreshold = 10;
  static const int storyReaderThreshold = 5;
  static const int aiFriendThreshold = 20;

  // Screen Time (in minutes)
  static const int defaultDailyLimit = 60;
  static const int defaultBreakReminder = 15;
  static const int maxSessionTime = 120;

  // Content
  static const int maxGradeLevel = 8;
  static const int minGradeLevel = 1;
  static const List<String> subjects = ['Math', 'English', 'Science', 'Art'];

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 600);
  static const Duration longAnimation = Duration(milliseconds: 1000);

  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 40.0;

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again';
  static const String authError = 'Authentication failed';
  static const String validationError = 'Please check your input';

  // Success Messages
  static const String loginSuccess = 'Welcome back!';
  static const String registrationSuccess = 'Account created successfully!';
  static const String lessonCompleted = 'Great job! Lesson completed!';
  static const String achievementUnlocked = 'New achievement unlocked!';
}
