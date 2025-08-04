// # File: frontend/lib/core/di/injection_container.dart (Final Fixed Version)

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

// Core Services
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/gamification_service.dart';
import '../services/token_storage.dart';

// Config
import '../../config/api_config.dart';

// Data Layer
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/datasources/remote/content_remote_datasource.dart';
import '../../data/datasources/local/local_storage_datasource.dart';

// Repository Implementations
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/achievements_repository_impl.dart';

// Domain Repositories
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/achievements_repository.dart';

// Use Cases
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/content/get_lessons_usecase.dart';
import '../../domain/usecases/progress/update_progress_usecase.dart';
import '../../domain/usecases/achievements/get_achievements_usecase.dart';

// BLoCs
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/user/user_bloc.dart';
import '../../presentation/blocs/content/content_bloc.dart';
import '../../presentation/blocs/progress/progress_bloc.dart';
import '../../presentation/blocs/achievements/achievements_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  // sl.registerLazySingleton(() => Dio());

  // Registering API Config
  sl.registerLazySingleton(() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl, // e.g., 'http://localhost:8000'
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  });

  // Core Services
  sl.registerLazySingleton<TokenStorage>(() => TokenStorageImpl(sl()));
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl(sl()));
  sl.registerLazySingleton<ApiService>(() => ApiServiceImpl(
        client: sl(),
        tokenStorage: sl(),
        connectivity: sl(),
      ));
  sl.registerLazySingleton<GamificationService>(() => GamificationServiceImpl(
        storageService: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ContentRemoteDataSource>(
      () => ContentRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalStorageDataSource>(
      () => LocalStorageDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        dio: sl(),
      ));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));
  sl.registerLazySingleton<ContentRepository>(() => ContentRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));
  sl.registerLazySingleton<ProgressRepository>(() => ProgressRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));
  sl.registerLazySingleton<AchievementsRepository>(
      () => AchievementsRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
          ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetLessonsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProgressUseCase(sl()));
  sl.registerLazySingleton(() => GetAchievementsUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
      ));
  sl.registerFactory(() => UserBloc(getUserProfileUseCase: sl()));
  sl.registerFactory(() => ContentBloc(getLessonsUseCase: sl()));
  sl.registerFactory(() => ProgressBloc(sl()));
  sl.registerFactory(() => AchievementsBloc(getAchievementsUseCase: sl()));
}
