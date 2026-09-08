import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common_widgets.dart';
import '../shared/mark_attendance_screen.dart';

class MurabbiHomeScreen extends StatelessWidget {
  final void Function(int tabIndex) onNavigate;
  const MurabbiHomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser!;
    final theme = Theme.of(context);
    final groupId = user.ownGroupId!;
    final group = MockData.groupById(groupId);
    final members = MockData.membersForGroup(groupId);
    final today = AppDate.todayKey();
    final marked = appState.isGroupMarked(groupId, today);
    final present = appState.presentCount(groupId, today);

    return SafeArea(
      child: SingleChildScrollView(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            HomeGreetingHeader(user: user, isDark: appState.isDark, onThemeToggle: appState.toggleTheme),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(child: StatPill(value: '${members.length}', label: 'Class Strength', icon: Icons.groups_rounded, color: AppColors.roleMurabbi)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: marked ? '$present/${members.length}' : '—', label: "Today's Present", icon: Icons.how_to_reg_rounded, color: theme.brightness == Brightness.dark ? AppColors.successDark : AppColors.successLight)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: '${group.name}', label: 'Your Group', icon: Icons.workspace_premium_rounded, color: theme.brightness == Brightness.dark ? AppColors.warningDark : AppColors.warningLight)),
              ],
            ),
            const SizedBox(height: 20),
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Today's Attendance", style: theme.textTheme.titleLarge)),
                      MarkedStatusChip(marked: marked),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(AppDate.longToday(), style: theme.textTheme.bodySmall),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _openMark(context, appState, groupId, members),
                    icon: Icon(marked ? Icons.edit_rounded : Icons.check_circle_outline_rounded, size: 18),
                    label: Text(marked ? 'Edit Attendance' : 'Mark Now'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionTitle(title: 'Quick Actions'),
            MenuActionCard(
              icon: Icons.fact_check_rounded,
              title: 'Mark Group Attendance',
              subtitle: "Record today's Shabab attendance",
              color: AppColors.roleMurabbi,
              onTap: () => _openMark(context, appState, groupId, members),
            ),
            const SizedBox(height: 12),
            MenuActionCard(
              icon: Icons.bar_chart_rounded,
              title: 'View Attendance Report',
              subtitle: 'Weekly, monthly & all-time stats',
              color: theme.brightness == Brightness.dark ? AppColors.infoDark : AppColors.infoLight,
              onTap: () => onNavigate(1),
            ),
            const SizedBox(height: 12),
            MenuActionCard(
              icon: Icons.emoji_events_rounded,
              title: 'Murabbi Leaderboard',
              subtitle: 'See how your group ranks',
              color: theme.brightness == Brightness.dark ? AppColors.warningDark : AppColors.warningLight,
              onTap: () => onNavigate(2),
            ),
          ],
        ),
      ),
    );
  }

  void _openMark(BuildContext context, AppState appState, String groupId, List<ShababMember> members) {
    final today = AppDate.todayKey();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MarkAttendanceScreen(
          title: 'Mark Attendance',
          subtitle: MockData.groupById(groupId).name,
          dateLabel: AppDate.todayLabel(),
          isEditing: appState.isGroupMarked(groupId, today),
          entries: members
              .map((m) => AttendanceEntry(id: m.id, name: m.name, subtitle: m.phone, warningAbsences: m.consecutiveAbsences))
              .toList(),
          initialStatuses: appState.attendanceFor(groupId, today),
          onSave: (statuses) => appState.markGroupAttendance(groupId, today, statuses),
        ),
      ),
    );
  }
}
