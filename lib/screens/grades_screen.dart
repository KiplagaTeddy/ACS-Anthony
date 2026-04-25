import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/auth_controller.dart';
import '../services/grade_service.dart';
import '../services/course_service.dart';
import '../models/grade_model.dart';
import '../models/course_model.dart';
import '../constants.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});
  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _auth = Get.find<AuthController>();
  List<GradeModel> _grades = [];
  List<CourseModel> _courses = [];
  double _overallGpa = 0.0;
  int _totalCredits = 0;
  Map<String, dynamic> _termGpas = {};
  bool _loading = true;
  String _selectedTerm = 'Term 1';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() {
      if (!_tab.indexIsChanging) {
        setState(() => _selectedTerm = AppConstants.terms[_tab.index]);
      }
    });
    _load();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final gradeData = await GradeService.getAll(_auth.studentId);
    final courses = await CourseService.getAll();
    setState(() {
      // ✅ Fixed: use List.from() instead of direct cast
      _grades = List<GradeModel>.from(gradeData['grades']);

      _overallGpa = double.parse((gradeData['overall_gpa'] ?? 0).toString());
      _totalCredits = int.parse((gradeData['total_credits'] ?? 0).toString());

      // ✅ Fixed: use Map.from() instead of direct cast
      _termGpas = Map<String, dynamic>.from(gradeData['term_gpas'] ?? {});

      _courses = courses;
      _loading = false;
    });
  }

  List<GradeModel> _gradesForTerm(String term) =>
      _grades.where((g) => g.term == term).toList();

  double _gpaForTerm(String term) {
    final key = _termGpas.keys.firstWhere(
      (k) => k.startsWith(term),
      orElse: () => '',
    );
    if (key.isEmpty) return 0.0;
    return double.parse(_termGpas[key].toString());
  }

  void _showAddGrade() {
    CourseModel? selectedCourse;
    String selectedTerm = _selectedTerm;
    final marksCtrl = TextEditingController();
    final yearCtrl = TextEditingController(
      text: DateTime.now().year.toString(),
    );

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
            double? preview;
            if (marksCtrl.text.isNotEmpty) {
              final m = double.tryParse(marksCtrl.text);
              if (m != null) {
                preview = AppConstants.gradeFromMarks(m)['points'];
              }
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Grade',
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
                    initialValue: selectedCourse,
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
                    initialValue: selectedTerm,
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
                    controller: yearCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Year (e.g. 2024)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: marksCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppConstants.textPrimary),
                    onChanged: (_) => set(() {}),
                    decoration: InputDecoration(
                      labelText: 'Marks (0 – 100)',
                      suffixText:
                          marksCtrl.text.isNotEmpty &&
                              double.tryParse(marksCtrl.text) != null
                          ? AppConstants.gradeFromMarks(
                                  double.parse(marksCtrl.text),
                                )['letter']
                                as String
                          : null,
                      suffixStyle: const TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (preview != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Grade points: $preview / 4.0',
                      style: const TextStyle(
                        color: AppConstants.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
                        if (selectedCourse == null ||
                            marksCtrl.text.isEmpty ||
                            yearCtrl.text.isEmpty) {
                          return;
                        }
                        final ok = await GradeService.save({
                          'student_id': _auth.studentId,
                          'course_id': selectedCourse!.id,
                          'marks': double.parse(marksCtrl.text),
                          'term': selectedTerm,
                          'year': yearCtrl.text,
                        });
                        if (ok) {
                          Get.back();
                          _load();
                        }
                      },
                      child: const Text(
                        'Save Grade',
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
        title: const Text('Grades & Progress'),
        bottom: TabBar(
          controller: _tab,
          tabs: AppConstants.terms.map((t) => Tab(text: t)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.primaryColor,
        onPressed: _showAddGrade,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryColor,
              ),
            )
          : Column(
              children: [
                // ── Overall GPA banner ───────────────────────────
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(AppConstants.paddingM),
                  padding: const EdgeInsets.all(AppConstants.paddingL),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppConstants.primaryColor,
                        AppConstants.secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _GpaStat(
                        label: 'Overall GPA',
                        value: _overallGpa.toStringAsFixed(2),
                        big: true,
                      ),
                      Container(width: 1, height: 40, color: Colors.white24),
                      _GpaStat(
                        label: 'Credits',
                        value: _totalCredits.toString(),
                      ),
                      Container(width: 1, height: 40, color: Colors.white24),
                      _GpaStat(
                        label: 'Units',
                        value: _grades.length.toString(),
                      ),
                    ],
                  ),
                ),

                // ── Term tabs ────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tab,
                    children: AppConstants.terms.map((term) {
                      final termGrades = _gradesForTerm(term);
                      final termGpa = _gpaForTerm(term);
                      return _TermView(
                        term: term,
                        grades: termGrades,
                        termGpa: termGpa,
                        onDelete: (id) async {
                          await GradeService.delete(id, _auth.studentId);
                          _load();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _GpaStat extends StatelessWidget {
  final String label, value;
  final bool big;
  const _GpaStat({required this.label, required this.value, this.big = false});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          color: Colors.white,
          fontSize: big ? 32 : 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: TextStyle(color: Colors.white70, fontSize: big ? 12 : 11),
      ),
    ],
  );
}

class _TermView extends StatelessWidget {
  final String term;
  final List<GradeModel> grades;
  final double termGpa;
  final Function(int) onDelete;

  const _TermView({
    required this.term,
    required this.grades,
    required this.termGpa,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (grades.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.grade_outlined,
              size: 56,
              color: AppConstants.textSecondary,
            ),
            SizedBox(height: 12),
            Text('No grades for this term', style: AppConstants.bodyStyle),
            SizedBox(height: 4),
            Text(
              'Tap + to add a grade',
              style: TextStyle(color: AppConstants.textSecondary, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Term GPA chip ──────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$term Results', style: AppConstants.subheadingStyle),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.primaryColor.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  'GPA: ${termGpa.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Bar chart ──────────────────────────────────────────
          if (grades.isNotEmpty) ...[
            Container(
              height: 180,
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
              decoration: BoxDecoration(
                color: AppConstants.cardColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(color: AppConstants.dividerColor),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  minY: 0,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppConstants.surfaceColor,
                      getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                        '${grades[group.x].courseCode}\n'
                        '${rod.toY.toInt()}%',
                        const TextStyle(
                          color: AppConstants.textPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            grades[v.toInt()].courseCode.split(' ').first,
                            style: const TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 25,
                        getTitlesWidget: (v, _) => Text(
                          v.toInt().toString(),
                          style: const TextStyle(
                            color: AppConstants.textSecondary,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: AppConstants.dividerColor,
                      strokeWidth: 0.5,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: grades.asMap().entries.map((e) {
                    final g = e.value;
                    final color = g.color;
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: g.marks,
                          color: color,
                          width: 22,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 100,
                            color: AppConstants.dividerColor,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Best & worst ───────────────────────────────────────
          if (grades.length >= 2) ...[
            Row(
              children: [
                _HighlightCard(
                  label: 'Best Unit',
                  grade: grades.reduce((a, b) => a.marks > b.marks ? a : b),
                  icon: Icons.trending_up_rounded,
                ),
                const SizedBox(width: 12),
                _HighlightCard(
                  label: 'Needs Work',
                  grade: grades.reduce((a, b) => a.marks < b.marks ? a : b),
                  icon: Icons.trending_down_rounded,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // ── Grade cards ────────────────────────────────────────
          const Text('Unit Breakdown', style: AppConstants.subheadingStyle),
          const SizedBox(height: 12),

          ...grades.asMap().entries.map((entry) {
            final g = entry.value;
            return Dismissible(
              key: Key('${entry.value.id}_${entry.value.term}_${entry.key}'),
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
              onDismissed: (_) => onDelete(g.id),
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
                    // Grade letter badge
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: g.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          g.letter,
                          style: TextStyle(
                            color: g.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Course info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.courseName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${g.courseCode}  ·  ${g.credits} credits',
                            style: AppConstants.bodyStyle,
                          ),
                        ],
                      ),
                    ),
                    // Marks & points
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${g.marks.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: g.color,
                          ),
                        ),
                        Text(
                          '${g.points} pts',
                          style: AppConstants.bodyStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String label;
  final GradeModel grade;
  final IconData icon;
  const _HighlightCard({
    required this.label,
    required this.grade,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: grade.color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppConstants.bodyStyle.copyWith(fontSize: 11),
                ),
                Text(
                  grade.courseCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${grade.marks.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: grade.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
