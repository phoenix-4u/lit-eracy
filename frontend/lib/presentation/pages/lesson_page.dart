// File: frontend/lib/presentation/pages/lesson_page.dart

import 'package:flutter/material.dart';
import '../../domain/entities/lesson.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  List<dynamic> tasks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() {
      loading = true;
    });

    final url = Uri.parse(
      'http://localhost:8000/api/content/lessons/${widget.lesson.id}/tasks',
    );
    // If your backend uses /tasks/{lesson_id}, adjust the path accordingly.
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Add auth headers here if your API requires them, e.g.:
        // 'Authorization': 'Bearer <token>',
      },
    );
    if (!mounted) return;
    if (response.statusCode == 200) {
      setState(() {
        tasks = json.decode(response.body) as List<dynamic>;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to load tasks (${response.statusCode})')),
      );
    }
  }

  Future<void> completeTask(int taskId) async {
    final url =
        Uri.parse('http://localhost:8000/api/content/tasks/$taskId/complete');
    // Adjust path if needed
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer <token>',
      },
    );
    if (!mounted) return;
    if (response.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task completed!')),
      );
      fetchTasks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to complete task (${response.statusCode})')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.lesson.content.isNotEmpty) Text(widget.lesson.content),
            const SizedBox(height: 24),
            Text('Tasks:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            loading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                    ? const Text('No tasks for this lesson.')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index] as Map<String, dynamic>;
                            final completed = task['is_completed'] == 1 ||
                                task['is_completed'] == true;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(task['title'] ?? ''),
                                subtitle: Text(task['description'] ?? ''),
                                trailing: completed
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : ElevatedButton(
                                        onPressed: () =>
                                            completeTask(task['id'] as int),
                                        child: const Text('Complete'),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
