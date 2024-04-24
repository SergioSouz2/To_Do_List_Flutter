import 'package:flutter_application_1/domain/task/TaskProvider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/domain/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            appBarTheme: AppBarTheme(
              elevation: 1, // Altura da sombra
              shadowColor: Colors.purple.withOpacity(1), // Cor da sombra
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _isButtonDisabled = true;
  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateButtonState);
    _descriptionController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      // Verificar se os campos de texto estão vazios
      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty) {
        // Se algum dos campos estiver vazio, desabilite o botão
        _isButtonDisabled = true;
      } else {
        // Se ambos os campos tiverem conteúdo, habilite o botão
        _isButtonDisabled = false;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Adicionar Tarefa',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2e2c42),
      ),
      backgroundColor: const Color(0xFF2e2c42),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Data',
                          labelStyle: TextStyle(color: Colors.white),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        controller: TextEditingController(
                          text: DateFormat('dd/MM/yyyy').format(_selectedDate),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(const Size.fromHeight(50)),
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      if (!_isButtonDisabled) {
                        String title = _titleController.text;
                        String description = _descriptionController.text;
                        DateTime date = _selectedDate;

                        Task newTask = Task(
                          title: title,
                          description: description,
                          date: date,
                        );

                        Provider.of<TaskProvider>(context, listen: false)
                            .addTask(newTask);
                        Navigator.of(context).pop();
                      }
                    },
              child: const Text(
                'Adicionar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
