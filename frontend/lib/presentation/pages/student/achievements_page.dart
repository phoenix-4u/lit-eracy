// # File: frontend/lib/presentation/pages/student/achievements_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/achievement.dart';
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
    // FIX: Removed 'const' because LoadAchievements does not have a const constructor.
    context.read<AchievementsBloc>().add(LoadAchievements());
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
                          color: Colors.white.withAlpha((255 * 0.9).round()),
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
                    FontAwesomeIcons.bullseye,
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
              'Your Collection',
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
                  final lockedAchievements = [
                    const Achievement(
                        id: -1,
                        title: 'Story Master',
                        description: 'Read 10 AI-generated stories',
                        iconName: 'book',
                        rarity: 'Silver',
                        pointsRequired: 50,
                        category: 'Reading',
                        isUnlocked: false),
                    const Achievement(
                        id: -2,
                        title: 'Math Wizard',
                        description: 'Complete 20 math lessons',
                        iconName: 'graduation',
                        rarity: 'Gold',
                        pointsRequired: 100,
                        category: 'Math',
                        isUnlocked: false),
                    const Achievement(
                        id: -3,
                        title: 'Perfect Streak',
                        description: 'Learn for 30 days straight',
                        iconName: 'fire',
                        rarity: 'Platinum',
                        pointsRequired: 200,
                        category: 'General',
                        isUnlocked: false),
                    const Achievement(
                        id: -4,
                        title: 'Explorer',
                        description: 'Try all subject areas',
                        iconName: 'target',
                        rarity: 'Bronze',
                        pointsRequired: 20,
                        category: 'General',
                        isUnlocked: false),
                  ];

                  final allAchievements = [
                    ...state.achievements,
                    ...lockedAchievements
                  ];

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
                    itemCount: allAchievements.length,
                    itemBuilder: (context, index) {
                      final achievement = allAchievements[index];
                      return AchievementBadge(achievement: achievement);
                    },
                  );
                } else if (state is AchievementsError) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(
                          FontAwesomeIcons.triangleExclamation,
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
                            context.read<AchievementsBloc>().add(
                                LoadAchievements()); // Also removed const here
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
            color: Colors.black.withAlpha((255 * 0.1).round()),
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
