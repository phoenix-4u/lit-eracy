// File: /lib/core/utils/app_router.dart

import 'package:flutter/material.dart';
import '../../domain/entities/lesson.dart'; // <-- Import Lesson
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/lesson_page.dart';
import '../../presentation/pages/task_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case LessonPage.routeName:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('lesson')) {
          return _errorRoute('Missing lesson argument');
        }
        final lesson = args['lesson'] as Lesson; // <-- Now Lesson is recognized
        return MaterialPageRoute(
          builder: (_) => LessonPage(lesson: lesson),
        );

      case TaskPage.routeName:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || !args.containsKey('taskId')) {
          return _errorRoute('Missing taskId argument');
        }
        final taskId = args['taskId'] as int;
        return MaterialPageRoute(
          builder: (_) => TaskPage(taskId: taskId),
        );

      default:
        return _errorRoute('Route not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
