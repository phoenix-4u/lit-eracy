import 'package:get_it/get_it.dart';
import 'package:lit_eracy/data/repository/auth_repository_impl.dart';
import 'package:lit_eracy/data/repository/content_repository_impl.dart';
import 'package:lit_eracy/domain/repository/auth_repository.dart';
import 'package:lit_eracy/domain/repository/content_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/fetch_lessons_usecase.dart';
import '../domain/usecases/fetch_achievements_usecase.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<ContentRepository>(() => ContentRepositoryImpl());
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => FetchLessonsUseCase(getIt()));
  getIt.registerLazySingleton(() => FetchAchievementsUseCase(getIt()));
}
