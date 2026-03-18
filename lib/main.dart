import 'package:flutter/material.dart';
import 'package:flutter_app_1/configs/colors.dart';
import 'package:flutter_app_1/configs/routes.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: routes,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: cardColor,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: accentRed,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: textPrimary)),
      ),
    );
  }
}
