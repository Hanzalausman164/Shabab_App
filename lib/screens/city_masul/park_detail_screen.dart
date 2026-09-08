import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_utils.dart';
import '../../widgets/common_widgets.dart';

class ParkDetailScreen extends StatelessWidget {
  final String parkId;
  const ParkDetailScreen({super.key, required this.parkId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final isDark = appState.isDark;
    final park = MockData.parkById(parkId);
    final groups = MockData.groupsForPark(parkId);
    final today = AppDate.todayKey();

    final totalMembers = groups.fold<int>(0, (a, g) => a + MockData.membersForGroup(g.id).length);
    final presentMembers = groups.fold<int>(0, (a, g) => a + appState.presentCount(g.id, today));
    final murabbeenStatuses = appState.murabbeenAttendanceFor(parkId, today);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(title: park.name, subtitle: AppDate.longToday()),
              Expanded(
                child: ListView(
                  children: [
                    AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat(theme, 'Present', '$presentMembers', isDark ? AppColors.successDark : AppColors.successLight),
                          _stat(theme, 'Total Shabab', '$totalMembers', theme.textTheme.titleLarge?.color ?? Colors.white),
                          _stat(theme, 'Groups', '${groups.length}', isDark ? AppColors.infoDark : AppColors.infoLight),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    // ---- MANAGEMENT: head murabbis, murabbis ----
                    _SectionLabel(
                      icon: Icons.shield_rounded,
                      label: 'PARK MANAGEMENT',
                      color: isDark ? AppColors.warningDark : AppColors.warningLight,
                    ),
                    const SizedBox(height: 10),
                    _managementRow(context, theme, isDark, 'Head Murabbi', park.headMurabbiName, murabbeenStatuses['head_$parkId']),
                    ...park.headMurabbiNames.asMap().entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: _managementRow(
                              context,
                              theme,
                              isDark,
                              'Head Murabbi',
                              e.value,
                              murabbeenStatuses['admin_${parkId}_${e.key}'],
                            ),
                          ),
                        ),
                    ...groups.map(
                      (g) => Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _managementRow(context, theme, isDark, 'Murabbi · ${g.name}', g.murabbiName, murabbeenStatuses[g.murabbiId]),
                      ),
                    ),
                    const SizedBox(height: 26),
                    // ---- SHABAB ATTENDANCE ----
                    _SectionLabel(
                      icon: Icons.groups_rounded,
                      label: 'SHABAB ATTENDANCE',
                      color: AppColors.roleCityMasul,
                    ),
                    const SizedBox(height: 10),
                    ...groups.expand((g) {
                      final members = MockData.membersForGroup(g.id);
                      final statuses = appState.attendanceFor(g.id, today);
                      return members.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AppCard(
                            child: Row(
                              children: [
                                MemberAvatar(name: m.name, radius: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(m.name, style: theme.textTheme.titleMedium),
                                      Text(g.name, style: theme.textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                _statusPill(theme, isDark, statuses[m.id]),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _managementRow(BuildContext context, ThemeData theme, bool isDark, String role, String name, AttendanceStatus? status) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          MemberAvatar(name: name, radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleMedium),
                Text(role, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          _statusPill(theme, isDark, status),
        ],
      ),
    );
  }

  Widget _statusPill(ThemeData theme, bool isDark, AttendanceStatus? status) {
    if (status == null) {
      final color = isDark ? AppColors.darkMuted : AppColors.lightMuted;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
        child: Text('—', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
      );
    }
    final color = status.color(isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
      child: Text(status.label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
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

/// Small colored eyebrow label used to visually separate Management from
/// Shabab attendance — this distinction was explicitly requested so the two
/// groups are never confused with each other.
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionLabel({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12.5, letterSpacing: 0.6),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: color.withValues(alpha: 0.25))),
      ],
    );
  }
}
