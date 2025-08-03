import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_literacy_app/core/di.dart';
import 'package:ai_literacy_app/presentation/blocs/achievements/achievements_bloc.dart';
import 'package:ai_literacy_app/presentation/widgets/achievement_badge.dart';

class ParentDashboardPage extends StatelessWidget {
  final int userId;

  const ParentDashboardPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AchievementsBloc>()..add(LoadAchievements()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Parent Dashboard')),
        body: Column(
          children: [
            _buildScreenTimeControls(context),
            Expanded(
              child: BlocBuilder<AchievementsBloc, AchievementsState>(
                builder: (context, state) {
                  if (state is AchievementsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AchievementsLoaded) {
                    return GridView.count(
                      crossAxisCount: 3,
                      children: state.achievements
                          .map((a) => AchievementBadge(achievement: a))
                          .toList(),
                    );
                  }
                  if (state is AchievementsError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No achievements'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenTimeControls(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Screen Time Controls'),
          Text('Implementation for screen time management here'),
        ],
      ),
    );
  }
}
