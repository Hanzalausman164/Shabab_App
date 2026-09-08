import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common_widgets.dart';
import '../shared/mark_attendance_screen.dart';
import 'group_attendance_detail_screen.dart';

class AllGroupsStatusScreen extends StatelessWidget {
  const AllGroupsStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser!;
    final theme = Theme.of(context);
    final groups = MockData.groupsForPark(user.parkId);
    final today = AppDate.todayKey();
    final markedCount = groups.where((g) => appState.isGroupMarked(g.id, today)).length;

    return SafeArea(
      child: Padding(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            Text('All Groups Status', style: theme.textTheme.headlineMedium),
            Text("Today's murabbi attendance marking status", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                children: [
                  Icon(Icons.insights_rounded, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Today's Progress: $markedCount of ${groups.length} groups marked",
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final g = groups[i];
                  final marked = appState.isGroupMarked(g.id, today);
                  final members = MockData.membersForGroup(g.id);
                  final present = appState.presentCount(g.id, today);
                  return AppCard(
                    onTap: () {
                      if (marked) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => GroupAttendanceDetailScreen(groupId: g.id)),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MarkAttendanceScreen(
                              title: 'Mark Attendance',
                              subtitle: g.name,
                              dateLabel: AppDate.todayLabel(),
                              entries: members
                                  .map((m) => AttendanceEntry(id: m.id, name: m.name, subtitle: m.phone, warningAbsences: m.consecutiveAbsences))
                                  .toList(),
                              initialStatuses: appState.attendanceFor(g.id, today),
                              onSave: (statuses) => appState.markGroupAttendance(g.id, today, statuses),
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        MemberAvatar(name: g.murabbiName),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.name, style: theme.textTheme.titleMedium),
                              Text(g.murabbiName, style: theme.textTheme.bodySmall),
                              if (marked) ...[
                                const SizedBox(height: 2),
                                Text('$present/${members.length} present', style: theme.textTheme.labelMedium),
                              ],
                            ],
                          ),
                        ),
                        MarkedStatusChip(marked: marked),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right_rounded, size: 18),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
