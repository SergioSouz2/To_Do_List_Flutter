import 'package:flutter_application_1/domain/task_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/task_repository.dart';
import 'package:flutter_application_1/screens/add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository taskRepository;

  const TaskListScreen({Key? key, required this.taskRepository})
      : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tela carregada com sucesso!'),
          duration: Duration(seconds: 2), // Defina a duração da mensagem
        ),
      );
    });
    tasks = TaskRepository.tasks;
  }

  void refreshTaskList() {
    setState(() {
      tasks = TaskRepository.tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = TaskRepository.tasks;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2e2c42),
        title: const Text('Lista de Tarefas'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),

      backgroundColor: Color(0xFF2e2c42),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            //implementar a ação de arrastar para o lado e excluir um item
            key: Key(tasks[index].title),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
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
                  tasks[index].title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  tasks[index].description,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  DateFormat('dd/MM/yyyy').format(tasks[index].date),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Implemente a ação desejada quando o item for tocado
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTaskScreen(taskRepository: TaskRepository()),
            ),
          );
          refreshTaskList(); // Atualiza a lista de tarefas após adicionar uma nova tarefa
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Posicione o botão flutuante no canto inferior direito
    );
  }
}
