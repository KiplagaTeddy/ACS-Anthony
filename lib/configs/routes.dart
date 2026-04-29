// filepath: lib/configs/routes.dart
import 'package:get/get.dart';
import '../screens/splash_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/dashboard.dart';
import '../screens/schedule_screen.dart';
import '../screens/grades_screen.dart';
import '../screens/profile.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String schedule = '/schedule';
  static const String grades = '/grades';
  static const String profile = '/profile';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const AuthScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: schedule, page: () => const ScheduleScreen()),
    GetPage(name: grades, page: () => const GradesScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
  ];
}
