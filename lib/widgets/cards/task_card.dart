import 'package:flutter/material.dart';
//C'est ici que tu afficheras le détail des tâches, avec des badges de couleur selon leur priorité ou leur statut.

class TaskCard extends StatelessWidget{
  final String title;
  final String description;
  final String status; // todo, inProgress, done
  final String priority; // low, medium, high
  final DateTime? dueDate;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Déterminer la couleur du badge de priorité
    Color priorityColor = priority == 'high' ? Colors.red : (priority == 'medium' ? Colors.orange : Colors.blue);

    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: priorityColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                  child: Text(priority.toUpperCase(), style: TextStyle(color: priorityColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                if (dueDate != null) Text("${dueDate!.day}/${dueDate!.month}", style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: status == 'done',
          onChanged: (_) => onTap(),
        ),
      ),
    );
  }git

}