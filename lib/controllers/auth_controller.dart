import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  bool get isLoggedIn => user.value != null;
  int get studentId => user.value?.studentId ?? 0;

  @override
  void onInit() {
    super.onInit();
    tryAutoLogin();
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await AuthService.login(email, password);
    isLoading.value = false;
    if (result['success']) {
      user.value = result['user'];
      await _save(user.value!);
      return true;
    }
    errorMessage.value = result['message'];
    return false;
  }

  Future<bool> register(Map<String, dynamic> body) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await AuthService.register(body);
    isLoading.value = false;
    if (result['success']) {
      user.value = result['user'];
      await _save(user.value!);
      return true;
    }
    errorMessage.value = result['message'];
    return false;
  }

  Future<void> logout() async {
    user.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    Get.offAllNamed('/login');
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user');
    if (data != null) user.value = UserModel.fromJson(jsonDecode(data));
  }

  Future<void> _save(UserModel u) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user',
      jsonEncode({
        'id': u.id,
        'name': u.name,
        'email': u.email,
        'student_id': u.studentId,
        'reg_number': u.regNumber,
        'department': u.department,
        'year_of_study': u.yearOfStudy,
        'phone': u.phone,
      }),
    );
  }
}
