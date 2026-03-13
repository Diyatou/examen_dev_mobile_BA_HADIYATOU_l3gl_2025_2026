import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/task_provider.dart';

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
    final taskProvider = Provider.of<TaskProvider>(context);

    // 1. LOGIQUE DE FILTRAGE : On filtre la liste avant de l'afficher
    final filteredTasks = taskProvider.tasks.where((task) {
      bool statusMatch = _selectedStatus == 'Toutes' || task.status == _selectedStatus;
      bool priorityMatch = _selectedPriority == 'Toutes' || task.priority == _selectedPriority;
      return statusMatch && priorityMatch;
    }).toList();

    return Column(
      children: [
        // 2. AFFICHAGE DES FILTRES
        _buildFilters(),

        // 3. AFFICHAGE DE LA LISTE (ou état vide)
        Expanded(
          child: filteredTasks.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Échéance : ${task.dueDate.day}/${task.dueDate.month}"),
                  trailing: _buildStatusBadge(task.status),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _filterChip("Toutes", isStatus: true),
          _filterChip("À faire", isStatus: true),
          _filterChip("En cours", isStatus: true),
          _filterChip("Terminée", isStatus: true),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("|", style: TextStyle(color: Colors.grey)),
          ),
          _filterChip("Toutes", isStatus: false),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_list_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Aucune tâche trouvée",
            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const Text("Ajustez vos filtres."),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'À faire': color = AppColors.statusTodo; break;
      case 'En cours': color = AppColors.statusInProgress; break;
      case 'Terminée': color = AppColors.statusDone; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}