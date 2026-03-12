import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/project.dart';
import '../../../providers/project_provider.dart';
import '../../projects/project_detail_screen.dart';
import '../../projects/project_form_screen.dart';


class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // ON LIT LES PROJETS DEPUIS LE PROVIDER ICI
    final projectProvider = Provider.of<ProjectProvider>(context);
    final projects = projectProvider.projects;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: projects.isEmpty
          ? _buildEmptyState(context)
          : _buildProjectList(projects), // Utilise maintenant la vraie liste
    );
  }

  // 1. État vide (Message + Icône)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "Aucun projet pour le moment",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          const Text(
            "Créez votre premier projet pour commencer à organiser vos tâches.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          // Modifie le onPressed de ton bouton dans _buildEmptyState
          ElevatedButton.icon(
            onPressed: () {
              // On va directement au formulaire au lieu d'ouvrir un dialogue inutile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProjectFormScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Créer un projet"),
          ),
        ],
      ),
    );
  }

  // 2. Liste des projets
  Widget _buildProjectList(List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: project.color,
              child: const Icon(Icons.folder, color: Colors.white),
            ),
            title: Text(project.name),
            subtitle: Text(project.description.isEmpty ? "Pas de description" : project.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailScreen(project: project),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 3. Dialogue de création de projet
  void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouveau Projet"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Nom du projet",
                hintText: "Ex: Développement Mobile",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Optionnel",
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormScreen(),
                ),
              );
            },
            child: const Text("Créer"),
          ),
        ],
      ),
    );
  }
}