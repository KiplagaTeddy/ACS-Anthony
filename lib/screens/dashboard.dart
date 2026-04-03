import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../services/grade_service.dart';
import '../services/schedule_service.dart';
import '../models/class_model.dart';
import '../models/exam_model.dart';
import '../constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _auth = Get.find<AuthController>();
  double _gpa = 0.0;
  List<ClassModel> _todayClasses = [];
  List<ExamModel> _upcomingExams = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sid = _auth.studentId;
    final today = DateFormat('EEEE').format(DateTime.now());
    final grades = await GradeService.getAll(sid);
    final classes = await ScheduleService.getClasses(sid);
    final exams = await ScheduleService.getExams(sid);

    setState(() {
      _gpa = double.parse((grades['overall_gpa'] ?? 0.0).toString());
      _todayClasses = classes[today] ?? [];
      _upcomingExams = exams
          .where(
            (e) =>
                DateTime.tryParse(
                  e.examDate,
                )?.isAfter(DateTime.now().subtract(const Duration(days: 1))) ??
                false,
          )
          .take(3)
          .toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good morning'
        : now.hour < 17
        ? 'Good afternoon'
        : 'Good evening';

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              )
            : RefreshIndicator(
                color: AppConstants.primaryColor,
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── Greeting ────────────────────────────────
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$greeting,',
                                    style: AppConstants.bodyStyle,
                                  ),
                                  Text(
                                    _auth.user.value?.name.split(' ').first ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed('/profile'),
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppConstants.primaryColor,
                                      AppConstants.secondaryColor,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    (_auth.user.value?.name.isNotEmpty == true)
                                        ? _auth.user.value!.name[0]
                                              .toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Stats row ────────────────────────────────
                      Row(
                        children: [
                          _StatCard(
                            label: 'Current GPA',
                            value: _gpa.toStringAsFixed(2),
                            icon: Icons.grade_rounded,
                            color: AppConstants.primaryColor,
                            onTap: () => Get.toNamed('/grades'),
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            label: "Today's Classes",
                            value: _todayClasses.length.toString(),
                            icon: Icons.class_rounded,
                            color: const Color(0xFF40C4FF),
                            onTap: () => Get.toNamed('/schedule'),
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            label: 'Upcoming Exams',
                            value: _upcomingExams.length.toString(),
                            icon: Icons.assignment_rounded,
                            color: const Color(0xFFFFD740),
                            onTap: () => Get.toNamed('/schedule'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Today's classes ──────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Today's Classes",
                            style: AppConstants.subheadingStyle,
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed('/schedule'),
                            child: const Text(
                              'See all',
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (_todayClasses.isEmpty)
                        _EmptyCard(
                          icon: Icons.event_available_rounded,
                          message: 'No classes today',
                        )
                      else
                        ..._todayClasses.map((c) => _ClassTile(c)),

                      const SizedBox(height: 24),

                      // ── Upcoming exams ───────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upcoming Exams',
                            style: AppConstants.subheadingStyle,
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed('/schedule'),
                            child: const Text(
                              'See all',
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (_upcomingExams.isEmpty)
                        _EmptyCard(
                          icon: Icons.assignment_turned_in_rounded,
                          message: 'No upcoming exams',
                        )
                      else
                        ..._upcomingExams.map((e) => _ExamTile(e)),

                      const SizedBox(height: 16),

                      // ── Quick nav ────────────────────────────────
                      const Text(
                        'Quick Access',
                        style: AppConstants.subheadingStyle,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _QuickNav(
                            Icons.calendar_today_rounded,
                            'Schedule',
                            () => Get.toNamed('/schedule'),
                          ),
                          const SizedBox(width: 12),
                          _QuickNav(
                            Icons.bar_chart_rounded,
                            'Grades',
                            () => Get.toNamed('/grades'),
                          ),
                          const SizedBox(width: 12),
                          _QuickNav(
                            Icons.person_rounded,
                            'Profile',
                            () => Get.toNamed('/profile'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: AppConstants.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppConstants.bodyStyle.copyWith(fontSize: 11)),
          ],
        ),
      ),
    ),
  );
}

class _ClassTile extends StatelessWidget {
  final ClassModel c;
  const _ClassTile(this.c);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppConstants.cardColor,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      border: Border.all(color: AppConstants.dividerColor),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.class_rounded,
            color: AppConstants.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.courseName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${c.startTime} – ${c.endTime}  ·  ${c.room}',
                style: AppConstants.bodyStyle,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ExamTile extends StatelessWidget {
  final ExamModel e;
  const _ExamTile(this.e);

  @override
  Widget build(BuildContext context) {
    final days = e.daysUntil;
    final urgency = days <= 3
        ? AppConstants.errorColor
        : days <= 7
        ? const Color(0xFFFFD740)
        : AppConstants.successColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: urgency.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.assignment_rounded, color: urgency, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.courseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${e.examDate}  ·  ${e.venue}',
                  style: AppConstants.bodyStyle,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: urgency.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              days == 0
                  ? 'Today'
                  : days == 1
                  ? 'Tomorrow'
                  : '${days}d',
              style: TextStyle(
                color: urgency,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickNav extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickNav(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: AppConstants.dividerColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 26),
            const SizedBox(height: 6),
            Text(label, style: AppConstants.bodyStyle.copyWith(fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyCard({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppConstants.cardColor,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      border: Border.all(color: AppConstants.dividerColor),
    ),
    child: Column(
      children: [
        Icon(
          icon,
          size: 36,
          color: AppConstants.textSecondary.withOpacity(0.4),
        ),
        const SizedBox(height: 8),
        Text(message, style: AppConstants.bodyStyle),
      ],
    ),
  );
}
