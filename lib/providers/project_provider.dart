import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Project> get projects => _projects;

  // CREATE : Ajouter un projet
  Future<void> addProject(Project project) async {
    _projects.add(project);
    await _saveToPrefs();
    notifyListeners(); // Prévient l'UI de se mettre à jour
  }

  //  READ : Charger depuis SharedPreferences
  Future<void> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? projectsData = prefs.getString('projects');
    if (projectsData != null) {
      final List<dynamic> decoded = jsonDecode(projectsData);
      _projects = decoded.map((item) => Project.fromJson(item)).toList();
      notifyListeners();
    }
  }

  //  UPDATE : Modifier un projet
  Future<void> updateProject(Project updatedProject) async {
    // On cherche la position du projet qui a le même ID
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);

    if (index != -1) {
      _projects[index] = updatedProject; // On remplace l'ancien par le nouveau
      await _saveToPrefs(); // On sauvegarde dans le téléphone
      notifyListeners();    // TRÈS IMPORTANT : signaler à l'interface de se redessiner
    }
  }

  // 4. DELETE : Supprimer un projet
  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    await _saveToPrefs();
    notifyListeners();
  }

  // Sauvegarde interne
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_projects.map((p) => p.toJson()).toList());
    await prefs.setString('projects', encoded);
  }
}