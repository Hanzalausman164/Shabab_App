import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common_widgets.dart';
import '../shared/mark_attendance_screen.dart';
import 'registration_screen.dart';

class HeadMurabbiHomeScreen extends StatelessWidget {
  final void Function(int tabIndex) onNavigate;
  const HeadMurabbiHomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser!;
    final park = MockData.parkById(user.parkId);
    final groups = MockData.groupsForPark(park.id);
    final theme = Theme.of(context);
    final isDark = appState.isDark;
    final today = AppDate.todayKey();
    final markedGroups = groups.where((g) => appState.isGroupMarked(g.id, today)).length;
    final murabbeenMarked = appState.isMurabbeenMarked(park.id, today);

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
                Expanded(child: StatPill(value: park.name.split(' ').first, label: park.name, icon: Icons.park_rounded, color: AppColors.roleHeadMurabbi)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: '$markedGroups/${groups.length}', label: 'Groups Marked', icon: Icons.groups_2_rounded, color: isDark ? AppColors.successDark : AppColors.successLight)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: murabbeenMarked ? 'Marked' : 'Pending', label: 'Murabbeen', icon: Icons.badge_rounded, color: isDark ? AppColors.warningDark : AppColors.warningLight)),
              ],
            ),
            const SizedBox(height: 24),
            SectionTitle(title: 'Attendance Actions'),
            MenuActionCard(
              icon: Icons.how_to_reg_rounded,
              title: 'Mark Murabbeen Attendance',
              subtitle: 'Record which murabbis are present today',
              color: AppColors.roleHeadMurabbi,
              onTap: () => _openMurabbeen(context, appState, park.id),
            ),
            const SizedBox(height: 12),
            MenuActionCard(
              icon: Icons.fact_check_rounded,
              title: 'Mark Own Group Shabab Attendance',
              subtitle: user.ownGroupId != null ? MockData.groupById(user.ownGroupId!).name : 'No group assigned',
              color: AppColors.roleMurabbi,
              onTap: user.ownGroupId != null ? () => _openOwnGroup(context, appState, user.ownGroupId!) : () {},
            ),
            const SizedBox(height: 12),
            MenuActionCard(
              icon: Icons.checklist_rtl_rounded,
              title: 'All Groups Attendance Status',
              subtitle: 'See which murabbis have marked attendance',
              color: isDark ? AppColors.infoDark : AppColors.infoLight,
              onTap: () => onNavigate(1),
            ),
            const SizedBox(height: 20),
            SectionTitle(title: 'More'),
            MenuActionCard(
              icon: Icons.bar_chart_rounded,
              title: 'Attendance Report',
              subtitle: 'Weekly, monthly & all-time park stats',
              color: isDark ? AppColors.warningDark : AppColors.warningLight,
              onTap: () => onNavigate(2),
            ),
            const SizedBox(height: 12),
            MenuActionCard(
              icon: Icons.person_add_alt_1_rounded,
              title: 'New Shabab Registration',
              subtitle: 'Register a new shabab member',
              color: isDark ? AppColors.dangerDark : AppColors.dangerLight,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegistrationScreen())),
            ),
          ],
        ),
      ),
    );
  }

  void _openMurabbeen(BuildContext context, AppState appState, String parkId) {
    final today = AppDate.todayKey();
    final park = MockData.parkById(parkId);
    final groups = MockData.groupsForPark(parkId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MarkAttendanceScreen(
          title: 'Mark Murabbeen',
          subtitle: park.name,
          dateLabel: AppDate.todayLabel(),
          isEditing: appState.isMurabbeenMarked(parkId, today),
          entries: groups.map((g) => AttendanceEntry(id: g.murabbiId, name: g.murabbiName, subtitle: g.name)).toList(),
          initialStatuses: appState.murabbeenAttendanceFor(parkId, today),
          onSave: (statuses) => appState.markMurabbeenAttendance(parkId, today, statuses),
        ),
      ),
    );
  }

  void _openOwnGroup(BuildContext context, AppState appState, String groupId) {
    final today = AppDate.todayKey();
    final members = MockData.membersForGroup(groupId);
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
