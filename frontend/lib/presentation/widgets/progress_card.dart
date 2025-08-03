// # File: frontend/lib/presentation/widgets/progress_card.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';

class ProgressCard extends StatelessWidget {
  final dynamic progress;
  final VoidCallback? onTap;

  const ProgressCard({
    super.key,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Content Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getSubjectColor(progress?.subject ?? 'Math')
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getSubjectIcon(progress?.subject ?? 'Math'),
                color: _getSubjectColor(progress?.subject ?? 'Math'),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Content Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress?.title ?? 'Learning Content',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${progress?.subject ?? 'Subject'} • ${progress?.estimatedDuration ?? 5} min',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppTheme.secondaryText,
                                ),
                          ),
                          Text(
                            '${progress?.completionPercentage?.round() ?? 0}%',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (progress?.completionPercentage ?? 0) / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getSubjectColor(progress?.subject ?? 'Math'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Continue Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Continue',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
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
