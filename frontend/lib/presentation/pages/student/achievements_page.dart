// # File: frontend/lib/presentation/pages/student/achievements_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/achievements/achievements_bloc.dart';
import '../../widgets/achievement_badge.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AchievementsBloc>().add(const LoadAchievements(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: AppTheme.achievementGold,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.achievementGold, AppTheme.primaryOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    FontAwesomeIcons.trophy,
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Achievements',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Celebrate your learning journey!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Achievement Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Earned',
                    '8',
                    FontAwesomeIcons.medal,
                    AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Available',
                    '15',
                    FontAwesomeIcons.target,
                    AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Progress',
                    '53%',
                    FontAwesomeIcons.chartLine,
                    AppTheme.primaryPurple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              'Recent Achievements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            // Achievements List
            BlocBuilder<AchievementsBloc, AchievementsState>(
              builder: (context, state) {
                if (state is AchievementsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AchievementsLoaded) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: state.achievements.length +
                        4, // Add some locked achievements
                    itemBuilder: (context, index) {
                      if (index < state.achievements.length) {
                        final achievement = state.achievements[index];
                        return AchievementBadge(
                          title: achievement['name'] ?? 'Achievement',
                          description:
                              achievement['description'] ?? 'Well done!',
                          icon: achievement['badge_icon'] ?? '🏆',
                          isUnlocked: true,
                          earnedDate: achievement['earned_at'],
                        );
                      } else {
                        // Show locked achievements
                        final lockedAchievements = [
                          {
                            'title': 'Story Master',
                            'description': 'Read 10 AI-generated stories',
                            'icon': '📚',
                          },
                          {
                            'title': 'Math Wizard',
                            'description': 'Complete 20 math lessons',
                            'icon': '🧙‍♂️',
                          },
                          {
                            'title': 'Perfect Streak',
                            'description': 'Learn for 30 days straight',
                            'icon': '🔥',
                          },
                          {
                            'title': 'Explorer',
                            'description': 'Try all subject areas',
                            'icon': '🗺️',
                          },
                        ];

                        final lockedIndex = index - state.achievements.length;
                        if (lockedIndex < lockedAchievements.length) {
                          final locked = lockedAchievements[lockedIndex];
                          return AchievementBadge(
                            title: locked['title']!,
                            description: locked['description']!,
                            icon: locked['icon']!,
                            isUnlocked: false,
                          );
                        }
                      }
                      return const SizedBox();
                    },
                  );
                } else if (state is AchievementsError) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(
                          FontAwesomeIcons.exclamationTriangle,
                          size: 60,
                          color: AppTheme.primaryOrange,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Oops! Something went wrong',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.secondaryText,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<AchievementsBloc>()
                                .add(const LoadAchievements(1));
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
          ),
        ],
      ),
    );
  }
}
