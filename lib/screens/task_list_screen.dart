import 'package:flutter_application_1/domain/task/task_model.dart';
import 'package:flutter_application_1/domain/task/TaskProvider.dart';
import 'package:flutter_application_1/screens/add_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2e2c42),
        title: const Text('Lista de Tarefas'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xFF2e2c42),
      body: Consumer<TaskProvider>(builder: (context, provider, child) {
        return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              if (index.isOdd) {
                // Índice ímpar, adiciona o espaço
                return const SizedBox(
                    height: 16); // Altura do espaço entre os itens
              }
              final Task task = provider.tasks[index];
              return Dismissible(
                  //implementar a ação de arrastar para o lado e excluir um item
                  key: Key(provider.tasks[index].title),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      provider.tasks.removeAt(index);
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFf071b6),
                            Color(0xFF7c64ec),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.purple,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.library_books_outlined,
                              color: Colors.purple,
                            )),
                        title: Text(
                          provider.tasks[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          provider.tasks[index].description,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          DateFormat('dd/MM/yyyy')
                              .format(provider.tasks[index].date),
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          _showEditDialog(context, provider, task, index);
                        },
                      )));
            });
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, TaskProvider provider, Task task, int index) {
    TextEditingController titleController =
        TextEditingController(text: task.title);
    TextEditingController descriptionController =
        TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          title: const Text('Editar Tarefa'),
          content: Container(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Task updatedTask = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                  date: task.date,
                );
                provider.updateTask(index, updatedTask);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
