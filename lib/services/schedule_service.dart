import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/class_model.dart';
import '../models/exam_model.dart';

class ScheduleService {
  // ── Classes ──────────────────────────────────────────────────────
  static Future<Map<String, List<ClassModel>>> getClasses(int studentId) async {
    try {
      final res = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}/schedule/classes.php?student_id=$studentId',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        final Map<String, List<ClassModel>> grouped = {};
        (data['data'] as Map<String, dynamic>).forEach((day, slots) {
          grouped[day] = (slots as List)
              .map((e) => ClassModel.fromJson(e))
              .toList();
        });
        return grouped;
      }
    } catch (_) {}
    return {};
  }

  static Future<bool> addClass(Map<String, dynamic> body) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConstants.baseUrl}/schedule/classes.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return jsonDecode(res.body)['status'] == 'success';
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteClass(int id, int studentId) async {
    try {
      final res = await http.delete(
        Uri.parse('${AppConstants.baseUrl}/schedule/classes.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'student_id': studentId}),
      );
      return jsonDecode(res.body)['status'] == 'success';
    } catch (_) {
      return false;
    }
  }

  // ── Exams ────────────────────────────────────────────────────────
  static Future<List<ExamModel>> getExams(int studentId) async {
    try {
      final res = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}/schedule/exams.php?student_id=$studentId',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => ExamModel.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<bool> addExam(Map<String, dynamic> body) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConstants.baseUrl}/schedule/exams.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return jsonDecode(res.body)['status'] == 'success';
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteExam(int id, int studentId) async {
    try {
      final res = await http.delete(
        Uri.parse('${AppConstants.baseUrl}/schedule/exams.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'student_id': studentId}),
      );
      return jsonDecode(res.body)['status'] == 'success';
    } catch (_) {
      return false;
    }
  }
}
