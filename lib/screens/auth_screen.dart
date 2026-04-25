import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../constants.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _obscure = true;
  final _formKey = GlobalKey<FormState>();
  final _auth = Get.find<AuthController>();
  late TabController _tab;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _regNumber = TextEditingController();
  final _phone = TextEditingController();
  String _department = 'Computer Science';
  String _yearOfStudy = 'Year 1';

  final _departments = [
    'Computer Science',
    'Information Technology',
    'Business Administration',
    'Engineering',
    'Medicine',
    'Law',
    'Education',
    'Commerce',
  ];
  final _years = ['Year 1', 'Year 2', 'Year 3', 'Year 4'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() => _isLogin = _tab.index == 0));
  }

  @override
  void dispose() {
    _tab.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _regNumber.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    bool success;
    if (_isLogin) {
      success = await _auth.login(_email.text.trim(), _password.text.trim());
    } else {
      success = await _auth.register({
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'password': _password.text.trim(),
        'reg_number': _regNumber.text.trim(),
        'department': _department,
        'year_of_study': _yearOfStudy,
        'phone': _phone.text.trim(),
      });
    }
    if (success) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar(
        _isLogin ? 'Login Failed' : 'Sign Up Failed',
        _auth.errorMessage.value,
        backgroundColor: AppConstants.errorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ───────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppConstants.primaryColor,
                            AppConstants.secondaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryColor.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your student companion',
                      style: TextStyle(
                        color: AppConstants.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Tab bar ──────────────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppConstants.surfaceColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: TabBar(
                  controller: _tab,
                  indicator: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppConstants.textSecondary,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Sign In'),
                    Tab(text: 'Sign Up'),
                  ],
                ),
              ),

              // ── Form ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (!_isLogin) ...[
                        CustomTextField(
                          label: 'Full Name',
                          controller: _name,
                          prefixIcon: Icons.person_outline,
                          validator: (v) =>
                              v!.isEmpty ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 14),
                      ],

                      CustomTextField(
                        label: 'Email Address',
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (v) {
                          if (v!.isEmpty) return 'Email is required';
                          if (!v.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      CustomTextField(
                        label: 'Password',
                        controller: _password,
                        obscureText: _obscure,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppConstants.textSecondary,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        validator: (v) =>
                            v!.length < 6 ? 'At least 6 characters' : null,
                      ),

                      if (!_isLogin) ...[
                        const SizedBox(height: 14),
                        CustomTextField(
                          label: 'Registration Number',
                          controller: _regNumber,
                          prefixIcon: Icons.badge_outlined,
                          hint: 'e.g. CS/001/2024',
                          validator: (v) =>
                              v!.isEmpty ? 'Reg number required' : null,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          label: 'Phone Number',
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: _department,
                          decoration: const InputDecoration(
                            labelText: 'Department',
                            prefixIcon: Icon(Icons.school_outlined),
                          ),
                          dropdownColor: AppConstants.surfaceColor,
                          style: const TextStyle(
                            color: AppConstants.textPrimary,
                          ),
                          items: _departments
                              .map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _department = v!),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: _yearOfStudy,
                          decoration: const InputDecoration(
                            labelText: 'Year of Study',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          dropdownColor: AppConstants.surfaceColor,
                          style: const TextStyle(
                            color: AppConstants.textPrimary,
                          ),
                          items: _years
                              .map(
                                (y) =>
                                    DropdownMenuItem(value: y, child: Text(y)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _yearOfStudy = v!),
                        ),
                      ],

                      const SizedBox(height: 28),
                      Obx(
                        () => CustomButton(
                          label: _isLogin ? 'Sign In' : 'Create Account',
                          onPressed: _submit,
                          isLoading: _auth.isLoading.value,
                          icon: _isLogin
                              ? Icons.login_rounded
                              : Icons.person_add_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
