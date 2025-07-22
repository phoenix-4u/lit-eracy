import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lit_eracy/core/di.dart';
import 'package:lit_eracy/domain/usecases/fetch_achievements_usecase.dart';
import 'package:lit_eracy/presentation/blocs/achievement/achievement_bloc.dart';
import 'package:lit_eracy/presentation/widgets/achievement_badge.dart';

class ParentDashboardPage extends StatelessWidget {
  final int userId;
  const ParentDashboardPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AchievementBloc(getIt<FetchAchievementsUseCase>())..add(LoadAchievements(userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Parent Dashboard')),
        body: Column(
          children: [
            _buildScreenTimeControls(context),
            Expanded(
              child: BlocBuilder<AchievementBloc, AchievementState>(
                builder: (ctx, state) {
                  if (state is AchievementLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is AchievementLoaded) {
                    return GridView.count(
                      crossAxisCount: 3,
                      children: state.achievements.map((a) => AchievementBadge(achievement: a)).toList(),
                    );
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Screen Time Limit:'),
          Slider(
            min: 0,
            max: 240,
            divisions: 24,
            label: '${120} min',
            value: 120,
            onChanged: (v) {/* save to Hive settingsBox */},
          )
        ],
      ),
    );
  }
}
