import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_literacy_app/presentation/blocs/auth/auth_bloc.dart'; // Corrected import path
import 'package:ai_literacy_app/presentation/pages/login_page.dart'; // Navigate to login after success

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Add controllers for all registration fields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // FIX: Was AuthSuccess
            // On success, show a message and navigate to the login page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Registration successful! Please log in.')),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          } else if (state is AuthError) {
            // FIX: Was AuthFailure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)), // FIX: Was state.error
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Added for scrolling on small screens
              child: Column(
                children: [
                  // Added fields for a proper registration form
                  TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // FIX: Create the userData map as required by the event
                      final Map<String, dynamic> userData = {
                        'fullName': _fullNameController.text,
                        'username': _usernameController.text,
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        // Add other fields like age or grade here if needed
                      };

                      // FIX: Use the correct event 'RegisterRequested'
                      context
                          .read<AuthBloc>()
                          .add(RegisterRequested(userData: userData));
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
