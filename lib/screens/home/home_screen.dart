import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/screens/home/tabs/dashboard_tab.dart';
import 'package:sunu_task/screens/home/tabs/profile_tab.dart';
import 'package:sunu_task/screens/home/tabs/projects_tab.dart';
import 'package:sunu_task/screens/home/tabs/tasks_tab.dart';
import '../../providers/auth_provider.dart';
import '../projects/project_form_screen.dart';
import '../tasks/task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Liste des pages pour l'IndexedStack
  // Dans HomeScreen.dart
  final List<Widget> _pages = [
    const DashboardTab(),
    const ProjectsTab(),
    const TasksTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("SunuTask"),
      ),

      // 1. NAVIGATION DRAWER
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.name.substring(0, 1).toUpperCase() ?? "U",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              accountName: Text(user?.name ?? "Utilisateur"),
              accountEmail: Text(user?.email ?? ""),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              selected: _selectedIndex == 0,
              onTap: () { _onItemTapped(0); Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Projets"),
              selected: _selectedIndex == 1,
              onTap: () { _onItemTapped(1); Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Tâches"),
              selected: _selectedIndex == 2,
              onTap: () { _onItemTapped(2); Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profil"),
              selected: _selectedIndex == 3,
              onTap: () { _onItemTapped(3); Navigator.pop(context); },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Déconnexion", style: TextStyle(color: Colors.red)),
              onTap: () {
                // Logique de déconnexion à appeler ici
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),

      // 2. CORPS AVEC INDEXEDSTACK
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),


      // 3. FLOATING ACTION BUTTON (Maintenant visible sur Dashboard, Projets ET Tâches)
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 2)
          ? FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 1 || _selectedIndex == 0) {
            // Si on est sur Dashboard ou Projets -> Formulaire Projet
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormScreen()),
            );
          } else if (_selectedIndex == 2) {
            // Si on est sur l'onglet Tâches -> Formulaire Tâche
            // Note : Ici on ne passe pas de projectId car on est sur la liste globale
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskFormScreen(projectId: '',)),
            );
          }
        },
        child: const Icon(Icons.add),
      )
          : null,

      // 4. BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Pour garder les icônes et labels visibles
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Projets"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tâches"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}