import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common_widgets.dart';

class CityMasulHomeScreen extends StatelessWidget {
  final void Function(int tabIndex) onNavigate;
  const CityMasulHomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser!;
    final theme = Theme.of(context);
    final isDark = appState.isDark;
    final today = AppDate.todayKey();
    final markedParks = MockData.parks.where((p) => appState.isParkMarked(p.id, today)).length;

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
                Expanded(
                  child: StatPill(
                    value: '${MockData.members.length}',
                    label: 'Registered Shabab',
                    icon: Icons.groups_rounded,
                    color: AppColors.roleCityMasul,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatPill(
                    value: '${MockData.parks.length}',
                    label: 'Total Parks',
                    icon: Icons.park_rounded,
                    color: isDark ? AppColors.infoDark : AppColors.infoLight,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatPill(
                    value: '$markedParks/${MockData.parks.length}',
                    label: "Marked Today",
                    icon: Icons.fact_check_rounded,
                    color: isDark ? AppColors.successDark : AppColors.successLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SectionTitle(title: 'Administrative Actions'),
            MenuActionCard(
              icon: Icons.map_rounded,
              title: 'View Park Wise Attendance',
              subtitle: 'Check real-time park status (Shabab + Murabbis)',
              color: AppColors.roleCityMasul,
              onTap: () => onNavigate(1),
            ),
            const SizedBox(height: 12),
            MenuActionCard(
              icon: Icons.bar_chart_rounded,
              title: 'View Attendance Report',
              subtitle: 'Weekly, monthly & all-time citywide stats',
              color: isDark ? AppColors.warningDark : AppColors.warningLight,
              onTap: () => onNavigate(2),
            ),
          ],
        ),
      ),
    );
  }
}
