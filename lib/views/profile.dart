import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),

            const SizedBox(height: 15),

            const Text(
              "Ted Mwangi",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const Text("Computer Science Student"),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: const Text("ted@example.com"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: const Text("University"),
                subtitle: const Text("Daystar University"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
