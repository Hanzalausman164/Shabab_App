import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';

/// Single source of truth for the whole app: theme mode, who is logged in,
/// and all attendance marking. Kept as one ChangeNotifier so every screen
/// can just call `context.watch<AppState>()` / `context.read<AppState>()`.
class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  String? _loginError;
  String? get loginError => _loginError;

  bool login(String phone) {
    final user = MockData.findUser(phone);
    if (user == null) {
      _loginError = 'No account found for this number. Try the demo numbers below.';
      notifyListeners();
      return false;
    }
    _currentUser = user;
    _loginError = null;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // ---------------- Attendance state ----------------
  // key: "groupId|yyyy-mm-dd" -> { memberId: status }
  final Map<String, Map<String, AttendanceStatus>> _attendanceByGroupDate = {};

  String _key(String groupId, String date) => '$groupId|$date';

  bool isGroupMarked(String groupId, String date) => _attendanceByGroupDate.containsKey(_key(groupId, date));

  Map<String, AttendanceStatus> attendanceFor(String groupId, String date) =>
      _attendanceByGroupDate[_key(groupId, date)] ?? {};

  void markGroupAttendance(String groupId, String date, Map<String, AttendanceStatus> statuses) {
    _attendanceByGroupDate[_key(groupId, date)] = Map.of(statuses);
    notifyListeners();
  }

  /// Whether every group (and, loosely, management) in a park has marked
  /// attendance for [date]. Used to drive the "Marked / Not Marked" badges
  /// on the Park-Wise Attendance list shown to City/IT Masul.
  bool isParkMarked(String parkId, String date) {
    final groupIds = MockData.groupsForPark(parkId).map((g) => g.id);
    if (groupIds.isEmpty) return false;
    return groupIds.every((id) => isGroupMarked(id, date));
  }

  int presentCount(String groupId, String date) =>
      attendanceFor(groupId, date).values.where((s) => s == AttendanceStatus.present).length;

  int totalMembers(String groupId) => MockData.membersForGroup(groupId).length;

  // ---------------- Murabbeen attendance (Head Murabbi marking murabbis) ----------------
  final Map<String, Map<String, AttendanceStatus>> _murabbeenAttendance = {};

  String _murabbeenKey(String parkId, String date) => 'murabbeen|$parkId|$date';

  bool isMurabbeenMarked(String parkId, String date) => _murabbeenAttendance.containsKey(_murabbeenKey(parkId, date));

  Map<String, AttendanceStatus> murabbeenAttendanceFor(String parkId, String date) =>
      _murabbeenAttendance[_murabbeenKey(parkId, date)] ?? {};

  void markMurabbeenAttendance(String parkId, String date, Map<String, AttendanceStatus> statuses) {
    _murabbeenAttendance[_murabbeenKey(parkId, date)] = Map.of(statuses);
    notifyListeners();
  }
}
