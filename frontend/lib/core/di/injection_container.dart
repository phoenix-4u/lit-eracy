// # File: frontend/lib/core/di/injection_container.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// Repository Implementations
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

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio());

  // Services
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<GamificationService>(() => GamificationService());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiService>().dio),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<ApiService>().dio),
  );

  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(sl<ApiService>().dio),
  );

  sl.registerLazySingleton<LocalStorageDataSource>(
    () => LocalStorageDataSourceImpl(sl<SharedPreferences>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        sl<AuthRemoteDataSource>(), sl<LocalStorageDataSource>()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
        sl<UserRemoteDataSource>(), sl<LocalStorageDataSource>()),
  );

  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
        sl<ContentRemoteDataSource>(), sl<LocalStorageDataSource>()),
  );

  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(
        sl<ContentRemoteDataSource>(), sl<LocalStorageDataSource>()),
  );

  sl.registerLazySingleton<AchievementsRepository>(
    () => AchievementsRepositoryImpl(
        sl<ContentRemoteDataSource>(), sl<LocalStorageDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => GetLessonsUseCase(sl<ContentRepository>()));
  sl.registerLazySingleton(
      () => UpdateProgressUseCase(sl<ProgressRepository>()));
  sl.registerLazySingleton(
      () => GetAchievementsUseCase(sl<AchievementsRepository>()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(sl<LoginUseCase>(), sl<RegisterUseCase>()));
  sl.registerFactory(() => UserBloc(sl<GetUserProfileUseCase>()));
  sl.registerFactory(() => ContentBloc(sl<GetLessonsUseCase>()));
  sl.registerFactory(() => ProgressBloc(sl<UpdateProgressUseCase>()));
  sl.registerFactory(() => AchievementsBloc(sl<GetAchievementsUseCase>()));
}
