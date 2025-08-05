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
  final ApiService _apiService = GetIt.instance<ApiService>();

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future<void> loadTask() async {
    setState(() => loading = true);
    try {
      final response = await _apiService.get('/api/tasks/${widget.taskId}');
      if (!mounted) return;
      setState(() {
        task = response['data'] as Map<String, dynamic>?;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
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
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : task == null
              ? const Center(child: Text('Task not found.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task!['title'] ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(task!['description'] ?? ''),
                      const SizedBox(height: 24),
                      if (task!['is_completed'] == 1 ||
                          task!['is_completed'] == true)
                        const Text(
                          'Status: Completed',
                          style: TextStyle(color: Colors.green),
                        )
                      else
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await _apiService.post(
                                  '/api/tasks/${widget.taskId}/complete', {});
                              if (!mounted) return;
                              loadTask();
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Task marked complete')));
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Error completing task: $e')));
                            }
                          },
                          child: const Text('Complete Task'),
                        ),
                    ],
                  ),
                ),
    );
  }
}
