import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common_widgets.dart';
import 'login_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.currentUser!;
    final theme = Theme.of(context);
    final isDark = appState.isDark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text('Profile & Settings', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 20),
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: user.role.color.withValues(alpha: 0.18),
                    child: Text(
                      user.initials,
                      style: TextStyle(color: user.role.color, fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(user.phone, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        RoleBadge(role: user.role),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionTitle(title: 'Appearance'),
            AppCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dark Mode', style: theme.textTheme.titleMedium),
                        Text(isDark ? 'Currently on' : 'Currently off', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Switch(value: isDark, onChanged: (_) => appState.toggleTheme()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionTitle(title: 'Account'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _tile(context, Icons.person_outline_rounded, 'Edit Profile'),
                  Divider(height: 1, color: theme.dividerColor),
                  _tile(context, Icons.notifications_none_rounded, 'Notifications'),
                  Divider(height: 1, color: theme.dividerColor),
                  _tile(context, Icons.help_outline_rounded, 'Help & Support'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                context.read<AppState>().logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout_rounded, color: isDark ? AppColors.dangerDark : AppColors.dangerLight),
              label: Text('Log Out', style: TextStyle(color: isDark ? AppColors.dangerDark : AppColors.dangerLight)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: isDark ? AppColors.dangerDark : AppColors.dangerLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () {},
      leading: Icon(icon, size: 20),
      title: Text(label, style: theme.textTheme.titleMedium),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
