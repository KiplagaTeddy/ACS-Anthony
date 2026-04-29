// filepath: lib/screens/term_progress_report.dart
import 'package:flutter/material.dart';
import '../models/grade_model.dart';
import '../constants.dart';

class TermProgressReport extends StatelessWidget {
  final List<GradeModel> grades;

  const TermProgressReport({super.key, required this.grades});

  // Group grades by "Term X YYYY" key
  Map<String, List<GradeModel>> get _gradesByTerm {
    final Map<String, List<GradeModel>> map = {};
    for (final g in grades) {
      final key = '${g.term} ${g.year}';
      map.putIfAbsent(key, () => []).add(g);
    }
    // Sort terms chronologically (year first, then term number)
    final sorted = map.entries.toList()
      ..sort((a, b) {
        final aParts = a.key.split(' ');
        final bParts = b.key.split(' ');
        final yearCmp = aParts.last.compareTo(bParts.last);
        if (yearCmp != 0) return yearCmp;
        return aParts.first.compareTo(bParts.first);
      });
    return Map.fromEntries(sorted);
  }

  double _termGpa(List<GradeModel> termGrades) {
    final totalPoints = termGrades.fold(
      0.0,
      (sum, g) => sum + g.points * g.credits,
    );
    final totalCredits = termGrades.fold(0, (sum, g) => sum + g.credits);
    return totalCredits == 0 ? 0 : totalPoints / totalCredits;
  }

  double _cgpa(String upToTerm) {
    final allTerms = _gradesByTerm.keys.toList();
    final idx = allTerms.indexOf(upToTerm);
    final relevantGrades = allTerms
        .sublist(0, idx + 1)
        .expand((t) => _gradesByTerm[t]!)
        .toList();
    return _termGpa(relevantGrades);
  }

  @override
  Widget build(BuildContext context) {
    final termMap = _gradesByTerm;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: termMap.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final termKey = termMap.keys.elementAt(index);
        final termGrades = termMap[termKey]!;
        return _TermCard(
          termKey: termKey,
          termGrades: termGrades,
          termGpa: _termGpa(termGrades),
          cgpa: _cgpa(termKey),
        );
      },
    );
  }
}

class _TermCard extends StatelessWidget {
  final String termKey;
  final List<GradeModel> termGrades;
  final double termGpa;
  final double cgpa;

  const _TermCard({
    required this.termKey,
    required this.termGrades,
    required this.termGpa,
    required this.cgpa,
  });

  int get totalCredits => termGrades.fold(0, (s, g) => s + g.credits);

  Map<String, int> get _letterCounts {
    final counts = {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'F': 0};
    for (final g in termGrades) {
      final key = g.letter.isNotEmpty ? g.letter[0].toUpperCase() : 'F';
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final counts = _letterCounts;
    final maxCount = counts.values.fold(0, (a, b) => a > b ? a : b);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        termKey,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${termGrades.length} courses',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                _GpaRing(gpa: termGpa),
              ],
            ),
          ),

          const Divider(height: 0, thickness: 0.5),

          // Stats row
          IntrinsicHeight(
            child: Row(
              children: [
                _StatCell(label: 'Term GPA', value: termGpa.toStringAsFixed(2)),
                VerticalDivider(
                  width: 0.5,
                  thickness: 0.5,
                  color: theme.dividerColor,
                ),
                _StatCell(label: 'CGPA', value: cgpa.toStringAsFixed(2)),
                VerticalDivider(
                  width: 0.5,
                  thickness: 0.5,
                  color: theme.dividerColor,
                ),
                _StatCell(
                  label: 'Credits',
                  value: '$totalCredits',
                  suffix: 'cr',
                ),
              ],
            ),
          ),

          const Divider(height: 0, thickness: 0.5),

          // Grade distribution
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grade distribution',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 72,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: counts.entries.map((e) {
                      return _DistBar(
                        letter: e.key,
                        count: e.value,
                        maxCount: maxCount == 0 ? 1 : maxCount,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 0, thickness: 0.5),

          // Course table header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _TableHeader('Code', flex: 2),
                _TableHeader('Course', flex: 5),
                _TableHeader('Marks', flex: 2, align: TextAlign.right),
                _TableHeader('Grade', flex: 2, align: TextAlign.center),
              ],
            ),
          ),

          // Course rows
          ...termGrades.map((g) => _CourseRow(grade: g)),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _GpaRing extends StatelessWidget {
  final double gpa;
  const _GpaRing({required this.gpa});

  @override
  Widget build(BuildContext context) {
    final pct = (gpa / 4.0).clamp(0.0, 1.0);
    final color = gpa >= 3.5
        ? Colors.green
        : gpa >= 2.5
        ? Colors.blue
        : gpa >= 1.5
        ? Colors.orange
        : Colors.red;
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: pct,
            strokeWidth: 3,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
          Text(
            gpa.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;

  const _StatCell({required this.label, required this.value, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: suffix != null
                    ? [
                        TextSpan(
                          text: ' $suffix',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DistBar extends StatelessWidget {
  final String letter;
  final int count;
  final int maxCount;

  const _DistBar({
    required this.letter,
    required this.count,
    required this.maxCount,
  });

  Color get _color {
    switch (letter) {
      case 'A':
        return const Color(0xFF639922);
      case 'B':
        return const Color(0xFF378ADD);
      case 'C':
        return const Color(0xFFEF9F27);
      case 'D':
        return const Color(0xFFD85A30);
      default:
        return const Color(0xFFE24B4A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final barHeight = count == 0 ? 4.0 : (count / maxCount) * 52.0;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: barHeight,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: count == 0 ? Theme.of(context).dividerColor : _color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            letter,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;

  const _TableHeader(this.text, {this.flex = 1, this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _CourseRow extends StatelessWidget {
  final GradeModel grade;
  const _CourseRow({required this.grade});

  Color get _pillBg {
    switch (grade.letter.isNotEmpty ? grade.letter[0] : 'F') {
      case 'A':
        return const Color(0xFFEAF3DE);
      case 'B':
        return const Color(0xFFE6F1FB);
      case 'C':
        return const Color(0xFFFAEEDA);
      default:
        return const Color(0xFFFCEBEB);
    }
  }

  Color get _pillText {
    switch (grade.letter.isNotEmpty ? grade.letter[0] : 'F') {
      case 'A':
        return const Color(0xFF27500A);
      case 'B':
        return const Color(0xFF0C447C);
      case 'C':
        return const Color(0xFF633806);
      default:
        return const Color(0xFF791F1F);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0, thickness: 0.5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  grade.courseCode,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  grade.courseName,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  grade.marks.toStringAsFixed(0),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _pillBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      grade.letter,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _pillText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
