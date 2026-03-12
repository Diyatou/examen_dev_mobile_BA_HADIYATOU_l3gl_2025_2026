import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;


  List<Task> getTasksByProject(String projectId) {
    return _tasks.where((t) => t.projectId == projectId).toList();
  }


  int getCountByStatus(String status) {
    return _tasks.where((t) => t.status == status).toList().length;
  }

  // --- CRUD ---

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksData = prefs.getString('tasks');
    if (tasksData != null) {
      final List<dynamic> decoded = jsonDecode(tasksData);
      _tasks = decoded.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _saveToPrefs();
    notifyListeners();
  }

  // Supprimer toutes les tâches d'un projet (quand on supprime le projet)
  Future<void> deleteTasksByProject(String projectId) async {
    _tasks.removeWhere((t) => t.projectId == projectId);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString('tasks', encoded);
  }
}