import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Liste des pages pour l'IndexedStack
  final List<Widget> _pages = [
    const Center(child: Text("Dashboard")), // On créera des fichiers séparés plus tard
    const Center(child: Text("Projets")),
    const Center(child: Text("Tâches")),
    const Center(child: Text("Profil")),
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

      // 3. FLOATING ACTION BUTTON (Visible uniquement sur Dashboard et Projets)
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? FloatingActionButton(
        onPressed: () { /* Action pour nouveau projet */ },
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