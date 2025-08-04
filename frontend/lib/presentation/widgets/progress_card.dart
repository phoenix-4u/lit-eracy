// # File: frontend/lib/presentation/widgets/progress_card.dart (Fixed)

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ProgressCard extends StatelessWidget {
  final String subject;
  final double progress;

  const ProgressCard({
    super.key,
    required this.subject,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getSubjectColor(subject);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
          ),
        ],
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'reading':
        return AppTheme.primaryBlue;
      case 'math':
        return AppTheme.primaryGreen;
      case 'science':
        return AppTheme.primaryOrange;
      case 'ai basics':
        return AppTheme.primaryPurple;
      default:
        return AppTheme.primaryBlue;
    }
  }
}
