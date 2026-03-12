import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    // Simulation d'une liste (à remplacer par taskProvider.tasks)
    final List<dynamic> tasks = [];

    return Column(
      children: [
        // 1. Zone de filtrage
        _buildFilters(),

        // 2. Liste ou État vide
        Expanded(
          child: tasks.isEmpty
              ? _buildEmptyState()
              : _buildTasksList(tasks),
        ),
      ],
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
}