import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/project_provider.dart';
import '../../providers/task_provider.dart';
import '../../models/project.dart';
import '../tasks/task_form_screen.dart';
import 'project_form_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    /// 1. ON ÉCOUTE LE PROVIDER POUR AVOIR LES MISES À JOUR
    final projectProvider = Provider.of<ProjectProvider>(context);

    /// On récupère la version la plus fraîche du projet depuis la liste
    final currentProject = projectProvider.projects.firstWhere(
          (p) => p.id == project.id,
      orElse: () => project,
    );

    final taskProvider = Provider.of<TaskProvider>(context);

    /// 2. ON CALCULE LES STATS (en utilisant currentProject.id)
    final projectTasks = taskProvider.getTasksByProject(currentProject.id);
    int todoCount = projectTasks.where((t) => t.status == "À faire").length;
    int inProgressCount = projectTasks.where((t) => t.status == "En cours").length;
    int doneCount = projectTasks.where((t) => t.status == "Terminée").length;

    print("DEBUG: ID Projet actuel = ${currentProject.id}");
    print("DEBUG: Nombre de tâches filtrées = ${projectTasks.length}");
    print("DEBUG: Nombre total de tâches dans le provider = ${taskProvider.tasks.length}");

    return Scaffold(
      appBar: AppBar(
        // ON UTILISE currentProject PARTOUT MAINTENANT
        backgroundColor: currentProject.color,
        title: const Text("Détails du Projet"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectFormScreen(project: currentProject),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, currentProject),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(currentProject), // On passe currentProject ici
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Statistiques des tâches",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  _buildTaskStats(todoCount, inProgressCount, doneCount),
                  const SizedBox(height: 24),
                  const Text("Liste des tâches",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  // TODO: Liste des tâches
                  const SizedBox(height: 12),
                  ...projectTasks.map((task) => Card(
                    child: ListTile(
                      leading: Icon(Icons.circle, color: _getStatusColor(task.status), size: 12),
                      title: Text(task.title),
                      subtitle: Text(task.priority),
                      trailing: Text("${task.dueDate.day}/${task.dueDate.month}"),
                    ),
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: currentProject.color, // On utilise la couleur du projet
        onPressed: () {
          // On navigue vers le formulaire en PASSANT L'ID du projet actuel
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFormScreen(projectId: currentProject.id),
            ),
          );
        },
        child: const Icon(Icons.add_task),
      ),
    );
  }

  // --- LES MÉTHODES HELPER (Mises à jour) ---

  Widget _buildHeader(Project proj) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: proj.color.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: proj.color.withOpacity(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(proj.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: proj.color)),
          const SizedBox(height: 8),
          Text(proj.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Text(
            "Créé le : ${proj.createdAt.day}/${proj.createdAt.month}/${proj.createdAt.year}",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStats(int todo, int inProgress, int done) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _statChip("À faire", todo.toString(), AppColors.statusTodo),
        _statChip("En cours", inProgress.toString(), AppColors.statusInProgress),
        _statChip("Terminée", done.toString(), AppColors.statusDone),
      ],
    );
  }

  Widget _statChip(String label, String count, Color color) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.4)),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text("$label : $count", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Project proj) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer le projet ?"),
        content: const Text("Toutes les tâches liées seront également supprimées."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<ProjectProvider>(context, listen: false).deleteProject(proj.id);
              Provider.of<TaskProvider>(context, listen: false).deleteTasksByProject(proj.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'À faire':
        return AppColors.statusTodo;      // Assure-toi que c'est défini dans AppColors
      case 'En cours':
        return AppColors.statusInProgress;
      case 'Terminée':
        return AppColors.statusDone;
      default:
        return Colors.grey;               // Couleur de secours
    }
  }
}