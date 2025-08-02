// # File: frontend/lib/core/utils/app_router.dart

import 'package:flutter/material.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/registration_page.dart';
import '../../presentation/pages/student/student_dashboard_page.dart';
import '../../presentation/pages/student/lesson_page.dart';
import '../../presentation/pages/student/quiz_page.dart';
import '../../presentation/pages/student/achievements_page.dart';
import '../../presentation/pages/student/ai_chat_page.dart';
import '../../presentation/pages/parent/parent_dashboard_page.dart';
import '../../presentation/pages/teacher/teacher_dashboard_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String studentDashboard = '/student-dashboard';
  static const String parentDashboard = '/parent-dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String lesson = '/lesson';
  static const String quiz = '/quiz';
  static const String achievements = '/achievements';
  static const String aiChat = '/ai-chat';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegistrationPage(),
        );

      case studentDashboard:
        return MaterialPageRoute(
          builder: (_) => const StudentDashboardPage(),
        );

      case parentDashboard:
        return MaterialPageRoute(
          builder: (_) => const ParentDashboardPage(),
        );

      case teacherDashboard:
        return MaterialPageRoute(
          builder: (_) => const TeacherDashboardPage(),
        );

      case lesson:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LessonPage(
            lessonId: args?['lessonId'] ?? 1,
          ),
        );

      case quiz:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => QuizPage(
            quizId: args?['quizId'] ?? 1,
          ),
        );

      case achievements:
        return MaterialPageRoute(
          builder: (_) => const AchievementsPage(),
        );

      case aiChat:
        return MaterialPageRoute(
          builder: (_) => const AIChatPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(
              child: Text('Page not found!'),
            ),
          ),
        );
    }
  }
}
