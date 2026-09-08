import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common_widgets.dart';
import '../shared/mark_attendance_screen.dart';

/// Shows the attendance a murabbi has already marked for their group.
/// A small "Edit" button lets the Park Admin correct it — this is the
/// screen that opens when tapping a MARKED tab in All Groups Status.
class GroupAttendanceDetailScreen extends StatelessWidget {
  final String groupId;
  const GroupAttendanceDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final isDark = appState.isDark;
    final group = MockData.groupById(groupId);
    final members = MockData.membersForGroup(groupId);
    final today = AppDate.todayKey();
    final statuses = appState.attendanceFor(groupId, today);
    final present = statuses.values.where((s) => s == AttendanceStatus.present).length;
    final absent = statuses.values.where((s) => s == AttendanceStatus.absent).length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: group.name,
                subtitle: '${group.murabbiName} · ${AppDate.longToday()}',
                trailing: TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MarkAttendanceScreen(
                        title: 'Edit Attendance',
                        subtitle: group.name,
                        dateLabel: AppDate.todayLabel(),
                        isEditing: true,
                        entries: members
                            .map((m) => AttendanceEntry(id: m.id, name: m.name, subtitle: m.phone, warningAbsences: m.consecutiveAbsences))
                            .toList(),
                        initialStatuses: statuses,
                        onSave: (s) => appState.markGroupAttendance(groupId, today, s),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Edit'),
                ),
              ),
              AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat(theme, 'Present', '$present', isDark ? AppColors.successDark : AppColors.successLight),
                    _stat(theme, 'Absent', '$absent', isDark ? AppColors.dangerDark : AppColors.dangerLight),
                    _stat(theme, 'Total', '${members.length}', theme.textTheme.titleLarge?.color ?? Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: members.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final m = members[i];
                    final status = statuses[m.id];
                    return AppCard(
                      child: Row(
                        children: [
                          MemberAvatar(name: m.name),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.name, style: theme.textTheme.titleMedium),
                                Text(m.phone, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          if (status != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: status.color(isDark).withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                status.label,
                                style: TextStyle(color: status.color(isDark), fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: color)),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}
