import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/course_model.dart';

class CourseService {
  static Future<List<CourseModel>> getAll() async {
    try {
      final res = await http
          .get(Uri.parse('${AppConstants.baseUrl}/courses/index.php'))
          .timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) {
        print('❌ CourseService error: HTTP ${res.statusCode}');
        return [];
      }

      final data = jsonDecode(res.body);
      print('✅ Courses response: $data');
      
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        final courseData = data['data'];
        if (courseData is List) {
          return courseData
              .map((e) => CourseModel.fromJson(e))
              .toList();
        } else if (courseData is Map) {
          // If data is a Map instead of List, return empty
          return [];
        }
      } else if (data is List) {
        // If API returns list directly
        return data.map((e) => CourseModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('❌ CourseService.getAll error: $e');
    }
    return [];
  }
}
