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

  // Ajouter une tâche
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners(); // Pour mettre à jour les statistiques instantanément
  }

  // Supprimer une tâche
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Mettre à jour le statut (très utile pour changer 'En cours' en 'Terminée')
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

    // On transforme la liste d'objets Task en une liste de Maps (JSON)
    final String encodedData = jsonEncode(
      _tasks.map((task) => {
        'id': task.id,
        'projectId': task.projectId,
        'title': task.title,
        'description': task.description,
        'status': task.status,
        'dueDate': task.dueDate.toIso8601String(),
      }).toList(),
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
      _tasks = decodedData.map((item) => Task(
        id: item['id'],
        projectId: item['projectId'],
        title: item['title'],
        description: item['description'],
        status: item['status'],
        dueDate: DateTime.parse(item['dueDate']), userId: '', priority: '',
      )).toList();
      notifyListeners();
    }
  }
}