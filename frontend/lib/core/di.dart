import 'package:get_it/get_it.dart';
import 'package:lit_eracy/data/repository/auth_repository_impl.dart';
import 'package:lit_eracy/data/repository/content_repository_impl.dart';
import 'package:lit_eracy/domain/repository/auth_repository.dart';
import 'package:lit_eracy/domain/repository/content_repository.dart';
import 'package:lit_eracy/domain/usecases/login_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<ContentRepository>(() => ContentRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
}
