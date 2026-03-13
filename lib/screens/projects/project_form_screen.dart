import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/project.dart';
import '../../providers/project_provider.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;

  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late Color _selectedColor;

  final List<Color> _predefinedColors = [
    Colors.blue, Colors.red, Colors.green, Colors.orange,
    Colors.purple, Colors.pink, Colors.teal, Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? "");
    _descriptionController = TextEditingController(text: widget.project?.description ?? "");
    _selectedColor = widget.project?.color ?? _predefinedColors[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ******* LA LOGIQUE DE SAUVEGARDE ******
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

      if (widget.project == null) {
        // --- CAS CRÉATION ---
        final newProject = Project(
          id: DateTime.now().toString(),
          name: _nameController.text,
          description: _descriptionController.text,
          color: _selectedColor,
          createdAt: DateTime.now(),
        );
        projectProvider.addProject(newProject);
      } else {
        // **** CAS MODIFICATION ****

        final updatedProject = Project(
          id: widget.project!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          color: _selectedColor,
          createdAt: widget.project!.createdAt,
        );

        projectProvider.updateProject(updatedProject);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.project != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Modifier le projet" : "Nouveau projet"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Aperçu :", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildProjectPreview(),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nom du projet *",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return "Le nom doit contenir au moins 3 caractères";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description (optionnel)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 24),

              const Text("Couleur du projet", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _predefinedColors.map((color) => _buildColorCircle(color)).toList(),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submitForm,
                  child: Text(isEditing ? "ENREGISTRER LES MODIFICATIONS" : "CRÉER LE PROJET"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }

  Widget _buildProjectPreview() {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: _selectedColor, child: const Icon(Icons.folder, color: Colors.white)),
        title: Text(_nameController.text.isEmpty ? "Nom du projet" : _nameController.text),
        subtitle: Text(_descriptionController.text.isEmpty ? "Pas de description" : _descriptionController.text),
      ),
    );
  }
}