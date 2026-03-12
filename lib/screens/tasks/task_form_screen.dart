import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart'; // Importe tes couleurs

class TaskFormScreen extends StatefulWidget {
  final dynamic task; // Remplace par Task? task plus tard

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;

  late String _selectedStatus;
  late String _selectedPriority;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    bool isEditing = widget.task != null;
    _titleController = TextEditingController(text: isEditing ? widget.task.title : "");
    _descController = TextEditingController(text: isEditing ? widget.task.description : "");
    _selectedStatus = isEditing ? widget.task.status : "À faire";
    _selectedPriority = isEditing ? widget.task.priority : "Moyenne";
    _dueDate = isEditing ? widget.task.dueDate : DateTime.now();
  }

  // Fonction pour ouvrir le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dueDate) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Modifier la tâche" : "Nouvelle tâche"),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Titre et Description
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Titre de la tâche *"),
                validator: (v) => v!.isEmpty ? "Le titre est obligatoire" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // 2. Sélecteur de Statut (Animé)
              const Text("Statut", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildAnimatedSelectable("À faire", AppColors.statusTodo, isStatus: true),
                  _buildAnimatedSelectable("En cours", AppColors.statusInProgress, isStatus: true),
                  _buildAnimatedSelectable("Terminée", AppColors.statusDone, isStatus: true),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Sélecteur de Priorité (Animé)
              const Text("Priorité", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildAnimatedSelectable("Haute", AppColors.priorityHigh, isStatus: false),
                  _buildAnimatedSelectable("Moyenne", AppColors.priorityMedium, isStatus: false),
                  _buildAnimatedSelectable("Basse", AppColors.priorityLow, isStatus: false),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Date d'échéance
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text("Date d'échéance"),
                subtitle: Text(_dueDate == null ? "Non définie" : "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}"),
                trailing: TextButton(onPressed: () => _selectDate(context), child: const Text("Choisir")),
              ),

              const SizedBox(height: 40),

              // 5. Bouton Enregistrer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(isEditing ? "Enregistrer les modifications" : "Créer la tâche"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPOSANT ANIMÉ POUR SÉLECTEURS ---
  Widget _buildAnimatedSelectable(String label, Color color, {required bool isStatus}) {
    bool isSelected = isStatus ? _selectedStatus == label : _selectedPriority == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isStatus ? _selectedStatus = label : _selectedPriority = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? color : color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer la tâche ?"),
        content: const Text("Voulez-vous vraiment supprimer cette tâche ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(onPressed: () {
            Navigator.pop(context); // Ferme dialog
            Navigator.pop(context); // Revient en arrière
          }, child: const Text("Supprimer", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}