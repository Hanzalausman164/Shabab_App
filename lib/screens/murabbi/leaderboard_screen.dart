import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common_widgets.dart';

class _RankedGroup {
  final String name;
  final String murabbiName;
  final int score;
  const _RankedGroup(this.name, this.murabbiName, this.score);
}

class MurabbiLeaderboardScreen extends StatefulWidget {
  const MurabbiLeaderboardScreen({super.key});

  @override
  State<MurabbiLeaderboardScreen> createState() => _MurabbiLeaderboardScreenState();
}

class _MurabbiLeaderboardScreenState extends State<MurabbiLeaderboardScreen> {
  int _period = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.watch<AppState>().isDark;

    final ranked = MockData.groups.map((g) {
      final seed = g.id.codeUnits.fold<int>(0, (a, b) => a + b) + _period * 5;
      return _RankedGroup(g.name, g.murabbiName, 70 + (seed % 30));
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    final medalColors = [const Color(0xFFF5B301), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)];

    return SafeArea(
      child: Padding(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            ScreenHeader(title: 'Murabbi Leaderboard', subtitle: 'Ranked by attendance consistency'),
            PeriodTabs(
              options: const ['This Week', 'This Month', 'Overall'],
              selectedIndex: _period,
              onChanged: (i) => setState(() => _period = i),
            ),
            const SizedBox(height: 18),
            if (ranked.length >= 3)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: _podium(theme, ranked[1], 2, medalColors[1], height: 96)),
                  const SizedBox(width: 10),
                  Expanded(child: _podium(theme, ranked[0], 1, medalColors[0], height: 118, crown: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _podium(theme, ranked[2], 3, medalColors[2], height: 80)),
                ],
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: ranked.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final r = ranked[i];
                  return AppCard(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text('${i + 1}', style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
                        ),
                        const SizedBox(width: 8),
                        MemberAvatar(name: r.murabbiName),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name, style: theme.textTheme.titleMedium),
                              Text(r.murabbiName, style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Text(
                          '${r.score}%',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isDark ? AppColors.successDark : AppColors.successLight,
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
    );
  }

  Widget _podium(ThemeData theme, _RankedGroup r, int rank, Color color, {required double height, bool crown = false}) {
    return Column(
      children: [
        if (crown) Icon(Icons.emoji_events_rounded, color: color, size: 26),
        const SizedBox(height: 6),
        MemberAvatar(name: r.murabbiName, radius: crown ? 26 : 20),
        const SizedBox(height: 6),
        Text(r.name, style: theme.textTheme.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
        Text('${r.score}%', style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 10),
          child: Text('#$rank', style: theme.textTheme.titleLarge?.copyWith(color: color)),
        ),
      ],
    );
  }
}
