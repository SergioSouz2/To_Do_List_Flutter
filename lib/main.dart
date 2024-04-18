import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/add_task_screen.dart';
import 'package:flutter_application_1/screens/task_list_screen.dart';
import 'package:flutter_application_1/domain/task_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskRepository taskRepository = TaskRepository();

    return MaterialApp(
      title: 'To-Do List App',
      initialRoute: '/',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => TaskListScreen(taskRepository: taskRepository),
        '/adicionar': (context) =>
            AddTaskScreen(taskRepository: taskRepository),
      },
    );
  }
}
