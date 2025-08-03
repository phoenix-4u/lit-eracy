// # File: frontend/lib/presentation/widgets/lesson_card.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';

class LessonCard extends StatefulWidget {
  final String title;
  final String subject;
  final String duration;
  final int points;
  final int difficulty;
  final VoidCallback? onTap;
  final bool isCompleted;
  final double? progress;

  const LessonCard({
    Key? key,
    required this.title,
    required this.subject,
    required this.duration,
    required this.points,
    required this.difficulty,
    this.onTap,
    this.isCompleted = false,
    this.progress,
  }) : super(key: key);

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isCompleted
                      ? [
                          AppTheme.successGreen,
                          AppTheme.successGreen.withOpacity(0.8),
                        ]
                      : [
                          _getSubjectColor(widget.subject),
                          _getSubjectColor(widget.subject).withOpacity(0.8),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getSubjectColor(widget.subject).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Subject Icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getSubjectIcon(widget.subject),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const Spacer(),
                            if (widget.isCompleted)
                              const Icon(
                                FontAwesomeIcons.checkCircle,
                                color: Colors.white,
                                size: 20,
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Title
                        Text(
                          widget.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // Subject
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.subject,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),

                        const Spacer(),

                        // Progress Bar (if in progress)
                        if (widget.progress != null && !widget.isCompleted) ...[
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: widget.progress! / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Bottom Info
                        Row(
                          children: [
                            // Duration
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.clock,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.duration,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Difficulty Stars
                            Row(
                              children: List.generate(3, (index) {
                                return Icon(
                                  index < widget.difficulty
                                      ? FontAwesomeIcons.solidStar
                                      : FontAwesomeIcons.star,
                                  color: Colors.white.withOpacity(
                                    index < widget.difficulty ? 1.0 : 0.3,
                                  ),
                                  size: 10,
                                );
                              }),
                            ),

                            const SizedBox(width: 8),

                            // Points
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.gem,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.points}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return AppTheme.primaryBlue;
      case 'english':
      case 'language':
        return AppTheme.primaryGreen;
      case 'science':
        return AppTheme.primaryPurple;
      case 'art':
        return AppTheme.primaryOrange;
      default:
        return AppTheme.primaryBlue;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return FontAwesomeIcons.calculator;
      case 'english':
      case 'language':
        return FontAwesomeIcons.book;
      case 'science':
        return FontAwesomeIcons.flask;
      case 'art':
        return FontAwesomeIcons.palette;
      default:
        return FontAwesomeIcons.graduationCap;
    }
  }
}
