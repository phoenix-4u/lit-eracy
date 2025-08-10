// File: frontend/lib/presentation/pages/student/student_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/achievements/achievements_bloc.dart';
import '../../blocs/content/content_bloc.dart';
import '../../widgets/achievement_badge.dart';
import '../../widgets/lesson_card.dart';
import '../../widgets/progress_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/token_storage.dart';
import '../../../domain/entities/lesson.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _welcomeAnimationController;
  late AnimationController _statsAnimationController;
  late Animation<double> _welcomeAnimation;
  late Animation<double> _statsAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _welcomeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _statsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _welcomeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.easeOutBack,
    ));

    _statsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _statsAnimationController,
      curve: Curves.elasticOut,
    ));

    // Load dashboard data
    loadDashboardData();

    // Start animations
    _welcomeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _statsAnimationController.forward();
    });
  }

  Future<void> loadDashboardData() async {
    final token = await TokenStorage.getToken();
    if (mounted) {
      context.read<UserBloc>().add(LoadUserDashboardWithToken(token: token));
      context.read<AchievementsBloc>().add(LoadAchievements());
      context.read<ContentBloc>().add(const LoadLessons());
    }
  }

  @override
  void dispose() {
    _welcomeAnimationController.dispose();
    _statsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadDashboardData,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar
              buildCustomAppBar(),

              // Welcome Section
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _welcomeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _welcomeAnimation.value,
                      child: Opacity(
                        opacity: _welcomeAnimation.value,
                        child: buildWelcomeSection(),
                      ),
                    );
                  },
                ),
              ),

              // Stats Cards
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _statsAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _statsAnimation.value)),
                      child: Opacity(
                        opacity: _statsAnimation.value,
                        child: buildStatsSection(),
                      ),
                    );
                  },
                ),
              ),

              // Achievement Section
              SliverToBoxAdapter(
                child: buildAchievementsSection(),
              ),

              // Progress Section
              SliverToBoxAdapter(
                child: buildProgressSection(),
              ),

              // Recent Lessons
              SliverToBoxAdapter(
                child: buildRecentLessonsSection(),
              ),

              // AI Assistant Quick Access
              SliverToBoxAdapter(
                child: buildAIAssistantSection(),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget buildCustomAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      snap: true,
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
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
        ),
        title: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              final userName = state.user.email
                  .split('@')
                  .first; // Using email as fallback for name
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white.withAlpha(51),
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Hi, ${userName.split(' ').first}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }
            return const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            showNotifications(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            navigateToSettings();
          },
        ),
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              return Chip(
                avatar: const Icon(FontAwesomeIcons.gem, color: Colors.white),
                label: Text(
                  '${state.totalPoints}',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AppTheme.primaryBlue,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue.withValues(alpha: 0.1),
            AppTheme.primaryPurple.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  FontAwesomeIcons.bookOpen,
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to Learn?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryText,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Continue your AI literacy journey',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                return Row(
                  children: [
                    Expanded(
                      child: buildMiniStatCard(
                        'Study Time',
                        '2h 30m',
                        FontAwesomeIcons.clock,
                        AppTheme.successGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildMiniStatCard(
                        'This Week',
                        '${state.numLessons} lessons',
                        FontAwesomeIcons.calendar,
                        AppTheme.primaryOrange,
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget buildMiniStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatsSection() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    'Points',
                    '${state.totalPoints}',
                    FontAwesomeIcons.star,
                    AppTheme.achievementGold,
                    AppTheme.achievementGold.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStatCard(
                    'Level',
                    '${state.level}',
                    FontAwesomeIcons.trophy,
                    AppTheme.successGreen,
                    AppTheme.successGreen.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildStatCard(
                    'Streak',
                    '${state.currentStreak}',
                    FontAwesomeIcons.fire,
                    AppTheme.primaryOrange,
                    AppTheme.primaryOrange.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          );
        }
        return buildSkeletonStats();
      },
    );
  }

  Widget buildStatCard(String title, String value, IconData icon, Color color,
      Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSkeletonStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildAchievementsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.medal,
                    color: AppTheme.achievementGold,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Achievements',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  navigateToAchievements();
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<AchievementsBloc, AchievementsState>(
            builder: (context, state) {
              if (state is AchievementsLoaded) {
                if (state.achievements.isEmpty) {
                  return buildEmptyAchievements();
                }
                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.achievements.take(5).length,
                    itemBuilder: (context, index) {
                      final achievement = state.achievements[index];
                      return Container(
                        margin: EdgeInsets.only(right: index < 4 ? 12 : 0),
                        child: AchievementBadge(
                          achievement: achievement,
                        ),
                      );
                    },
                  ),
                );
              }
              return buildSkeletonAchievements();
            },
          ),
        ],
      ),
    );
  }

  Widget buildEmptyAchievements() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.trophy,
            color: Colors.grey.shade400,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Complete lessons to earn achievements!',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildSkeletonAchievements() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: EdgeInsets.only(right: index < 4 ? 12 : 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  Widget buildProgressSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.chartLine,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Learning Progress',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: ProgressCard(
                  subject: 'Reading',
                  progress: 0.75,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ProgressCard(
                  subject: 'Math',
                  progress: 0.60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: ProgressCard(
                  subject: 'Science',
                  progress: 0.45,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ProgressCard(
                  subject: 'AI Basics',
                  progress: 0.30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRecentLessonsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.bookOpen,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Continue Learning',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  navigateToAllLessons();
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                if (state.recentLessons.isEmpty) {
                  return buildEmptyLessons();
                }
                return Column(
                  children: state.recentLessons.take(3).map((lessonEntity) {
                    // Convert LessonInfoEntity to Lesson for LessonCard
                    final lesson = Lesson(
                      id: lessonEntity.id,
                      title: lessonEntity.title,
                      subject: lessonEntity.subject,
                      gradeLevel: lessonEntity.gradeLevel,
                      pointsReward: lessonEntity.pointsReward,
                      estimatedDuration: lessonEntity.estimatedDuration,
                      description: '', // Add default if needed
                      isCompleted: false, // Add default if needed
                    );
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: LessonCard(
                        lesson: lesson,
                        onTap: () {
                          navigateToLesson(lesson);
                        },
                      ),
                    );
                  }).toList(),
                );
              }
              return buildSkeletonLessons();
            },
          ),
        ],
      ),
    );
  }

  Widget buildEmptyLessons() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.bookOpen,
            color: Colors.grey.shade400,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No lessons available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new content',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
    );
  }

  Widget buildSkeletonLessons() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }),
    );
  }

  Widget buildAIAssistantSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryPurple.withValues(alpha: 0.1),
            AppTheme.imaginationSparks.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryPurple.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              FontAwesomeIcons.robot,
              color: AppTheme.primaryPurple,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Learning Assistant',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryText,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ask questions and get personalized help',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              navigateToAIChat();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Chat'),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        showQuickActions(context);
      },
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      icon: const Icon(FontAwesomeIcons.plus),
      label: const Text('Quick Start'),
    );
  }

  // Navigation Methods
  void navigateToSettings() {
    // Navigator.pushNamed(context, '/settings');
  }

  void navigateToAchievements() {
    // Navigator.pushNamed(context, '/achievements');
  }

  void navigateToAllLessons() {
    // Navigator.pushNamed(context, '/lessons');
  }

  void navigateToLesson(Lesson lesson) {
    // Navigator.pushNamed(context, '/lesson', arguments: lesson);
  }

  void navigateToAIChat() {
    // Navigator.pushNamed(context, '/ai-chat');
  }

  // Dialog Methods
  void showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.bell,
                        color: Colors.grey.shade400,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No new notifications',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              buildQuickActionTile(
                'Start New Lesson',
                'Begin a new learning session',
                FontAwesomeIcons.play,
                AppTheme.primaryBlue,
                () {
                  Navigator.pop(context);
                  navigateToAllLessons();
                },
              ),
              buildQuickActionTile(
                'Take Quiz',
                'Test your knowledge',
                FontAwesomeIcons.circleQuestion,
                AppTheme.primaryGreen,
                () {
                  Navigator.pop(context);
                  // Navigate to quiz
                },
              ),
              buildQuickActionTile(
                'Chat with AI',
                'Get help from AI assistant',
                FontAwesomeIcons.robot,
                AppTheme.primaryPurple,
                () {
                  Navigator.pop(context);
                  navigateToAIChat();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget buildQuickActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.grey.shade50,
      ),
    );
  }
}
