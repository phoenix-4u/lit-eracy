// # File: frontend/lib/presentation/widgets/achievement_badge.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/achievement.dart';
import '../../core/theme/app_theme.dart';

class AchievementBadge extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onTap;
  final bool showDetails;

  const AchievementBadge({
    Key? key,
    required this.achievement,
    this.onTap,
    this.showDetails = true,
  }) : super(key: key);

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.achievement.isUnlocked) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: widget.achievement.isUnlocked
              ? _getUnlockedGradient()
              : _getLockedGradient(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.achievement.isUnlocked
                ? _getRarityColor().withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: widget.achievement.isUnlocked
              ? [
                  BoxShadow(
                    color: _getRarityColor().withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBadgeIcon(),
            if (widget.showDetails) ...[
              const SizedBox(height: 12),
              _buildBadgeDetails(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 0.1,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.achievement.isUnlocked
                    ? RadialGradient(
                        colors: [
                          _getRarityColor(),
                          _getRarityColor().withValues(alpha: 0.7),
                        ],
                      )
                    : RadialGradient(
                        colors: [
                          Colors.grey.withValues(alpha: 0.3),
                          Colors.grey.withValues(alpha: 0.1),
                        ],
                      ),
                border: Border.all(
                  color: widget.achievement.isUnlocked
                      ? _getRarityColor()
                      : Colors.grey,
                  width: 3,
                ),
                boxShadow: widget.achievement.isUnlocked
                    ? [
                        BoxShadow(
                          color: _getRarityColor().withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: FaIcon(
                  _getIconData(),
                  size: 40,
                  color: widget.achievement.isUnlocked
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadgeDetails() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          widget.achievement.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.achievement.isUnlocked
                ? AppTheme.textColor
                : Colors.grey,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          widget.achievement.description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: widget.achievement.isUnlocked
                ? AppTheme.textColor.withValues(alpha: 0.8)
                : Colors.grey.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getRarityColor().withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getRarityColor().withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            '${widget.achievement.pointsRequired} pts',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getRarityColor(),
            ),
          ),
        ),
        if (widget.achievement.isUnlocked &&
            widget.achievement.unlockedAt != null) ...[
          const SizedBox(height: 4),
          Text(
            'Unlocked ${_formatDate(widget.achievement.unlockedAt!)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }

  LinearGradient _getUnlockedGradient() {
    final color = _getRarityColor();
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withValues(alpha: 0.1),
        color.withValues(alpha: 0.05),
      ],
    );
  }

  LinearGradient _getLockedGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.grey.withValues(alpha: 0.1),
        Colors.grey.withValues(alpha: 0.05),
      ],
    );
  }

  Color _getRarityColor() {
    switch (widget.achievement.rarity.toLowerCase()) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'platinum':
        return const Color(0xFFE5E4E2);
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getIconData() {
    switch (widget.achievement.iconName.toLowerCase()) {
      case 'trophy':
        return FontAwesomeIcons.trophy;
      case 'medal':
        return FontAwesomeIcons.medal;
      case 'star':
        return FontAwesomeIcons.star;
      case 'crown':
        return FontAwesomeIcons.crown;
      case 'fire':
        return FontAwesomeIcons.fire;
      case 'book':
        return FontAwesomeIcons.book;
      case 'graduation':
        return FontAwesomeIcons.graduationCap;
      case 'target':
        return FontAwesomeIcons.bullseye;
      case 'lightning':
        return FontAwesomeIcons.bolt;
      default:
        return FontAwesomeIcons.award;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}
