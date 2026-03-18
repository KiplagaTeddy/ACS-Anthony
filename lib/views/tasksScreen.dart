import 'package:flutter/material.dart';
import '../models/tasks.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [
    Task(title: "Finish Mobile Dev Assignment"),
    Task(title: "Study Dart Lists"),
    Task(title: "Prepare Flutter Presentation"),
  ];

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].done = !tasks[index].done;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void showAddTaskDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter task name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                addTask(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),

      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null,
              ),
            ),

            leading: Checkbox(
              value: task.done,
              onChanged: (value) {
                toggleTask(index);
              },
            ),

            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteTask(index);
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
