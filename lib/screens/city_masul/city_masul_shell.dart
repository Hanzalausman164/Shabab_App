import 'package:flutter/material.dart';
import 'city_masul_home_screen.dart';
import 'park_wise_attendance_screen.dart';
import 'report_screen.dart';
import '../shared/profile_settings_screen.dart';

class CityMasulShell extends StatefulWidget {
  const CityMasulShell({super.key});

  @override
  State<CityMasulShell> createState() => _CityMasulShellState();
}

class _CityMasulShellState extends State<CityMasulShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      CityMasulHomeScreen(onNavigate: _go),
      const ParkWiseAttendanceScreen(),
      const CityMasulReportScreen(),
      const ProfileSettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _go,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.park_rounded), label: 'Parks'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}
