import 'package:flutter/material.dart';

class AppConstants {
  static const String baseUrl = 'http://192.168.100.3/student_system/api';
  static const String appName = 'Jipange';

  static const Color primaryColor = Color(0xFFE53935);
  static const Color secondaryColor = Color(0xFFB71C1C);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color successColor = Color(0xFF69F0AE);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color dividerColor = Color(0xFF2C2C2C);

  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double radiusM = 12.0;
  static const double radiusL = 20.0;

  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  static const List<String> terms = ['Term 1', 'Term 2', 'Term 3'];
  static const List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Kenyan 4.0 GPA scale
  static Map<String, dynamic> gradeFromMarks(double marks) {
    if (marks >= 70)
      return {'letter': 'A', 'points': 4.0, 'color': Color(0xFF69F0AE)};
    if (marks >= 60)
      return {'letter': 'B+', 'points': 3.5, 'color': Color(0xFF40C4FF)};
    if (marks >= 50)
      return {'letter': 'B', 'points': 3.0, 'color': Color(0xFF448AFF)};
    if (marks >= 40)
      return {'letter': 'C+', 'points': 2.5, 'color': Color(0xFFFFD740)};
    if (marks >= 30)
      return {'letter': 'C', 'points': 2.0, 'color': Color(0xFFFF6D00)};
    return {'letter': 'D', 'points': 1.0, 'color': Color(0xFFFF5252)};
  }
}
