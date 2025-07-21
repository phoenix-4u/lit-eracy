import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/fetch_lessons_usecase.dart';
import '../domain/usecases/fetch_achievements_usecase.dart';

Future<void> configureDependencies() async {
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerLazySingleton(() => ContentRepository());
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => FetchLessonsUseCase(getIt()));
  getIt.registerLazySingleton(() => FetchAchievementsUseCase(getIt()));
}
