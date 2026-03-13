import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // N'oublie pas d'ajouter uuid dans ton pubspec.yaml
import '../../core/constants/app_colors.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task; // Type Task? pour plus de clarté
  final String projectId;

  const TaskFormScreen({super.key, this.task, required this.projectId});

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
    _titleController = TextEditingController(text: isEditing ? widget.task!.title : "");
    _descController = TextEditingController(text: isEditing ? widget.task!.description : "");
    _selectedStatus = isEditing ? widget.task!.status : "À faire";
    _selectedPriority = isEditing ? widget.task!.priority : "Moyenne";
    _dueDate = isEditing ? widget.task!.dueDate : DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Champs de texte
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Titre de la tâche *",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Le titre est obligatoire" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // 2. Sélecteur de Statut
              const Text("Statut", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildAnimatedSelectable("À faire", AppColors.statusTodo, isStatus: true),
                  _buildAnimatedSelectable("En cours", AppColors.statusInProgress, isStatus: true),
                  _buildAnimatedSelectable("Terminée", AppColors.statusDone, isStatus: true),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Sélecteur de Priorité
              const Text("Priorité", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.blue),
                  title: const Text("Date d'échéance"),
                  subtitle: Text("${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}"),
                  trailing: TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text("Choisir"),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 5. Bouton Enregistrer (UNIQUE)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

                      if (!isEditing) {
                        // CRÉATION
                        final newTask = Task(
                          id: const Uuid().v4(),
                          projectId: widget.projectId,
                          userId: 'user_1', // Temporaire
                          title: _titleController.text,
                          description: _descController.text,
                          status: _selectedStatus,
                          priority: _selectedPriority,
                          dueDate: _dueDate!,
                        );
                        taskProvider.addTask(newTask);
                      } else {
                        // ÉDITION (Optionnel pour l'instant)
                        // logic for update...
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    isEditing ? "ENREGISTRER LES MODIFICATIONS" : "CRÉER LA TÂCHE",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}