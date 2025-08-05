// File: lib/presentation/pages/task_page.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/api_service.dart';

class TaskPage extends StatefulWidget {
  static const String routeName = '/task';
  final int taskId;
  const TaskPage({super.key, required this.taskId});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Map<String, dynamic>? task;
  bool loading = true;
  String? errorMessage;
  final ApiService _apiService = GetIt.instance<ApiService>();

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future<void> loadTask() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await _apiService.get('/api/tasks/${widget.taskId}');
      if (!mounted) return;

      print('Task API Response: $response'); // Debug log

      // Handle different response formats from your API service
      Map<String, dynamic>? taskData;

      if (response is Map<String, dynamic>) {
        // If the response is wrapped in 'data'
        if (response.containsKey('data') &&
            response['data'] is Map<String, dynamic>) {
          taskData = response['data'] as Map<String, dynamic>;
        } else {
          // If the response is the task directly
          taskData = response;
        }
      }

      setState(() {
        task = taskData;
        loading = false;
        if (taskData == null) {
          errorMessage = "No task data received";
        }
      });
    } catch (e) {
      if (!mounted) return;
      print('Error loading task: $e'); // Debug log

      setState(() {
        loading = false;
        errorMessage = 'Error loading task: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task?['title'] ?? 'Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadTask,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadTask,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : task == null
                  ? const Center(child: Text('Task not found.'))
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task!['title'] ?? 'Untitled Task',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          Text(task!['description'] ??
                              'No description available.'),
                          const SizedBox(height: 24),
                          if (task!['is_completed'] == 1 ||
                              task!['is_completed'] == true)
                            const Text(
                              'Status: Completed ✅',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          else
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await _apiService.post(
                                      '/api/tasks/${widget.taskId}/complete',
                                      {});
                                  if (!mounted) return;
                                  await loadTask();
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Task completed! 🎉')));
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')));
                                }
                              },
                              child: const Text('Mark as Complete'),
                            ),
                        ],
                      ),
                    ),
    );
  }
}
