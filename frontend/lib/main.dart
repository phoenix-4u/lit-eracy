// File: frontend/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/app_router.dart';

// BLoCs
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/user/user_bloc.dart';
import 'presentation/blocs/content/content_bloc.dart';
import 'presentation/blocs/progress/progress_bloc.dart';
import 'presentation/blocs/achievements/achievements_bloc.dart';

// Pages
import 'presentation/pages/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize dependency injection
  await di.init();

  // Set preferred orientations (mainly portrait for children)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const AILiteracyApp());
}

class AILiteracyApp extends StatelessWidget {
  const AILiteracyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(AuthInitialEvent()),
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
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // Default to light theme for children
        onGenerateRoute: AppRouter.generateRoute,
        home: const SplashPage(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0, // Prevent text scaling for consistency
            ),
            child: child!,
          );
        },
      ),
    );
  }
}

// Custom BlocObserver for debugging and monitoring
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
