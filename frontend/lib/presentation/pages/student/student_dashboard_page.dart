import '../../../domain/entities/achievement.dart';
import '../../../domain/entities/user_points.dart';
// # File: frontend/lib/presentation/pages/student/student_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_router.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/achievements/achievements_bloc.dart';
import '../../widgets/points_display.dart';
import '../../widgets/streak_counter.dart';
import '../../widgets/achievement_badge.dart';
import '../../widgets/lesson_card.dart';
import '../../../domain/entities/lesson.dart';
import '../../widgets/progress_card.dart';
import '../../widgets/ai_assistant_button.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _welcomeController;
  late Animation<double> _welcomeAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _welcomeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _welcomeAnimation = CurvedAnimation(
      parent: _welcomeController,
      curve: Curves.elasticOut,
    );

    _welcomeController.forward();

    // Load user dashboard data
    context.read<UserBloc>().add(const LoadUserDashboard(1));
    context.read<AchievementsBloc>().add(LoadAchievements());
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _welcomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: BlocListener<AchievementsBloc, AchievementsState>(
              listener: (context, state) {
                if (state is AchievementUnlocked) {
                  _confettiController.play();
                  _showAchievementDialog(state.achievement);
                }
              },
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: AppTheme.primaryGradient,
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is UserLoaded) {
                                  return _buildWelcomeHeader(
                                      state.user.fullName ?? 'Student');
                                }
                                return _buildWelcomeHeader('Student');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Dashboard Content
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is UserLoaded) {
                              return _buildDashboardContent(state);
                            } else if (state is UserError) {
                              return Center(
                                  child: Text('Error: ${state.message}'));
                            }
                            return const SizedBox();
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.5708, // radians for 90 degrees (downward)
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                AppTheme.primaryBlue,
                AppTheme.primaryOrange,
                AppTheme.primaryGreen,
                AppTheme.primaryPurple,
                AppTheme.primaryYellow,
              ],
            ),
          ),

          // Floating AI Assistant
          Positioned(
            bottom: 20,
            right: 20,
            child: AIAssistantButton(
              onTap: () => Navigator.of(context).pushNamed(AppRouter.aiChat),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(String userName) {
    return AnimatedBuilder(
      animation: _welcomeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _welcomeAnimation.value,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome back,',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withAlpha((255 * 0.9).round()),
                          ),
                    ),
                    Text(
                      userName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * 0.2).round()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  FontAwesomeIcons.user,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardContent(UserLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Points Display
        if (state.points != null) _buildPointsSection(state.points!),

        const SizedBox(height: 24),

        // Streak Counter
        if (state.points != null)
          StreakCounter(
            currentStreak: state.points!.streakDays,
            longestStreak: state.points!
                .streakDays, // No longestStreak, use streakDays or remove if not needed
            onStreakTap: () => _showStreakInfo(),
          ),

        const SizedBox(height: 24),

        // Achievements Section
        _buildAchievementsSection(),

        const SizedBox(height: 24),

        // Recommended Lessons
        _buildRecommendedLessons(),

        const SizedBox(height: 24),

        // Continue Learning
        _buildContinueLearning(),

        const SizedBox(height: 100), // Space for floating button
      ],
    );
  }

  Widget _buildPointsSection(UserPoints points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PointsDisplay(
                title: 'Knowledge\nGems',
                points: points.knowledgeGems,
                color: AppTheme.knowledgeGems,
                icon: FontAwesomeIcons.gem,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PointsDisplay(
                title: 'Word\nCoins',
                points: points.wordCoins,
                color: AppTheme.wordCoins,
                icon: FontAwesomeIcons.coins,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PointsDisplay(
                title: 'Imagination\nSparks',
                points: points.imaginationSparks,
                color: AppTheme.imaginationSparks,
                icon: FontAwesomeIcons.lightbulb,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRouter.achievements),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<AchievementsBloc, AchievementsState>(
          builder: (context, state) {
            if (state is AchievementsLoaded) {
              return SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (state.achievements.length + 2).clamp(0, 5),
                  itemBuilder: (context, index) {
                    if (index < state.achievements.length) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: AchievementBadge(
                          achievement: state.achievements[index],
                          onTap: () =>
                              _showAchievementDialog(state.achievements[index]),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: AchievementBadge(
                          achievement: Achievement(
                            id: -1,
                            title: 'Locked',
                            description: 'Unlock to reveal!',
                            iconName: 'lock',
                            pointsRequired: 0,
                            category: 'locked',
                            isUnlocked: false,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            }
            return const SizedBox(height: 120);
          },
        ),
      ],
    );
  }

  Widget _buildRecommendedLessons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended for You',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              LessonCard(
                lesson: Lesson(
                  id: 1,
                  title: 'Fun with Numbers',
                  description: 'A fun math lesson.',
                  content: '',
                  grade: 2,
                  subject: 'Math',
                  difficulty: 'Easy',
                  estimatedDuration: 10,
                  createdAt: DateTime.now(),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRouter.lesson,
                  arguments: {'lessonId': 1},
                ),
              ),
              LessonCard(
                lesson: Lesson(
                  id: 2,
                  title: 'Letter Adventures',
                  description: 'An English lesson.',
                  content: '',
                  grade: 2,
                  subject: 'English',
                  difficulty: 'Easy',
                  estimatedDuration: 8,
                  createdAt: DateTime.now(),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRouter.lesson,
                  arguments: {'lessonId': 2},
                ),
              ),
              LessonCard(
                lesson: Lesson(
                  id: 3,
                  title: 'Science Wonders',
                  description: 'A science lesson.',
                  content: '',
                  grade: 2,
                  subject: 'Science',
                  difficulty: 'Medium',
                  estimatedDuration: 12,
                  createdAt: DateTime.now(),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRouter.lesson,
                  arguments: {'lessonId': 3},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueLearning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Learning',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ProgressCard(
          progress: _mockProgressData(),
          onTap: () => Navigator.of(context).pushNamed(
            AppRouter.lesson,
            arguments: {'lessonId': 4},
          ),
        ),
      ],
    );
  }

  dynamic _mockProgressData() {
    return {
      'title': 'Counting to 20',
      'subject': 'Math',
      'estimatedDuration': 7,
      'completionPercentage': 65.0,
    };
  }

  void _showAchievementDialog(dynamic achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              FontAwesomeIcons.trophy,
              size: 60,
              color: AppTheme.achievementGold,
            ),
            const SizedBox(height: 16),
            Text(
              'Achievement Unlocked!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement?.name ?? 'New Achievement',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              achievement?.description ?? 'Keep up the great work!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  void _showStreakInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              FontAwesomeIcons.fire,
              size: 60,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(height: 16),
            Text(
              'Learning Streak',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Keep learning every day to maintain your streak and earn bonus points!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
