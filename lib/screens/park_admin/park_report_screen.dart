import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common_widgets.dart';

int _pseudoPercent(String seed, int period) {
  final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b) + period * 7;
  return 60 + (hash % 40);
}

class ParkReportScreen extends StatefulWidget {
  const ParkReportScreen({super.key});

  @override
  State<ParkReportScreen> createState() => _ParkReportScreenState();
}

class _ParkReportScreenState extends State<ParkReportScreen> {
  int _period = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser!;
    final theme = Theme.of(context);
    final isDark = appState.isDark;
    final groups = MockData.groupsForPark(user.parkId);
    final totalMembers = groups.fold<int>(0, (a, g) => a + MockData.membersForGroup(g.id).length);
    final avg = groups.isEmpty
        ? 0
        : (groups.map((g) => _pseudoPercent(g.id, _period)).reduce((a, b) => a + b) / groups.length).round();

    return SafeArea(
      child: Padding(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            Text('Attendance Report', style: theme.textTheme.headlineMedium),
            Text('${MockData.parkById(user.parkId).name} · Park-wide overview', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            PeriodTabs(
              options: const ['This Week', 'This Month', 'All Time'],
              selectedIndex: _period,
              onChanged: (i) => setState(() => _period = i),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: StatPill(value: '${groups.length}', label: 'Groups', icon: Icons.groups_2_rounded, color: AppColors.roleParkAdmin)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: '$totalMembers', label: 'Total Shabab', icon: Icons.groups_rounded, color: isDark ? AppColors.infoDark : AppColors.infoLight)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: '$avg%', label: 'Avg Attendance', icon: Icons.trending_up_rounded, color: isDark ? AppColors.successDark : AppColors.successLight)),
              ],
            ),
            const SizedBox(height: 16),
            SectionTitle(title: 'By Group'),
            Expanded(
              child: ListView.separated(
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final g = groups[i];
                  final pct = _pseudoPercent(g.id, _period);
                  final color = pct >= 85
                      ? (isDark ? AppColors.successDark : AppColors.successLight)
                      : pct >= 70
                          ? (isDark ? AppColors.warningDark : AppColors.warningLight)
                          : (isDark ? AppColors.dangerDark : AppColors.dangerLight);
                  return AppCard(
                    child: Row(
                      children: [
                        MemberAvatar(name: g.murabbiName),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.name, style: theme.textTheme.titleMedium),
                              Text('${g.murabbiName} · ${MockData.membersForGroup(g.id).length} shabab', style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Text('$pct%', style: theme.textTheme.titleLarge?.copyWith(color: color)),
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
