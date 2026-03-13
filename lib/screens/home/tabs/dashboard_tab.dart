import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';


class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  // Logique pour le message de bienvenue selon l'heure
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Bonjour";
    if (hour < 18) return "Bon après-midi";
    return "Bonsoir";
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // On utilise ListenableBuilder pour écouter les changements de données
    return ListenableBuilder(
      listenable: Listenable.merge([
        Provider.of<ProjectProvider>(context, listen: false),
        Provider.of<TaskProvider>(context, listen: false),
      ]),
      builder: (context, _) {
        final projectProvider = Provider.of<ProjectProvider>(context);
        final taskProvider = Provider.of<TaskProvider>(context);

        // Calcul des statistiques des tâches

        final todoCount = taskProvider.tasks.where((t) =>
        t.status == 'À faire' || t.status == 'Todo').length;

        final inProgressCount = taskProvider.tasks.where((t) =>
        t.status == 'En cours' || t.status == 'In Progress').length;

        final doneCount = taskProvider.tasks.where((t) =>
        t.status == 'Terminée' || t.status == 'Done').length;
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              // Action de rafraîchissement
              await projectProvider.loadProjects();
              await taskProvider.loadTasks();
            },
            child: CustomScrollView(
              slivers: [
                // --- BARRE DE BIENVENUE ---
                SliverAppBar(
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "${_getGreeting()}, ${user?.name ?? 'Utilisateur'} 👋",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    centerTitle: false,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tes Statistiques", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),

                        // --- CARTES DE STATISTIQUES ---
                        Row(
                          children: [
                            _buildStatCard("Projets", projectProvider.projects.length.toString(), Colors.blue),
                            _buildStatCard("À faire", todoCount.toString(), Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildStatCard("En cours", inProgressCount.toString(), Colors.purple),
                            _buildStatCard("Terminées", doneCount.toString(), Colors.green),
                          ],
                        ),

                        const SizedBox(height: 30),
                        const Text("Projets récents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // --- LISTE DES PROJETS RÉCENTS ---
                projectProvider.projects.isEmpty
                    ? const SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Aucun projet pour le moment"),
                  )),
                )
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      // On affiche les 3 derniers projets par exemple
                      final projects = projectProvider.projects.reversed.toList();
                      if (index >= projects.length || index >= 3) return null;
                      final project = projects[index];
                      return ListTile(
                        leading: const Icon(Icons.folder_special, color: Colors.blue),
                        title: Text(project.name),
                        subtitle: Text("${project.description}"),
                        trailing: const Icon(Icons.chevron_right),
                      );
                    },
                    childCount: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget pour créer les cartes de stats
  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 5),
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}