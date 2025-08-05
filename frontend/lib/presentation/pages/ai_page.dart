
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lit_eracy/presentation/blocs/ai/ai_bloc.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Task Generator'),
      ),
      body: BlocProvider(
        create: (context) => AiBloc(generateTaskForLesson: context.read()),
        child: BlocBuilder<AiBloc, AiState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is AiInitial)
                    const Text('Click the button to generate a new task.'),
                  if (state is AiLoading)
                    const CircularProgressIndicator(),
                  if (state is AiLoaded)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            state.task.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(state.task.description),
                        ],
                      ),
                    ),
                  if (state is AiError)
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AiBloc>().add(const GenerateTask(lessonId: 1));
                    },
                    child: const Text('Generate Task'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
