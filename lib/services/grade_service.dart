import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/grade_model.dart';

class GradeService {
  static Future<Map<String, dynamic>> getAll(int studentId) async {
    try {
      final res = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}/grades/index.php?student_id=$studentId',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        return {
          'grades': (data['data']['grades'] as List)
              .map((e) => GradeModel.fromJson(e))
              .toList(),
          'overall_gpa': data['data']['overall_gpa'],
          'total_credits': data['data']['total_credits'],
          'term_gpas': data['data']['term_gpas'],
        };
      }
    } catch (_) {}
    return {
      'grades': <GradeModel>[],
      'overall_gpa': 0.0,
      'total_credits': 0,
      'term_gpas': {},
    };
  }

  static Future<bool> save(Map<String, dynamic> body) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConstants.baseUrl}/grades/index.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return jsonDecode(res.body)['status'] == 'success';
    } catch (_) {
      return false;
    }
  }

  static Future<bool> delete(int id, int studentId) async {
    try {
      final res = await http.delete(
        Uri.parse('${AppConstants.baseUrl}/grades/index.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'student_id': studentId}),
      );
      return jsonDecode(res.body)['status'] == 'success';
    } catch (_) {
      return false;
    }
  }
}
