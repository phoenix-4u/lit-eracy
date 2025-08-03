// # File: frontend/lib/presentation/pages/teacher/teacher_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_theme.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Notifications
            },
            icon: const Icon(FontAwesomeIcons.bell),
          ),
          IconButton(
            onPressed: () {
              // Settings
            },
            icon: const Icon(FontAwesomeIcons.gear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryPurple, AppTheme.primaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            Colors.white.withAlpha((255 * 0.2).round()),
                        child: const Icon(
                          FontAwesomeIcons.chalkboardUser,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, Ms. Sarah!',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Grade 2A • 24 Students',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white
                                        .withAlpha((255 * 0.9).round()),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildQuickStat(
                          'Active Today', '18/24', FontAwesomeIcons.users),
                      const SizedBox(width: 20),
                      _buildQuickStat(
                          'Avg. Progress', '78%', FontAwesomeIcons.chartLine),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Create Lesson',
                    FontAwesomeIcons.plus,
                    AppTheme.primaryGreen,
                    () {
                      // Create lesson
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'Assign Quiz',
                    FontAwesomeIcons.circleQuestion,
                    AppTheme.primaryOrange,
                    () {
                      // Assign quiz
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'View Reports',
                    FontAwesomeIcons.chartBar,
                    AppTheme.primaryBlue,
                    () {
                      // View reports
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Class Performance Overview
            Text(
              'Class Performance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildPerformanceCard(
                    'Mathematics',
                    '82%',
                    '+5% from last week',
                    FontAwesomeIcons.calculator,
                    AppTheme.primaryBlue,
                    true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPerformanceCard(
                    'Reading',
                    '91%',
                    '+2% from last week',
                    FontAwesomeIcons.book,
                    AppTheme.primaryGreen,
                    true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildPerformanceCard(
                    'Science',
                    '74%',
                    '-3% from last week',
                    FontAwesomeIcons.microscope,
                    AppTheme.primaryOrange,
                    false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPerformanceCard(
                    'Writing',
                    '86%',
                    '+7% from last week',
                    FontAwesomeIcons.pen,
                    AppTheme.primaryPurple,
                    true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Student Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // View all activity
                  },
                  child: const Text('View All'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
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
                  _buildStudentActivityItem(
                    'Emma Johnson',
                    'Completed "Fun with Numbers" lesson',
                    '15 minutes ago',
                    AppTheme.primaryGreen,
                  ),
                  const Divider(height: 1),
                  _buildStudentActivityItem(
                    'Michael Chen',
                    'Scored 95% on Reading Quiz',
                    '1 hour ago',
                    AppTheme.primaryBlue,
                  ),
                  const Divider(height: 1),
                  _buildStudentActivityItem(
                    'Sofia Rodriguez',
                    'Earned "Math Wizard" achievement',
                    '2 hours ago',
                    AppTheme.achievementGold,
                  ),
                  const Divider(height: 1),
                  _buildStudentActivityItem(
                    'Jake Thompson',
                    'Asked for help in Science',
                    '3 hours ago',
                    AppTheme.primaryOrange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Students Needing Attention
            Text(
              'Students Needing Attention',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Container(
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
                  _buildAttentionStudentItem(
                    'Alex Wilson',
                    'Struggling with multiplication',
                    'Math • 3 failed attempts',
                    AppTheme.primaryOrange,
                  ),
                  const Divider(height: 1),
                  _buildAttentionStudentItem(
                    'Lily Chang',
                    'Low engagement this week',
                    'Only 2 lessons completed',
                    AppTheme.primaryOrange,
                  ),
                  const Divider(height: 1),
                  _buildAttentionStudentItem(
                    'David Brown',
                    'Excellent progress!',
                    'Completed all assignments',
                    AppTheme.primaryGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withAlpha((255 * 0.9).round()),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(
    String subject,
    String percentage,
    String change,
    IconData icon,
    Color color,
    bool isPositive,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Icon(
                isPositive
                    ? FontAwesomeIcons.arrowUp
                    : FontAwesomeIcons.arrowDown,
                color:
                    isPositive ? AppTheme.primaryGreen : AppTheme.primaryOrange,
                size: 12,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            percentage,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subject,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isPositive
                      ? AppTheme.primaryGreen
                      : AppTheme.primaryOrange,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentActivityItem(
      String name, String activity, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withAlpha((255 * 0.2).round()),
            child: Text(
              name.split(' ').map((n) => n[0]).join(''),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  activity,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

  Widget _buildAttentionStudentItem(
      String name, String issue, String details, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withAlpha((255 * 0.2).round()),
            child: Text(
              name.split(' ').map((n) => n[0]).join(''),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  issue,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  details,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            FontAwesomeIcons.chevronRight,
            color: AppTheme.secondaryText,
            size: 16,
          ),
        ],
      ),
    );
  }
}
