// # File: frontend/lib/presentation/widgets/streak_counter.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';

class StreakCounter extends StatefulWidget {
  final int currentStreak;
  final int longestStreak;
  final VoidCallback? onStreakTap;

  const StreakCounter({
    Key? key,
    required this.currentStreak,
    required this.longestStreak,
    this.onStreakTap,
  }) : super(key: key);

  @override
  State<StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends State<StreakCounter>
    with TickerProviderStateMixin {
  late AnimationController _fireController;
  late AnimationController _bounceController;
  late Animation<double> _fireAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _fireController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fireAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _fireController,
      curve: Curves.easeInOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticInOut,
    ));

    _fireController.repeat(reverse: true);
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fireController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onStreakTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B35),
              Color(0xFFFF8E53),
              Color(0xFFFFA726),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Fire Icon Animation
            AnimatedBuilder(
              animation: _fireAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _fireAnimation.value,
                  child: const Icon(
                    FontAwesomeIcons.fire,
                    color: Colors.white,
                    size: 32,
                  ),
                );
              },
            ),

            const SizedBox(width: 16),

            // Streak Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _bounceAnimation.value,
                            child: Text(
                              '${widget.currentStreak}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Day Streak!',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Longest: ${widget.longestStreak} days',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Progress Bar
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (widget.currentStreak / 30).clamp(0.1, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Streak Flames
            Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index == 2 ? 0 : 4),
                  child: AnimatedBuilder(
                    animation: _fireController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.5 +
                            (_fireAnimation.value - 0.8) * (index + 1) * 0.1,
                        child: Icon(
                          FontAwesomeIcons.fire,
                          color: Colors.white.withOpacity(0.7 - index * 0.2),
                          size: 16 - index * 2,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
