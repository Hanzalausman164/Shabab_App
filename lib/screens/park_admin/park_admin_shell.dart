import 'package:flutter/material.dart';
import 'all_groups_status_screen.dart';
import 'park_admin_home_screen.dart';
import 'park_report_screen.dart';
import '../shared/profile_settings_screen.dart';

class ParkAdminShell extends StatefulWidget {
  const ParkAdminShell({super.key});

  @override
  State<ParkAdminShell> createState() => _ParkAdminShellState();
}

class _ParkAdminShellState extends State<ParkAdminShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      ParkAdminHomeScreen(onNavigate: _go),
      const AllGroupsStatusScreen(),
      const ParkReportScreen(),
      const ProfileSettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _go,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_2_rounded), label: 'Murabbis'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}
