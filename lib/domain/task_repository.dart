import 'package:flutter_application_1/domain/task_model.dart';

class TaskRepository {
  static List<Task> tasks = [
    Task(
      title: 'Comprar leite',
      description: 'Ir ao supermercado e comprar leite desnatado',
      date: DateTime.now(),
    ),
    Task(
      title: 'Pagar contas',
      description: 'Pagar a conta de água até o dia 20',
      date: DateTime.now(),
    ),
  ];

  void addTask(Task task) {
    tasks.add(task);
  }
}
