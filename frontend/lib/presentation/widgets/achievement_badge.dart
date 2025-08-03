// # File: frontend/lib/presentation/widgets/achievement_badge.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';

class AchievementBadge extends StatefulWidget {
  final dynamic achievement;
  final VoidCallback? onTap;
  final bool isLocked;

  const AchievementBadge({
    Key? key,
    required this.achievement,
    this.onTap,
    this.isLocked = false,
  }) : super(key: key);

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (!widget.isLocked) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isLocked ? 1.0 : _pulseAnimation.value,
            child: Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: widget.isLocked
                    ? LinearGradient(
                        colors: [
                          Colors.grey.shade300,
                          Colors.grey.shade400,
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.achievementGold,
                          AppTheme.achievementGold.withOpacity(0.8),
                        ],
                      ),
                boxShadow: widget.isLocked
                    ? []
                    : [
                        BoxShadow(
                          color: AppTheme.achievementGold
                              .withOpacity(0.4 * _glowAnimation.value),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Badge Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: widget.isLocked
                            ? Colors.grey.shade500
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: widget.isLocked
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Icon(
                        widget.isLocked
                            ? FontAwesomeIcons.lock
                            : _getAchievementIcon(
                                widget.achievement?.name ?? ''),
                        color: widget.isLocked
                            ? Colors.white
                            : AppTheme.achievementGold,
                        size: 24,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Achievement Name
                    Text(
                      widget.isLocked
                          ? 'Locked'
                          : widget.achievement?.name ?? 'Achievement',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (!widget.isLocked) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Earned!',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getAchievementIcon(String achievementName) {
    switch (achievementName.toLowerCase()) {
      case 'first steps':
      case 'first lesson':
        return FontAwesomeIcons.babyCarriage;
      case 'streak champion':
      case 'week streak':
        return FontAwesomeIcons.fire;
      case 'quiz master':
        return FontAwesomeIcons.brain;
      case 'story reader':
        return FontAwesomeIcons.book;
      case 'ai friend':
        return FontAwesomeIcons.robot;
      case 'math wizard':
        return FontAwesomeIcons.calculator;
      case 'word master':
        return FontAwesomeIcons.spell_check;
      default:
        return FontAwesomeIcons.trophy;
    }
  }
}
