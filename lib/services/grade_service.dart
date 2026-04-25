import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/grade_model.dart';

class GradeService {
  static Future<Map<String, dynamic>> getAll(int studentId) async {
    try {
      final url =
          '${AppConstants.baseUrl}/grades/index.php?student_id=$studentId';
      print('📡 Fetching grades from: $url');

      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      print('✅ Response status: ${res.statusCode}');

      // Check HTTP status code
      if (res.statusCode != 200) {
        print('❌ Error: HTTP ${res.statusCode}');
        print('📄 Response body: ${res.body}');
        return {
          'grades': <GradeModel>[],
          'overall_gpa': 0.0,
          'total_credits': 0,
          'term_gpas': {},
        };
      }

      final decoded = jsonDecode(res.body);
      print('✅ Grade response: $decoded');

      // CASE 1: Proper structured response
      if (decoded is Map<String, dynamic>) {
        if (decoded['status'] == 'success') {
          final data = decoded['data'];

          // data might be Map OR List (because why be consistent?)
          if (data is Map<String, dynamic>) {
            final gradesList = data['grades'];

            // Normalize term_gpas into a Map for safe downstream use.
            var termGpas = data['term_gpas'];
            if (termGpas is Map) {
              termGpas = Map<String, dynamic>.from(termGpas);
            } else if (termGpas is Iterable) {
              final entries = <MapEntry<String, dynamic>>[];
              for (final item in termGpas) {
                if (item is Map && item.length == 1) {
                  final key = item.keys.first.toString();
                  entries.add(MapEntry(key, item.values.first));
                }
              }
              termGpas = Map<String, dynamic>.fromEntries(entries);
            } else {
              termGpas = <String, dynamic>{};
            }

            return {
              'grades': (gradesList is List ? gradesList : [])
                  .map((e) => GradeModel.fromJson(e))
                  .toList(),
              'overall_gpa': data['overall_gpa'] ?? 0.0,
              'total_credits': data['total_credits'] ?? 0,
              'term_gpas': termGpas,
            };
          }

          // CASE: data itself is a List
          if (data is List) {
            return {
              'grades': data.map((e) => GradeModel.fromJson(e)).toList(),
              'overall_gpa': 0.0,
              'total_credits': 0,
              'term_gpas': {},
            };
          }
        }
      }

      // CASE 2: API returns list directly
      if (decoded is List) {
        return {
          'grades': decoded.map((e) => GradeModel.fromJson(e)).toList(),
          'overall_gpa': 0.0,
          'total_credits': 0,
          'term_gpas': {},
        };
      }
    } on TimeoutException catch (e) {
      print('⏱️ Timeout error: $e - API server may not be running');
    } catch (e) {
      print('❌ GradeService.getAll error: $e');
    }

    return {
      'grades': <GradeModel>[],
      'overall_gpa': 0.0,
      'total_credits': 0,
      'term_gpas': {},
    };
  }

  static Future<bool> save(Map<String, dynamic> body) async {
    try {
      final res = await http
          .post(
            Uri.parse('${AppConstants.baseUrl}/grades/index.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) {
        print('Save error: HTTP ${res.statusCode}');
        return false;
      }

      return jsonDecode(res.body)['status'] == 'success';
    } catch (e) {
      print('GradeService.save error: $e');
      return false;
    }
  }

  static Future<bool> delete(int id, int studentId) async {
    try {
      final res = await http
          .delete(
            Uri.parse('${AppConstants.baseUrl}/grades/index.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'id': id, 'student_id': studentId}),
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) {
        print('Delete error: HTTP ${res.statusCode}');
        return false;
      }

      return jsonDecode(res.body)['status'] == 'success';
    } catch (e) {
      print('GradeService.delete error: $e');
      return false;
    }
  }
}
