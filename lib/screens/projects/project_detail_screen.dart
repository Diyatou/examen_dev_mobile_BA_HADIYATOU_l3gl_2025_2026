import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProjectDetailScreen extends StatelessWidget {
  final dynamic project; // Remplace par Project project quand ton modèle est prêt

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: project.color, // Couleur choisie par l'utilisateur pour le projet
        title: const Text("Détails du Projet"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () { /* Navigation vers modif */ },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Statistiques des tâches",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),

                  // Utilisation de tes couleurs AppColors ici
                  _buildTaskStats(),

                  const SizedBox(height: 24),
                  const Text("Liste des tâches",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  // ... Liste des tâches
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: project.color,
        onPressed: () {},
        child: const Icon(Icons.add_task),
      ),
    );
  }

  // --- WIDGETS DE STATISTIQUES AVEC TES COULEURS ---

  Widget _buildTaskStats() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Utilisation de tes constantes AppColors
        _statChip("À faire", "5", AppColors.statusTodo),
        _statChip("En cours", "3", AppColors.statusInProgress),
        _statChip("Terminé", "4", AppColors.statusDone),
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
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text("$label : $count",
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: project.color.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: project.color.withOpacity(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: project.color)),
          const SizedBox(height: 8),
          Text(project.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          // Date de création sans package intl comme tu l'as souhaité
          Text(
            "Créé le : ${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer le projet ?"),
        content: const Text("Toutes les tâches liées seront supprimées."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}