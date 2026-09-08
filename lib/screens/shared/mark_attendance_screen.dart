import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common_widgets.dart';

class AttendanceEntry {
  final String id;
  final String name;
  final String subtitle;
  final int warningAbsences;

  const AttendanceEntry({required this.id, required this.name, required this.subtitle, this.warningAbsences = 0});
}

/// Reusable "mark attendance" screen: a header, a scrollable list of people
/// each with a 4-way status selector, a live summary row, and a Save button.
/// Used for: Murabbi marking their own group, Head Murabbi marking their own
/// group, Head Murabbi marking Murabbeen, and Head Murabbi editing/opening an
/// unmarked group from the All Groups Status screen.
class MarkAttendanceScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String dateLabel;
  final List<AttendanceEntry> entries;
  final Map<String, AttendanceStatus> initialStatuses;
  final void Function(Map<String, AttendanceStatus> statuses) onSave;
  final bool isEditing;

  const MarkAttendanceScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.entries,
    required this.initialStatuses,
    required this.onSave,
    this.isEditing = false,
  });

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  late Map<String, AttendanceStatus> statuses;

  @override
  void initState() {
    super.initState();
    statuses = Map.of(widget.initialStatuses);
  }

  void _markAll(AttendanceStatus s) {
    setState(() {
      for (final e in widget.entries) {
        statuses[e.id] = s;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = widget.entries.length;
    final present = statuses.values.where((s) => s == AttendanceStatus.present).length;
    final absent = statuses.values.where((s) => s == AttendanceStatus.absent).length;
    final allMarked = widget.entries.every((e) => statuses.containsKey(e.id));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(title: widget.title, subtitle: widget.subtitle),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 15, color: theme.textTheme.bodyMedium?.color),
                  const SizedBox(width: 8),
                  Text('Selected Date: ${widget.dateLabel}', style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  TextButton(onPressed: () => _markAll(AttendanceStatus.present), child: const Text('Mark all Present')),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final e = widget.entries[i];
                    return AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              MemberAvatar(name: e.name),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.name, style: theme.textTheme.titleMedium),
                                    Text(e.subtitle, style: theme.textTheme.bodySmall),
                                  ],
                                ),
                              ),
                              if (e.warningAbsences >= 3)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (isDark ? AppColors.warningDark : AppColors.warningLight).withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${e.warningAbsences}rd Absence',
                                    style: TextStyle(
                                      color: isDark ? AppColors.warningDark : AppColors.warningLight,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AttendanceStatusSelector(
                            selected: statuses[e.id],
                            onChanged: (s) => setState(() => statuses[e.id] = s),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summary(theme, 'Present', '$present', isDark ? AppColors.successDark : AppColors.successLight),
                    _vDivider(theme),
                    _summary(theme, 'Absent', '$absent', isDark ? AppColors.dangerDark : AppColors.dangerLight),
                    _vDivider(theme),
                    _summary(theme, 'Total', '$total', theme.textTheme.titleLarge?.color ?? Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: allMarked
                    ? () {
                        widget.onSave(statuses);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(widget.isEditing ? 'Attendance updated' : 'Attendance saved')),
                        );
                      }
                    : null,
                child: Text(widget.isEditing ? 'Update Attendance' : 'Save Attendance'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vDivider(ThemeData theme) => Container(width: 1, height: 32, color: theme.dividerColor);

  Widget _summary(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}
