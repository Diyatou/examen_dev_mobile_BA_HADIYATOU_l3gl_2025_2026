import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flintl/intl.dart'; // Pour formater la date d'inscription
import '../../../providers/auth_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    // Formater la date d'inscription (ex: 12 mars 2026)
    final String registrationDate = user?.createdAt != null
        ? DateFormat('dd MMMM yyyy', 'fr_FR').format(user!.createdAt)
        : "Date inconnue";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 1. Avatar, Nom et Email
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? "U",
                    style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? "Utilisateur",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? "",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Divider(),

          // 2. Date d'inscription
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("Membre depuis"),
            trailing: Text(registrationDate),
          ),

          const SizedBox(height: 24),

          // 3. Statistiques personnelles
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Vos Statistiques", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSimpleStatCard("Projets", "5", Colors.blue),
              const SizedBox(width: 16),
              _buildSimpleStatCard("Tâches", "15", Colors.green),
            ],
          ),

          const SizedBox(height: 40),

          // 4. Bouton de déconnexion
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Logique de déconnexion
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("Se déconnecter", style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}