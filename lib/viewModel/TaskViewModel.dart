import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/DatabaseService.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _liste = [];
  List<Task> get liste => _liste;

  final DatabaseService _dbService = DatabaseService();

  TaskViewModel() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _liste = await _dbService.getTasks();
    ();
  }

  Future<void> addTask(Task task) async {
    await _dbService.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task updatedTask) async {
    await _dbService.updateTask(updatedTask);
    await loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    await _dbService.deleteTask(task);
    await loadTasks();
  }
}
