import 'package:get_it/get_it.dart';
import 'package:lit_eracy/data/repository/auth_repository_impl.dart';
import 'package:lit_eracy/data/repository/content_repository_impl.dart';
import 'package:lit_eracy/domain/repository/auth_repository.dart';
import 'package:lit_eracy/domain/repository/content_repository.dart';
import 'package:lit_eracy/domain/usecases/login_usecase.dart';
import 'package:lit_eracy/domain/usecases/fetch_lessons_usecase.dart';
import 'package:lit_eracy/domain/usecases/fetch_achievements_usecase.dart';
import 'package:lit_eracy/presentation/blocs/auth/auth_bloc.dart';
import 'package:lit_eracy/presentation/blocs/content/content_bloc.dart';
import 'package:lit_eracy/presentation/blocs/achievement/achievement_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<ContentRepository>(() => ContentRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => FetchLessonsUseCase(sl()));
  sl.registerLazySingleton(() => FetchAchievementsUseCase(sl()));

  // Blocs
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => ContentBloc(sl()));
  sl.registerFactory(() => AchievementBloc(sl()));
}
