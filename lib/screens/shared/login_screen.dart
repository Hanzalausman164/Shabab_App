import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import 'role_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscure = true;
  bool _rememberMe = true;
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final ok = context.read<AppState>().login(_phoneController.text);
    setState(() => _submitting = false);
    if (ok && mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const RoleRouter()));
    } else {
      setState(() {});
    }
  }

  void _fillDemo(String phone) {
    _phoneController.text = phone;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final error = context.watch<AppState>().loginError;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.brandGradientDiagonal(),
                  ),
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: Text('Welcome Back', style: theme.textTheme.headlineLarge)),
              const SizedBox(height: 6),
              Center(
                child: Text('Sign in to your Shabab account', style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(height: 32),
              Text('Phone Number', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '0300 1112223', prefixIcon: Icon(Icons.phone_iphone_rounded, size: 20)),
              ),
              const SizedBox(height: 18),
              Text('Password', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Row(
                      children: [
                        Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v ?? true)),
                        const SizedBox(width: 4),
                        Text('Remember me', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Forgot Password?')),
                ],
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.dangerDark : AppColors.dangerLight).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    error,
                    style: TextStyle(color: isDark ? AppColors.dangerDark : AppColors.dangerLight, fontSize: 12.5),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                      )
                    : const Text('Sign In'),
              ),
              const SizedBox(height: 28),
              Center(child: Text('DEMO ACCOUNTS — TAP TO FILL', style: theme.textTheme.labelSmall)),
              const SizedBox(height: 10),
              ...MockData.users.map(
                (u) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton(
                    onPressed: () => _fillDemo(u.phone),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${u.role.label} ', style: theme.textTheme.labelLarge),
                        Text('· ${u.phone}', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'REVOLUTIONARY YOUTH TRAINING PROGRAM',
                  style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
