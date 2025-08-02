# File: frontend/lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// BLoCs
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/user/user_bloc.dart';
import '../../presentation/blocs/content/content_bloc.dart';
import '../../presentation/blocs/progress/progress_bloc.dart';
import '../../presentation/blocs/achievements/achievements_bloc.dart';

// Use Cases
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/content/get_lessons_usecase.dart';
import '../../domain/usecases/progress/update_progress_usecase.dart';
import '../../domain/usecases/achievements/get_achievements_usecase.dart';

// Repositories
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/achievements_repository.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/achievements_repository_impl.dart';

// Data Sources
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/datasources/remote/content_remote_datasource.dart';
import '../../data/datasources/local/local_storage_datasource.dart';

// Services
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/gamification_service.dart';

import '../constants/app_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => secureStorage);
  
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.apiUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  sl.registerLazySingleton(() => dio);
  
  // Services
  sl.registerLazySingleton<ApiService>(() => ApiService(sl()));
  sl.registerLazySingleton<StorageService>(() => StorageService(sl(), sl()));
  sl.registerLazySingleton<GamificationService>(() => GamificationService());
  
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LocalStorageDataSource>(
    () => LocalStorageDataSourceImpl(sl()),
  );
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AchievementsRepository>(
    () => AchievementsRepositoryImpl(sl(), sl()),
  );
  
  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetLessonsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProgressUseCase(sl()));
  sl.registerLazySingleton(() => GetAchievementsUseCase(sl()));
  
  // BLoCs
  sl.registerFactory(() => AuthBloc(sl(), sl()));
  sl.registerFactory(() => UserBloc(sl()));
  sl.registerFactory(() => ContentBloc(sl()));
  sl.registerFactory(() => ProgressBloc(sl()));
  sl.registerFactory(() => AchievementsBloc(sl()));
}