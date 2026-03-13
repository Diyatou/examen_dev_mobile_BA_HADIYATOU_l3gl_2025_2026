import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  // Récupérer uniquement les tâches d'un projet précis
  List<Task> getTasksByProject(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }
  // Permet de récupérer la liste complète des tâches
  List<Task> get tasks => [..._tasks];

  // Ajouter une tâche
  void addTask(Task task) {
    _tasks.add(task);
    _saveToPrefs();
    notifyListeners();
  }

  // Supprimer une tâche
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Mettre à jour le statut
  void updateTaskStatus(String taskId, String newStatus) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      // On crée une copie avec le nouveau statut
      _tasks[index] = Task(
        id: _tasks[index].id,
        projectId: _tasks[index].projectId,
        title: _tasks[index].title,
        description: _tasks[index].description,
        status: newStatus,
        dueDate: _tasks[index].dueDate, userId: '', priority: '',
      );
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _tasks.map((task) => task.toJson()).toList(), // Utilise ton toJson() c'est plus simple !
    );
    await prefs.setString('tasks_data', encodedData);
  }

  // Supprimer toutes les tâches d'un projet spécifique
  void deleteTasksByProject(String projectId) {
    // On ne garde que les tâches qui n'appartiennent PAS à ce projet
    _tasks.removeWhere((task) => task.projectId == projectId);

    // On sauvegarde les changements et on prévient l'UI
    _saveToPrefs();
    notifyListeners();
  }
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks_data');

    if (tasksString != null) {
      final List<dynamic> decodedData = jsonDecode(tasksString);
      _tasks = decodedData.map((item) => Task.fromJson(item)).toList(); // Utilise Task.fromJson
      notifyListeners();
    }
  }
}