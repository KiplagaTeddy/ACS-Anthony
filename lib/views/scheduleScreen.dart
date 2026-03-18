import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final schedule = [
      {"time": "8:00 AM", "course": "Math"},
      {"time": "10:00 AM", "course": "Mobile Dev"},
      {"time": "2:00 PM", "course": "Networking"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Schedule")),

      body: ListView.builder(
        itemCount: schedule.length,
        itemBuilder: (context, index) {

          final item = schedule[index];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(item["course"].toString()),
              subtitle: Text(item["time"].toString()),
            ),
          );
        },
      ),
    );
  }
}