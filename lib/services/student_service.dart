import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/student_model.dart';

class StudentService {
  static Future<List<StudentModel>> getAll() async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/students/index.php'),
    );
    final data = jsonDecode(res.body);
    if (data['status'] == 'success') {
      return (data['data'] as List)
          .map((e) => StudentModel.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<bool> addStudent(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/students/index.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final data = jsonDecode(res.body);
    return data['status'] == 'success';
  }

  static Future<bool> updateStudent(Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('${AppConstants.baseUrl}/students/index.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final data = jsonDecode(res.body);
    return data['status'] == 'success';
  }

  static Future<bool> deleteStudent(int userId) async {
    final res = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/students/index.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    final data = jsonDecode(res.body);
    return data['status'] == 'success';
  }
}
