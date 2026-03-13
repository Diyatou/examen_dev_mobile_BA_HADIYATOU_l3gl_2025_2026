import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/task.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/task_provider.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Simule un changement de statut rapide
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.task.status;
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Haute': return AppColors.priorityHigh;
      case 'Moyenne': return AppColors.priorityMedium;
      case 'Basse': return AppColors.priorityLow;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la tâche"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskFormScreen(task: widget.task, projectId: '',)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Badge de Priorité
            _buildPriorityBadge(widget.task.priority),
            const SizedBox(height: 16),

            // Titre et Description
            Text(
              widget.task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              widget.task.description.isEmpty ? "Aucune description fournie." : widget.task.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
            ),

            const Divider(height: 40),

            // Date d'échéance
            _buildInfoRow(Icons.calendar_month, "Échéance",
                "${widget.task.dueDate.day}/${widget.task.dueDate.month}/${widget.task.dueDate.year}"),

            const SizedBox(height: 24),

            // 4. Changement de Statut Rapide
            const Text("Changer le statut :", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildQuickStatusSwitcher(),
          ],
        ),
      ),
    );
  }

  // ***** COMPOSANTS VISUELS ***

  Widget _buildPriorityBadge(String priority) {
    Color color = _getPriorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            "Priorité $priority",
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 20),
        const SizedBox(width: 12),
        Text("$label : ", style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildQuickStatusSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statusButton("À faire", AppColors.statusTodo),
        _statusButton("En cours", AppColors.statusInProgress),
        _statusButton("Terminée", AppColors.statusDone),
      ],
    );
  }

  Widget _statusButton(String label, Color color) {
    bool isSelected = _currentStatus == label;
    return GestureDetector(
      onTap: () => setState(() => _currentStatus = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Supprimer la tâche ?"),
          content: const Text("Voulez-vous vraiment supprimer cette tâche ? Cette action est irréversible."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                 context.read<TaskProvider>().deleteTask(widget.task.id);

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Supprimer", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}