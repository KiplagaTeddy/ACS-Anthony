import 'package:flutter/material.dart';
import '../configs/colors.dart'; // make sure you have your colors.dart

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // dark background
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hey Ted 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Here’s your day overview",
              style: TextStyle(color: textSecondary),
            ),

            const SizedBox(height: 20),

            // Cards row
            Row(
              children: [
                _statCard("Tasks", "3", Icons.check),
                const SizedBox(width: 10),
                _statCard("Notes", "5", Icons.note),
              ],
            ),

            const SizedBox(height: 20),

            _infoCard(
              title: "Next Class",
              subtitle: "Mobile Development - 10:00 AM",
              icon: Icons.schedule,
            ),

            const SizedBox(height: 10),

            _infoCard(
              title: "Reminder",
              subtitle: "Finish Flutter project UI",
              icon: Icons.notifications,
            ),
          ],
        ),
      ),
    );
  }

  // small stat cards
  Widget _statCard(String title, String count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: accentRed.withOpacity(0.2), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: accentRed),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            Text(title, style: const TextStyle(color: textSecondary)),
          ],
        ),
      ),
    );
  }

  // wide cards for class/reminder
  Widget _infoCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: accentRed),
        title: Text(title, style: const TextStyle(color: textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(color: textSecondary)),
      ),
    );
  }
}
