import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks {
    // Tri : En cours > À faire > Terminé, puis Haute > Moyenne > Basse
    List<Task> sortedTasks = List.from(_tasks);
    sortedTasks.sort((a, b) {
      int statusCompare = a.status.index.compareTo(b.status.index);
      if (statusCompare != 0) return statusCompare;
      return b.priority.index.compareTo(a.priority.index);
    });
    return sortedTasks;
  }

  bool get isLoading => _isLoading;

  Future<void> loadTasks(String projectId) async {
    _isLoading = true;
    notifyListeners();
    // TODO: Appel StorageService
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
  }


}
