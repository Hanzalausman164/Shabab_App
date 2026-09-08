import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common_widgets.dart';

/// Deterministic pseudo-percentage so the same member always shows the same
/// number for a given period in this demo build (stand-in for real
/// historical attendance data from a backend).
int _pseudoPercent(String seed, int period) {
  final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b) + period * 7;
  return 60 + (hash % 40);
}

class MurabbiReportScreen extends StatefulWidget {
  const MurabbiReportScreen({super.key});

  @override
  State<MurabbiReportScreen> createState() => _MurabbiReportScreenState();
}

class _MurabbiReportScreenState extends State<MurabbiReportScreen> {
  int _period = 0;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser!;
    final theme = Theme.of(context);
    final isDark = appState.isDark;
    final members = MockData.membersForGroup(user.ownGroupId!)
        .where((m) => m.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    final avg = members.isEmpty
        ? 0
        : (members.map((m) => _pseudoPercent(m.id, _period)).reduce((a, b) => a + b) / members.length).round();

    return SafeArea(
      child: Padding(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            Text('Attendance Report', style: theme.textTheme.headlineMedium),
            Text('${MockData.groupById(user.ownGroupId!).name} · Shabab attendance history', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            PeriodTabs(
              options: const ['This Week', 'This Month', 'Overall'],
              selectedIndex: _period,
              onChanged: (i) => setState(() => _period = i),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: StatPill(value: '${members.length}', label: 'Strength', icon: Icons.groups_rounded, color: AppColors.roleMurabbi)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: '$avg%', label: 'Avg Attendance', icon: Icons.trending_up_rounded, color: isDark ? AppColors.successDark : AppColors.successLight)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: '${members.where((m) => m.consecutiveAbsences >= 3).length}', label: 'At Risk', icon: Icons.warning_amber_rounded, color: isDark ? AppColors.warningDark : AppColors.warningLight)),
              ],
            ),
            const SizedBox(height: 16),
            AppSearchField(hint: 'Search shabab members...', onChanged: (v) => setState(() => _query = v)),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final m = members[i];
                  final pct = _pseudoPercent(m.id, _period);
                  final color = pct >= 85
                      ? (isDark ? AppColors.successDark : AppColors.successLight)
                      : pct >= 70
                          ? (isDark ? AppColors.warningDark : AppColors.warningLight)
                          : (isDark ? AppColors.dangerDark : AppColors.dangerLight);
                  return AppCard(
                    child: Row(
                      children: [
                        MemberAvatar(name: m.name),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(child: Text(m.name, style: theme.textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
                                  if (m.consecutiveAbsences >= 3) ...[
                                    const SizedBox(width: 6),
                                    Icon(Icons.error_rounded, size: 14, color: isDark ? AppColors.dangerDark : AppColors.dangerLight),
                                  ],
                                ],
                              ),
                              Text(m.phone, style: theme.textTheme.bodySmall),
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
