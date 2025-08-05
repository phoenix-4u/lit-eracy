// File: frontend/lib/presentation/pages/ai_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/ai/ai_bloc.dart';
import '../../domain/entities/task.dart';

class AIPage extends StatelessWidget {
  final int lessonId;
  const AIPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Task Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AIBloc, AIState>(
          listener: (context, state) {
            if (state is AIError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AILoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AILoaded) {
              return TaskView(task: state.task);
            } else {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AIBloc>().add(GenerateTaskRequested(lessonId));
                  },
                  child: const Text('Generate Task'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class TaskView extends StatelessWidget {
  final Task task;
  const TaskView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title: ${task.title}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text(task.description),
      ],
    );
  }
}
