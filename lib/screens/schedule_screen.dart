import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../services/schedule_service.dart';
import '../services/course_service.dart';
import '../models/class_model.dart';
import '../models/exam_model.dart';
import '../models/course_model.dart';
import '../constants.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _auth = Get.find<AuthController>();
  Map<String, List<ClassModel>> _classes = {};
  List<ExamModel> _exams = [];
  List<CourseModel> _courses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final sid = _auth.studentId;
    final results = await Future.wait([
      ScheduleService.getClasses(sid),
      ScheduleService.getExams(sid),
      CourseService.getAll(),
    ]);
    setState(() {
      _classes = results[0] as Map<String, List<ClassModel>>;
      _exams = results[1] as List<ExamModel>;
      _courses = results[2] as List<CourseModel>;
      _loading = false;
    });
  }

  void _showAddClass() {
    CourseModel? selectedCourse;
    String selectedDay = AppConstants.days.first;
    final startCtrl = TextEditingController(text: '08:00');
    final endCtrl = TextEditingController(text: '10:00');
    final roomCtrl = TextEditingController();
    final lecturerCtrl = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: const BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusL),
          ),
        ),
        child: StatefulBuilder(
          builder: (ctx, set) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Class',
                        style: AppConstants.subheadingStyle,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppConstants.textSecondary,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CourseModel>(
                    value: selectedCourse,
                    hint: const Text(
                      'Select course',
                      style: TextStyle(color: AppConstants.textSecondary),
                    ),
                    decoration: const InputDecoration(labelText: 'Course'),
                    dropdownColor: AppConstants.surfaceColor,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    items: _courses
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c.display,
                              style: const TextStyle(
                                color: AppConstants.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => set(() => selectedCourse = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedDay,
                    decoration: const InputDecoration(labelText: 'Day'),
                    dropdownColor: AppConstants.surfaceColor,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    items: AppConstants.days
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) => set(() => selectedDay = v!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startCtrl,
                          style: const TextStyle(
                            color: AppConstants.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Start time',
                            hintText: '08:00',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: endCtrl,
                          style: const TextStyle(
                            color: AppConstants.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'End time',
                            hintText: '10:00',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: roomCtrl,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Room (optional)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: lecturerCtrl,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Lecturer (optional)',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (selectedCourse == null) return;
                        final ok = await ScheduleService.addClass({
                          'student_id': _auth.studentId,
                          'course_id': selectedCourse!.id,
                          'day': selectedDay,
                          'start_time': startCtrl.text,
                          'end_time': endCtrl.text,
                          'room': roomCtrl.text,
                          'lecturer': lecturerCtrl.text,
                        });
                        if (ok) {
                          Get.back();
                          _load();
                        }
                      },
                      child: const Text(
                        'Add Class',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(ctx).viewInsets.bottom),
                ],
              ),
            );
          },
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAddExam() {
    CourseModel? selectedCourse;
    String selectedTerm = AppConstants.terms.first;
    final dateCtrl = TextEditingController();
    final startCtrl = TextEditingController(text: '09:00');
    final endCtrl = TextEditingController(text: '12:00');
    final venueCtrl = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: const BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusL),
          ),
        ),
        child: StatefulBuilder(
          builder: (ctx, set) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Exam',
                        style: AppConstants.subheadingStyle,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppConstants.textSecondary,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CourseModel>(
                    value: selectedCourse,
                    hint: const Text(
                      'Select course',
                      style: TextStyle(color: AppConstants.textSecondary),
                    ),
                    decoration: const InputDecoration(labelText: 'Course'),
                    dropdownColor: AppConstants.surfaceColor,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    items: _courses
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c.display,
                              style: const TextStyle(
                                color: AppConstants.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => set(() => selectedCourse = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedTerm,
                    decoration: const InputDecoration(labelText: 'Term'),
                    dropdownColor: AppConstants.surfaceColor,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    items: AppConstants.terms
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => set(() => selectedTerm = v!),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dateCtrl,
                    readOnly: true,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Exam date',
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: AppConstants.primaryColor,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        set(
                          () => dateCtrl.text = DateFormat(
                            'yyyy-MM-dd',
                          ).format(picked),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startCtrl,
                          style: const TextStyle(
                            color: AppConstants.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Start time',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: endCtrl,
                          style: const TextStyle(
                            color: AppConstants.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'End time',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: venueCtrl,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    decoration: const InputDecoration(labelText: 'Venue'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (selectedCourse == null || dateCtrl.text.isEmpty)
                          return;
                        final ok = await ScheduleService.addExam({
                          'student_id': _auth.studentId,
                          'course_id': selectedCourse!.id,
                          'exam_date': dateCtrl.text,
                          'start_time': startCtrl.text,
                          'end_time': endCtrl.text,
                          'venue': venueCtrl.text,
                          'term': selectedTerm,
                        });
                        if (ok) {
                          Get.back();
                          _load();
                        }
                      },
                      child: const Text(
                        'Add Exam',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(ctx).viewInsets.bottom),
                ],
              ),
            );
          },
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Classes'),
            Tab(text: 'Exams'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.primaryColor,
        onPressed: () => _tab.index == 0 ? _showAddClass() : _showAddExam(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryColor,
              ),
            )
          : TabBarView(
              controller: _tab,
              children: [
                _ClassesTab(
                  classes: _classes,
                  onDelete: (id) async {
                    await ScheduleService.deleteClass(id, _auth.studentId);
                    _load();
                  },
                ),
                _ExamsTab(
                  exams: _exams,
                  onDelete: (id) async {
                    await ScheduleService.deleteExam(id, _auth.studentId);
                    _load();
                  },
                ),
              ],
            ),
    );
  }
}

class _ClassesTab extends StatelessWidget {
  final Map<String, List<ClassModel>> classes;
  final Function(int) onDelete;
  const _ClassesTab({required this.classes, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.class_outlined,
              size: 56,
              color: AppConstants.textSecondary,
            ),
            SizedBox(height: 12),
            Text('No classes added yet', style: AppConstants.bodyStyle),
            SizedBox(height: 4),
            Text(
              'Tap + to add your first class',
              style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      children: AppConstants.days
          .where((d) => classes.containsKey(d))
          .map(
            (day) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    day,
                    style: const TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                ...classes[day]!.map(
                  (c) => Dismissible(
                    key: Key(c.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: AppConstants.errorColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppConstants.errorColor,
                      ),
                    ),
                    onDismissed: (_) => onDelete(c.id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppConstants.cardColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                        border: Border.all(color: AppConstants.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor.withOpacity(
                                0.12,
                              ),
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
                                  '${c.startTime} – ${c.endTime}'
                                  '${c.room.isNotEmpty ? "  ·  ${c.room}" : ""}'
                                  '${c.lecturer.isNotEmpty ? "  ·  ${c.lecturer}" : ""}',
                                  style: AppConstants.bodyStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _ExamsTab extends StatelessWidget {
  final List<ExamModel> exams;
  final Function(int) onDelete;
  const _ExamsTab({required this.exams, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 56,
              color: AppConstants.textSecondary,
            ),
            SizedBox(height: 12),
            Text('No exams added yet', style: AppConstants.bodyStyle),
            SizedBox(height: 4),
            Text(
              'Tap + to add an exam',
              style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      children: exams.map((e) {
        final days = e.daysUntil;
        final urgency = days <= 3
            ? AppConstants.errorColor
            : days <= 7
            ? const Color(0xFFFFD740)
            : AppConstants.successColor;
        return Dismissible(
          key: Key(e.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppConstants.errorColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: AppConstants.errorColor,
            ),
          ),
          onDismissed: (_) => onDelete(e.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
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
                  child: Icon(
                    Icons.assignment_rounded,
                    color: urgency,
                    size: 20,
                  ),
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
                        '${e.examDate}  ·  ${e.startTime} – ${e.endTime}'
                        '${e.venue.isNotEmpty ? "  ·  ${e.venue}" : ""}',
                        style: AppConstants.bodyStyle,
                      ),
                      Text(
                        e.term,
                        style: AppConstants.bodyStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
          ),
        );
      }).toList(),
    );
  }
}
