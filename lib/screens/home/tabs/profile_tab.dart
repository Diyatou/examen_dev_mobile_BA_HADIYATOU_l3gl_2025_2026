import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';
//import '../../providers/auth_provider.dart';
//import '../../providers/project_provider.dart';
//import '../../providers/task_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère les données des différents Providers
    final authProvider = Provider.of<AuthProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: Text("Utilisateur non connecté"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- SECTION AVATAR ET INFOS DE BASE ---
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Text(
              user.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user.email,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Chip(
              label: Text(
                "Inscrit le : ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}",
                style: const TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),

            // --- SECTION STATISTIQUES ---
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Mes Statistiques",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("Projets", projectProvider.projects.length.toString(), Colors.orange),
                _buildStatItem("Tâches", taskProvider.tasks.length.toString(), Colors.green),
              ],
            ),

            const SizedBox(height: 40),

            // --- BOUTON DE DÉCONNEXION ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context, authProvider),
                icon: const Icon(Icons.logout),
                label: const Text("Se déconnecter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget utilitaire pour les petits compteurs
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Dialogue de confirmation pour la déconnexion
  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Es-tu sûr de vouloir nous quitter ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              auth.logout();
              Navigator.pop(context); // Ferme le dialogue
            },
            child: const Text("Oui, me déconnecter", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}