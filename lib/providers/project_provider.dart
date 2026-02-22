import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectProvider extends ChangeNotifier{
  List<Project> _projects = [];
  Project? _selectedProject;
  bool _isLoading = false;

  // Getters publics
  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  int get projectCount => _projects.length;
  bool get isLoading => _isLoading;

  // Méthodes CRUD demandées
  Future<void> loadProjects(String userId) async {
    _isLoading = true;
    notifyListeners();
    // TODO: Récupérer depuis StorageService
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createProject(Project project) async {
    _projects.add(project);
    // TODO: Sauvegarder dans StorageService
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((p) => p.id == projectId);
    notifyListeners();
  }

  void selectProject(Project? project) {
    _selectedProject = project;
    notifyListeners();
  }


}