import 'package:flutter/material.dart';
import '../constants.dart';

class GradeModel {
  final int id;
  final int courseId;
  final String courseCode;
  final String courseName;
  final int credits;
  final double marks;
  final String letter;
  final double points;
  final String term;
  final String year;

  GradeModel({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.credits,
    required this.marks,
    required this.letter,
    required this.points,
    required this.term,
    required this.year,
  });

  factory GradeModel.fromJson(Map<String, dynamic> j) {
    final marks = double.parse(j['marks'].toString());
    final g = AppConstants.gradeFromMarks(marks);
    return GradeModel(
      id: int.parse(j['id'].toString()),
      courseId: int.parse(j['course_id'].toString()),
      courseCode: j['code'] ?? '',
      courseName: j['course_name'] ?? '',
      credits: int.parse(j['credits'].toString()),
      marks: marks,
      letter: j['letter'] ?? g['letter'],
      points: double.parse((j['points'] ?? g['points']).toString()),
      term: j['term'] ?? '',
      year: j['year'] ?? '',
    );
  }

  Color get color => AppConstants.gradeFromMarks(marks)['color'] as Color;
}
