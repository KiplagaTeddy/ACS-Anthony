import 'package:flutter_app_1/views/login_page.dart';
import 'package:flutter_app_1/views/signup_page.dart';
import 'package:flutter_app_1/views/homescreen.dart';
import 'package:get/get.dart';

var routes = [
  GetPage(name: '/', page: () => const LoginPage()),
  GetPage(name: '/signup', page: () => const SignUpPage()),
  GetPage(name: '/homescreen', page: () => const Homescreen()),
];
