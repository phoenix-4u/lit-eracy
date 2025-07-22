// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lit_eracy/core/di.dart';
import 'package:lit_eracy/data/repositories/auth_repository_impl.dart';
import 'package:lit_eracy/domain/repositories/auth_repository.dart';
import 'package:lit_eracy/domain/usecases/login_usecase.dart';
import 'package:lit_eracy/presentation/blocs/auth_bloc.dart';
import 'package:lit_eracy/presentation/pages/login_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate repository and use case
    final authRepository = AuthRepositoryImpl();
    final loginUseCase = LoginUseCase(authRepository);

    return BlocProvider(
      create: (context) => AuthBloc(loginUseCase: loginUseCase), // Provide the required parameter
      child: const MaterialApp(
        title: 'Lit-eracy',
        home: LoginPage(),
      ),
    );
  }
}
