import 'package:intl/intl.dart';

class AppDate {
  AppDate._();

  static String todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static String todayLabel() => 'Today, ${DateFormat('MMM d').format(DateTime.now())}';

  static String longToday() => DateFormat('MMMM d, yyyy').format(DateTime.now());
}
