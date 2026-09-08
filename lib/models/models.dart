import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum UserRole { murabbi, parkAdmin, cityMasul }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.murabbi => 'Murabbi',
        UserRole.parkAdmin => 'Park Admin',
        UserRole.cityMasul => 'City / IT Masul',
      };

  Color get color => switch (this) {
        UserRole.murabbi => AppColors.roleMurabbi,
        UserRole.parkAdmin => AppColors.roleParkAdmin,
        UserRole.cityMasul => AppColors.roleCityMasul,
      };
}

/// A logged-in account. A Park Admin can also be a Murabbi of their own
/// group ([ownGroupId] set), matching the real-world flow.
class AppUser {
  final String id;
  final String name;
  final String phone;
  final UserRole role;
  final String parkId;
  final String? ownGroupId; // group this person personally teaches, if any

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.parkId,
    this.ownGroupId,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}

class ParkInfo {
  final String id;
  final String name;
  final String headMurabbiName;
  final List<String> parkAdminNames;
  final List<String> groupIds;

  const ParkInfo({
    required this.id,
    required this.name,
    required this.headMurabbiName,
    required this.parkAdminNames,
    required this.groupIds,
  });
}

class GroupInfo {
  final String id;
  final String name; // "Group A"
  final String parkId;
  final String murabbiName;
  final String murabbiId;

  const GroupInfo({
    required this.id,
    required this.name,
    required this.parkId,
    required this.murabbiName,
    required this.murabbiId,
  });
}

class ShababMember {
  final String id;
  final String name;
  final String groupId;
  final String phone;
  final String fatherName;
  final String cnic;
  final String address;
  final String dob;
  int consecutiveAbsences;

  ShababMember({
    required this.id,
    required this.name,
    required this.groupId,
    required this.phone,
    this.fatherName = '',
    this.cnic = '',
    this.address = '',
    this.dob = '',
    this.consecutiveAbsences = 0,
  });
}

enum AttendanceStatus { present, absent, late, leave }

extension AttendanceStatusX on AttendanceStatus {
  String get shortLabel => switch (this) {
        AttendanceStatus.present => 'P',
        AttendanceStatus.absent => 'A',
        AttendanceStatus.late => 'L',
        AttendanceStatus.leave => 'Le',
      };

  String get label => switch (this) {
        AttendanceStatus.present => 'Present',
        AttendanceStatus.absent => 'Absent',
        AttendanceStatus.late => 'Late',
        AttendanceStatus.leave => 'Leave',
      };

  Color color(bool isDark) => switch (this) {
        AttendanceStatus.present => isDark ? AppColors.successDark : AppColors.successLight,
        AttendanceStatus.absent => isDark ? AppColors.dangerDark : AppColors.dangerLight,
        AttendanceStatus.late => isDark ? AppColors.warningDark : AppColors.warningLight,
        AttendanceStatus.leave => isDark ? AppColors.infoDark : AppColors.infoLight,
      };
}
