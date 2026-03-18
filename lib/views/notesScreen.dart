import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final notes = [
      "Flutter uses widgets",
      "Dart is strongly typed",
      "State management matters",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),

      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {

          return Card(
            child: ListTile(
              title: Text(notes[index]),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}