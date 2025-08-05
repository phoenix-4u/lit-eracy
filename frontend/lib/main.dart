// File: frontend/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

import 'core/di.dart' as di;
import 'core/theme/app_theme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/user/user_bloc.dart';
import 'presentation/blocs/content/content_bloc.dart';
import 'presentation/blocs/progress/progress_bloc.dart';
import 'presentation/blocs/achievements/achievements_bloc.dart';
import 'presentation/pages/splash/splash_page.dart';

// FIX: Import the pages you want to navigate to
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/registration_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/ai_page.dart';

// FIX: Import TaskPage and LessonPage for dynamic routing
import 'presentation/pages/lesson_page.dart';
import 'presentation/pages/task_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => di.sl<UserBloc>(),
        ),
        BlocProvider<ContentBloc>(
          create: (context) => di.sl<ContentBloc>(),
        ),
        BlocProvider<ProgressBloc>(
          create: (context) => di.sl<ProgressBloc>(),
        ),
        BlocProvider<AchievementsBloc>(
          create: (context) => di.sl<AchievementsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Lit-eracy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme.primaryBlue,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          useMaterial3: true,
        ),
        // The 'home' property defines the very first screen.
        home: const SplashPage(),

        // FIX: Add the 'routes' property to define all named static navigation paths.
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegistrationPage(),
          '/home': (context) => const HomePage(),
          '/ai': (context) => const AIPage(lessonId: 0),
          // Add other static pages here as needed
        },

        // FIX: Handle dynamic & argument-based routes (Lesson & Task pages)
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case LessonPage.routeName:
              final args = settings.arguments as Map<String, dynamic>?;
              if (args == null || !args.containsKey('lesson')) {
                return MaterialPageRoute(
                  builder: (_) => const HomePage(),
                );
              }
              return MaterialPageRoute(
                builder: (_) => LessonPage(lesson: args['lesson']),
              );

            case TaskPage.routeName:
              final args = settings.arguments as Map<String, dynamic>?;
              if (args == null || !args.containsKey('taskId')) {
                return MaterialPageRoute(
                  builder: (_) => const HomePage(),
                );
              }
              return MaterialPageRoute(
                builder: (_) => TaskPage(taskId: args['taskId'] as int),
              );

            default:
              return null; // Use existing routes map or fallback
          }
        },
      ),
    );
  }
}
