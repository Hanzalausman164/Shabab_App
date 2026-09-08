import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../city_masul/city_masul_shell.dart';
import '../murabbi/murabbi_shell.dart';
import '../park_admin/park_admin_shell.dart';
import 'login_screen.dart';

class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;
    if (user == null) return const LoginScreen();
    return switch (user.role) {
      UserRole.murabbi => const MurabbiShell(),
      UserRole.headMurabbi => const HeadMurabbiShell(),
      UserRole.cityMasul => const CityMasulShell(),
    };
  }
}
