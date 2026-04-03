import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        return {'success': true, 'user': UserModel.fromJson(data['data'])};
      }
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    } catch (_) {
      return {'success': false, 'message': 'Cannot connect to server.'};
    }
  }

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body);
      if (data['status'] == 'success') {
        return {'success': true, 'user': UserModel.fromJson(data['data'])};
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Registration failed',
      };
    } catch (_) {
      return {'success': false, 'message': 'Cannot connect to server.'};
    }
  }
}
