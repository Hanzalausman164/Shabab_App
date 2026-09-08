import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _name = TextEditingController();
  final _father = TextEditingController();
  final _cnic = TextEditingController();
  final _dob = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    for (final c in [_name, _father, _cnic, _dob, _phone, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in at least name and phone number')),
      );
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_name.text} registered successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: kScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeader(title: 'Register Shabab', subtitle: 'Add a new member to your group'),
              LabeledField(label: 'Full Name', hint: 'Muhammad Ali', controller: _name, prefixIcon: Icons.person_outline_rounded),
              const SizedBox(height: 16),
              LabeledField(label: "Father's Name", hint: 'Usman Ali', controller: _father, prefixIcon: Icons.family_restroom_rounded),
              const SizedBox(height: 16),
              LabeledField(
                label: 'CNIC / B-Form Number',
                hint: '35202-1234567-1',
                controller: _cnic,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.badge_outlined,
              ),
              const SizedBox(height: 16),
              LabeledField(
                label: 'Date of Birth',
                hint: 'DD/MM/YYYY',
                controller: _dob,
                prefixIcon: Icons.cake_outlined,
                suffix: const Icon(Icons.calendar_today_rounded, size: 18),
              ),
              const SizedBox(height: 16),
              LabeledField(
                label: 'Phone Number',
                hint: '0300 1234567',
                controller: _phone,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_iphone_rounded,
              ),
              const SizedBox(height: 16),
              LabeledField(
                label: 'Address',
                hint: 'Street 4, Sector Y, Lahore',
                controller: _address,
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                    : const Text('Register Shabab'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
