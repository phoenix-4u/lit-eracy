import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lit_eracy/core/di.dart';
import 'package:lit_eracy/presentation/blocs/content/content_bloc.dart';
import 'package:lit_eracy/presentation/widgets/lesson_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContentBloc>()..add(LoadLessons(1)),
      child: _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatefulWidget {
  @override
  State<_HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<_HomePageBody> {
  int currency = 0;
  String unlockedContent = '';

  Future<void> _completeTask() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/content/complete_task'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        currency = data['currency'] ?? 0;
        unlockedContent = data['unlocked_content'] ?? '';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task completed! Unlocked: $unlockedContent')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Knowledge Gems: $currency',
                    style: const TextStyle(fontSize: 20)),
                ElevatedButton(
                  onPressed: _completeTask,
                  child: const Text('Complete Task'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ContentBloc, ContentState>(
              builder: (context, state) {
                if (state is ContentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ContentLoaded) {
                  return ListView.builder(
                    itemCount: state.lessons.length,
                    itemBuilder: (context, index) =>
                        LessonCard(lesson: state.lessons[index]),
                  );
                } else if (state is ContentError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
