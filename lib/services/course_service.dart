import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/course_model.dart';

class CourseService {
  static Future<List<CourseModel>> getAll() async {
    try {
      final res = await http.get(
        Uri.parse('${AppConstants.baseUrl}/courses/index.php'),
      );
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        return (data['data'] as List)
            .map((e) => CourseModel.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
