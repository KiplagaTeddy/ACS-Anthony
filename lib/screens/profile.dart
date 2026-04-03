import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Obx(() {
        final user = auth.user.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Avatar
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppConstants.primaryColor,
                        AppConstants.secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(user?.name ?? '', style: AppConstants.subheadingStyle),
              const SizedBox(height: 4),
              Text(user?.email ?? '', style: AppConstants.bodyStyle),
              const SizedBox(height: 28),

              // Info card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  border: Border.all(color: AppConstants.dividerColor),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      Icons.badge_outlined,
                      'Reg Number',
                      user?.regNumber ?? '-',
                    ),
                    const Divider(
                      height: 1,
                      color: AppConstants.dividerColor,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _InfoRow(
                      Icons.school_outlined,
                      'Department',
                      user?.department ?? '-',
                    ),
                    const Divider(
                      height: 1,
                      color: AppConstants.dividerColor,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _InfoRow(
                      Icons.calendar_month_outlined,
                      'Year of Study',
                      user?.yearOfStudy ?? '-',
                    ),
                    const Divider(
                      height: 1,
                      color: AppConstants.dividerColor,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _InfoRow(Icons.phone_outlined, 'Phone', user?.phone ?? '-'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppConstants.primaryColor,
                  ),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppConstants.primaryColor,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                  ),
                  onPressed: () => auth.logout(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppConstants.primaryColor),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: AppConstants.bodyStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.textPrimary,
          ),
        ),
      ],
    ),
  );
}
