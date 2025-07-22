// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lit_eracy/domain/usecases/login_usecase.dart';
import 'package:lit_eracy/data/repositories/auth_repository.dart';
import 'package:lit_eracy/presentation/blocs/auth_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate repository and use case
    final authRepository = AuthRepository();
    final loginUseCase = LoginUseCase(authRepository);

    return BlocProvider(
      create: (context) => AuthBloc(
          loginUseCase: loginUseCase), // Provide the required parameter
      child: MaterialApp(
        title: 'Lit-eracy',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Lit-eracy'),
          ),
          body: Center(
            child: Text('Welcome to Lit-eracy!'),
          ),
        ),
      ),
    );
  }
}
