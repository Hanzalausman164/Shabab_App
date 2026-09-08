import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common_widgets.dart';

int _pseudoPercent(String seed, int period) {
  final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b) + period * 7;
  return 55 + (hash % 42);
}

class CityMasulReportScreen extends StatefulWidget {
  const CityMasulReportScreen({super.key});

  @override
  State<CityMasulReportScreen> createState() => _CityMasulReportScreenState();
}

class _CityMasulReportScreenState extends State<CityMasulReportScreen> {
  int _period = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.watch<AppState>().isDark;
    final parks = MockData.parks;
    final avg = parks.isEmpty
        ? 0
        : (parks.map((p) => _pseudoPercent(p.id, _period)).reduce((a, b) => a + b) / parks.length).round();

    return SafeArea(
      child: Padding(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            Text('Attendance Report', style: theme.textTheme.headlineMedium),
            Text('Citywide overview · all parks', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            PeriodTabs(
              options: const ['This Week', 'This Month', 'All Time'],
              selectedIndex: _period,
              onChanged: (i) => setState(() => _period = i),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: StatPill(value: '${parks.length}', label: 'Parks', icon: Icons.park_rounded, color: AppColors.roleCityMasul)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: '${MockData.members.length}', label: 'Total Shabab', icon: Icons.groups_rounded, color: isDark ? AppColors.infoDark : AppColors.infoLight)),
                const SizedBox(width: 12),
                Expanded(child: StatPill(value: '$avg%', label: 'Avg Attendance', icon: Icons.trending_up_rounded, color: isDark ? AppColors.successDark : AppColors.successLight)),
              ],
            ),
            const SizedBox(height: 16),
            SectionTitle(title: 'By Park'),
            Expanded(
              child: ListView.separated(
                itemCount: parks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final p = parks[i];
                  final pct = _pseudoPercent(p.id, _period);
                  final color = pct >= 85
                      ? (isDark ? AppColors.successDark : AppColors.successLight)
                      : pct >= 70
                          ? (isDark ? AppColors.warningDark : AppColors.warningLight)
                          : (isDark ? AppColors.dangerDark : AppColors.dangerLight);
                  final groups = MockData.groupsForPark(p.id);
                  return AppCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.roleCityMasul.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.park_rounded, color: AppColors.roleCityMasul, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: theme.textTheme.titleMedium),
                              Text('${groups.length} groups · ${p.headMurabbiName}', style: theme.textTheme.bodySmall),
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
