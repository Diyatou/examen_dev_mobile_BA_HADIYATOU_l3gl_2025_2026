import 'package:flutter/material.dart';

//Cette carte servira à afficher nos différents projets sur l'écran d'accueil.

class ProjectCard extends StatelessWidget{
  final String name;
  final String description;
  final Color color;
  final int taskCount;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.name,
    required this.description,
    required this.color,
    required this.taskCount,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: color, radius: 12),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$description\n$taskCount tâches", maxLines: 2),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text("Modifier")),
            const PopupMenuItem(value: 'delete', child: Text("Supprimer", style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

}