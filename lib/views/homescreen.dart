import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/configs/colors.dart';
import 'package:flutter_app_1/views/tasksScreen.dart';
import 'package:flutter_app_1/views/profile.dart';
import 'package:flutter_app_1/views/notesScreen.dart';
import 'package:flutter_app_1/views/scheduleScreen.dart';
import 'package:flutter_app_1/views/dashboard.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    DashboardPage(),
    TasksScreen(),
    NotesScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: primaryColor,

        items: const <Widget>[
          Icon(Icons.dashboard, size: 30),
          Icon(Icons.check, size: 30),
          Icon(Icons.note, size: 30),
          Icon(Icons.schedule, size: 30),
          Icon(Icons.person, size: 30),
        ],

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
