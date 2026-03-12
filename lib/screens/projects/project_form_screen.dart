import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
// import '../../models/project.dart'; // Assure-toi d'avoir ce modèle

class ProjectFormScreen extends StatefulWidget {
  final dynamic project; // Remplace dynamic par Project? quand ton modèle sera prêt

  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  // État du sélecteur de couleur
  late Color _selectedColor;

  // Liste des 8 couleurs prédéfinies
  final List<Color> _predefinedColors = [
    Colors.blue, Colors.red, Colors.green, Colors.orange,
    Colors.purple, Colors.pink, Colors.teal, Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    // Mode modification : on pré-remplit les champs
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
              // 1. Aperçu en temps réel
              const Text("Aperçu :", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildProjectPreview(),
              const SizedBox(height: 24),

              // 2. Champ Nom (Obligatoire, min 3 car.)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom du projet *"),
                onChanged: (value) => setState(() {}), // Pour mettre à jour l'aperçu
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return "Le nom doit contenir au moins 3 caractères";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Champ Description (Multiligne)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description (optionnel)"),
                maxLines: 3,
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 24),

              // 4. Sélecteur de couleur (Wrap avec 8 cercles)
              const Text("Couleur du projet", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _predefinedColors.map((color) => _buildColorCircle(color)).toList(),
              ),

              const SizedBox(height: 40),

              // 5. Bouton d'action dynamique
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(isEditing ? "Modifier" : "Créer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour un cercle de couleur
  Widget _buildColorCircle(Color color) {
    bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
          boxShadow: [
            if (isSelected) BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)
          ],
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }

  // Widget d'aperçu de la ProjectCard
  Widget _buildProjectPreview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: _selectedColor, child: const Icon(Icons.folder, color: Colors.white)),
        title: Text(_nameController.text.isEmpty ? "Nom du projet" : _nameController.text),
        subtitle: Text(_descriptionController.text.isEmpty ? "Pas de description" : _descriptionController.text),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logique pour sauvegarder via le ProjectProvider
      Navigator.pop(context);
    }
  }
}