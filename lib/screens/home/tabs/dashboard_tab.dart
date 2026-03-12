import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
// Importe tes futurs providers de projets et tâches ici
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  // 1. Logique du message de bienvenue selon l'heure
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Bonjour";
    if (hour < 18) return "Bon après-midi";
    return "Bonsoir";
  }

  @override
  Widget build(BuildContext context) {
    // On écoute l'AuthProvider pour le nom de l'utilisateur
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.currentUser?.name ?? "Utilisateur";

    return RefreshIndicator(
      onRefresh: () async {
        // Logique pour rafraîchir tes données (appel API ou Storage)
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message de bienvenue
            Text(
              "${_getGreeting()}, $userName 👋",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // 2. Cartes de statistiques
            // Ici on utiliserait idéalement un ListenableBuilder pour TaskProvider
            const Text("Statistiques", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildStatsGrid(),

            const SizedBox(height: 30),

            // 3. Liste des projets récents
            const Text("Projets récents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildRecentProjects(),
          ],
        ),
      ),
    );
  }

  // Widget pour la grille de statistiques
  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        // Carte pour le total des projets (on peut garder une couleur neutre/bleue)
        _statCard("Projets", "5", AppColors.statusInProgress),

        // Cartes utilisant TES couleurs de statut
        _statCard("À faire", "3", AppColors.statusTodo),
        _statCard("En cours", "2", AppColors.statusInProgress),
        _statCard("Terminées", "10", AppColors.statusDone),
      ],
    );
  }

  Widget _statCard(String label, String count, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(color: color.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildRecentProjects() {
    // Liste factice en attendant ton ProjectProvider
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.folder)),
            title: Text("Projet SunuTask ${index + 1}"),
            subtitle: const Text("Dernière modification : il y a 2h"),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}