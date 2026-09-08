import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common_widgets.dart';
import 'park_detail_screen.dart';

class ParkWiseAttendanceScreen extends StatelessWidget {
  const ParkWiseAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final today = AppDate.todayKey();
    final parks = MockData.parks;
    final markedCount = parks.where((p) => appState.isParkMarked(p.id, today)).length;

    return SafeArea(
      child: Padding(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            Text('Park Wise Attendance', style: theme.textTheme.headlineMedium),
            Text('Shabab + Murabbis · ${AppDate.longToday()}', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                children: [
                  Icon(Icons.insights_rounded, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text("Today's Progress: $markedCount of ${parks.length} parks marked", style: theme.textTheme.titleMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: parks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final p = parks[i];
                  final marked = appState.isParkMarked(p.id, today);
                  final groups = MockData.groupsForPark(p.id);
                  final totalMembers = groups.fold<int>(0, (a, g) => a + MockData.membersForGroup(g.id).length);
                  final present = groups.fold<int>(0, (a, g) => a + appState.presentCount(g.id, today));

                  return AppCard(
                    onTap: marked
                        ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ParkDetailScreen(parkId: p.id)))
                        : () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${p.name} has not marked attendance yet today')),
                            ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: theme.textTheme.titleMedium),
                              const SizedBox(height: 2),
                              Text(
                                marked ? '$present/$totalMembers Present' : 'Not marked yet',
                                style: theme.textTheme.bodySmall,
                              ),
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
