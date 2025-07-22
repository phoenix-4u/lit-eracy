import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lit_eracy/core/di.dart';
import 'package:lit_eracy/presentation/blocs/achievement/achievement_bloc.dart';
import 'package:lit_eracy/presentation/widgets/achievement_badge.dart';

class ParentDashboardPage extends StatelessWidget {
  final int userId;

  const ParentDashboardPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AchievementBloc>()..add(LoadAchievements(userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Parent Dashboard')),
        body: Column(
          children: [
            _buildScreenTimeControls(context),
            Expanded(
              child: BlocBuilder<AchievementBloc, AchievementState>(
                builder: (context, state) {
                  if (state is AchievementLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AchievementLoaded) {
                    return GridView.count(
                      crossAxisCount: 3,
                      children: state.achievements
                          .map((a) => AchievementBadge(achievement: a))
                          .toList(),
                    );
                  }
                  if (state is AchievementError) {
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
