import 'package:flutter/material.dart';
import 'package:sunu_task/core/constants/app_colors.dart';
import 'package:sunu_task/core/constants/app_strings.dart';

import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test des Widgets")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Test du CustomTextField
            const CustomTextField(
              label: "Nom d'utilisateur",
              prefixIcon: Icons.person,
              hint: "Entrez votre nom",
            ),
            const SizedBox(height: 20),

            // Test du CustomButton
            CustomButton(
              text: "MON BOUTON TEST",
              onPressed: () {
                print("Le bouton fonctionne !");
              },
            ),
            const SizedBox(height: 20),

            // Test du bouton en mode chargement
            const CustomButton(
              text: "Chargement...",
              isLoading: true,
            ),
          ],
        ),
      ),
    );
  }

}