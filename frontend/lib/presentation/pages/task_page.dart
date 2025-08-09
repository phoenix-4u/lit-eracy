// File: frontend/lib/presentation/pages/task_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/api_service.dart';

class TaskPage extends StatefulWidget {
  static const String routeName = '/task';
  final int taskId;
  const TaskPage({super.key, required this.taskId});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  final ApiService _api = GetIt.instance<ApiService>();
  bool _loading = true;
  Map<String, dynamic>? _task;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadTask();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.purple.shade300,
      end: Colors.blue.shade400,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadTask() async {
    setState(() => _loading = true);
    try {
      final resp = await _api.get('/api/tasks/${widget.taskId}');
      Map<String, dynamic>? data;
      if (resp['data'] is Map<String, dynamic>) {
        data = resp['data'] as Map<String, dynamic>;
      } else {
        data = resp.cast<String, dynamic>();
      }
      setState(() {
        _task = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading task: $e')),
      );
    }
  }

  Future<void> _completeTask() async {
    try {
      await _api.post('/api/tasks/${widget.taskId}/complete', {});
      if (!mounted) return;
      await _loadTask();
      _showCompletionAnimation();
      // FR-001: notify backend of progress update
      await _api.post('/api/progress/update', {
        'content_id': widget.taskId,
        'completion_percentage':
            1.0, // backend will compute, or send 1.0 for one task
        'time_spent': 0 // optionally track time
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing task: $e')),
      );
    }
  }

  void _showCompletionAnimation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow.shade300, Colors.orange.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withAlpha(77),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              const Text(
                '🎉 Great Job! 🎉',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Task completed successfully!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Continue Learning!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKidsMarkdown(String content) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
            Colors.pink.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purple.shade200, width: 2),
      ),
      child: Markdown(
        data: content,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        styleSheet: MarkdownStyleSheet(
          // Headings
          h1: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
            height: 1.4,
          ),
          h2: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            height: 1.3,
          ),
          h3: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
            height: 1.3,
          ),
          // Body text
          p: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            height: 1.5,
            letterSpacing: 0.3,
          ),
          // Lists
          listBullet: const TextStyle(
            fontSize: 18,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
          // Strong/Bold text
          strong: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: 19,
          ),
          // Emphasis/Italic
          em: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.blue,
            fontSize: 18,
          ),
          // Code styling
          code: TextStyle(
            backgroundColor: Colors.yellow.shade100,
            color: Colors.purple.shade700,
            fontFamily: 'monospace',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          // Block quotes
          blockquoteDecoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border(
              left: BorderSide(
                color: Colors.blue.shade400,
                width: 4,
              ),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          blockquotePadding: const EdgeInsets.all(16),
          // Tables
          tableHead: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          tableHeadAlign: TextAlign.center,
          tableBorder: TableBorder.all(
            color: Colors.purple.shade300,
            width: 2,
          ),
          tableColumnWidth: const FlexColumnWidth(),
          // Horizontal rule
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color:
                    Colors.purple.shade300, // replaced Colors.rainbow.shade300
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _task?['title'] as String? ?? 'Task Details';
    final description = _task?['description'] as String? ?? '';
    final completed =
        _task?['is_completed'] == 1 || _task?['is_completed'] == true;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purple.shade400,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade400,
                Colors.blue.shade400,
                Colors.pink.shade300,
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fun header with emoji
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade300,
                          Colors.yellow.shade300
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withAlpha(77),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('📚', style: TextStyle(fontSize: 30)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Text('✨', style: TextStyle(fontSize: 30)),
                          ],
                        ),
                        if (completed) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Completed! 🎉',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Task content with markdown
                  if (description.isNotEmpty)
                    _buildKidsMarkdown(description)
                  else
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Text(
                          'No task description available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Completion button
                  Center(
                    child: AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: completed ? 1.0 : _bounceAnimation.value,
                          child: AnimatedBuilder(
                            animation: _colorAnimation,
                            builder: (context, child) {
                              return Container(
                                width: double.infinity,
                                height: 60,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ElevatedButton(
                                  onPressed: completed ? null : _completeTask,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: completed
                                        ? Colors.green.shade400
                                        : _colorAnimation.value,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: completed ? 2 : 8,
                                    shadowColor: completed
                                        ? Colors.green.withAlpha(77)
                                        : Colors.purple.withAlpha(77),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        completed
                                            ? Icons.check_circle
                                            : Icons.star,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        completed
                                            ? 'Task Completed! 🎉'
                                            : 'Complete Task ⭐',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Encouraging message
                  if (!completed)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: const Text(
                        '💪 You can do it! Take your time and do your best! 🌟',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
