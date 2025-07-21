import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/achievement/achievement_bloc.dart';
import '../../core/constants.dart';

class ParentDashboardPage extends StatelessWidget {
  final int userId;
  ParentDashboardPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AchievementBloc(getIt())..add(LoadAchievements(userId)),
      child: Scaffold(
        appBar: AppBar(title: Text('Parent Dashboard')),
        body: Column(
          children: [
            _buildScreenTimeControls(context),
            Expanded(child: BlocBuilder<AchievementBloc, AchievementState>(
              builder: (ctx, state) {
                if (state is AchievementLoading) return CircularProgressIndicator();
                if (state is AchievementLoaded) {
                  return GridView.count(
                    crossAxisCount: 3,
                    children: state.achievements
                        .map((a) => AchievementBadge(achievement: a))
                        .toList();
                }
                return Center(child: Text('No achievements'));
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenTimeControls(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Screen Time Limit:'),
          Slider(
            min: 0,
            max: 240,
            divisions: 24,
            label: '${AppConstants.apiTimeout.inMinutes} min',
            value: AppConstants.splashDelaySeconds.toDouble(),
            onChanged: (v) {/* save to Hive settingsBox */},
          )
        ],
      ),
    );
  }
}
