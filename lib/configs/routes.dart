import 'package:flutter_app_1/views/login_page.dart';
import 'package:flutter_app_1/views/signup_page.dart';
import 'package:flutter_app_1/views/homescreen.dart';
import 'package:flutter_app_1/views/tasksScreen.dart';
import 'package:flutter_app_1/views/profile.dart';
import 'package:flutter_app_1/views/notesScreen.dart';
import 'package:get/get.dart';

var routes = [
  GetPage(name: '/', page: () => const LoginPage()),
  GetPage(name: '/signup', page: () => const SignUpPage()),
  GetPage(name: '/homescreen', page: () => const Homescreen()),
  GetPage(name: '/tasks', page: () => const TasksScreen()),
  GetPage(name: '/profile', page: () => const ProfileScreen()),
  GetPage(name: '/notes', page: () => const NotesScreen()),
];
