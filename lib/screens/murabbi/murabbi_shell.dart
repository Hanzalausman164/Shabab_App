import 'package:flutter/material.dart';
import 'leaderboard_screen.dart';
import 'murabbi_home_screen.dart';
import 'report_screen.dart';
import '../shared/profile_settings_screen.dart';

class MurabbiShell extends StatefulWidget {
  const MurabbiShell({super.key});

  @override
  State<MurabbiShell> createState() => _MurabbiShellState();
}

class _MurabbiShellState extends State<MurabbiShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      MurabbiHomeScreen(onNavigate: _go),
      const MurabbiReportScreen(),
      const MurabbiLeaderboardScreen(),
      const ProfileSettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _go,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_rounded), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_rounded), label: 'Leaderboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
