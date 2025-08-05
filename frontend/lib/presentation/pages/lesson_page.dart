// File: frontend/lib/presentation/pages/lesson_page.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/api_service.dart';
import '../../domain/entities/lesson.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  List<dynamic> tasks = [];
  bool loading = true;
  final ApiService _apiService = GetIt.instance<ApiService>();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() => loading = true);
    try {
      final response = await _apiService.get('/api/tasks/${widget.lesson.id}');
      if (!mounted) return;

      setState(() {
        tasks = response['data'] as List<dynamic>;
        loading = false;
      });
    } on ServerException catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } on NetworkException catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error: ${e.message}')),
      );
    } on AuthenticationException catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Error: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  Future<void> completeTask(int taskId) async {
    try {
      await _apiService.post('/api/tasks/$taskId/complete', {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task completed!')),
      );
      fetchTasks();
    } on ServerException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } on NetworkException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error: ${e.message}')),
      );
    } on AuthenticationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Error: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
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
