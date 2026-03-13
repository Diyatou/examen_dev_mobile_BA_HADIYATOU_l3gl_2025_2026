import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';
// import '../../../providers/task_provider.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  String _selectedStatus = 'Toutes';
  String _selectedPriority = 'Toutes';

  @override
  Widget build(BuildContext context) {
    // On récupère TOUTES les tâches de TOUS les projets
    final taskProvider = Provider.of<TaskProvider>(context);
    final allTasks = taskProvider.tasks; // Supposons que tu as un getter 'tasks'

    return allTasks.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
      itemCount: allTasks.length,
        itemBuilder: (context, index) {
          final task = allTasks[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Échéance : ${task.dueDate.day}/${task.dueDate.month}"),
              trailing: _buildStatusBadge(task.status), // Ton superbe badge dynamique !
              onTap: () {
                // Optionnel : Ouvrir les détails de la tâche ou modifier son statut
              },
            ),
          );
        }
    );
  }

  // Widget pour les filtres par Statut et Priorité
  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _filterChip("Toutes", isStatus: true),
          _filterChip("A faire", isStatus: true),
          _filterChip("En cours", isStatus: true),
          _filterChip("Terminé", isStatus: true),
          const VerticalDivider(),
          _filterChip("Haute", isStatus: false),
          _filterChip("Moyenne", isStatus: false),
          _filterChip("Basse", isStatus: false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {required bool isStatus}) {
    bool isSelected = isStatus ? _selectedStatus == label : _selectedPriority == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {
          setState(() {
            if (isStatus) _selectedStatus = label;
            else _selectedPriority = label;
          });
        },
      ),
    );
  }

  // 3. État vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Aucune tâche trouvée",
            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const Text("Changez les filtres ou créez une nouvelle tâche."),
        ],
      ),
    );
  }

  // 4. Liste des tâches
  Widget _buildTasksList(List<dynamic> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Checkbox(value: false, onChanged: (v) {}),
            title: Text("Tâche ${index + 1}"),
            subtitle: const Text("Priorité: Haute • Projet: SunuTask"),
            trailing: const Icon(Icons.more_vert),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;

    // On définit la couleur selon le statut
    switch (status) {
      case 'À faire':
        color = AppColors.statusTodo; // Gris/Bleu
        break;
      case 'En cours':
        color = AppColors.statusInProgress; // Orange/Jaune
        break;
      case 'Terminée':
        color = AppColors.statusDone; // Vert
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Fond léger
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
