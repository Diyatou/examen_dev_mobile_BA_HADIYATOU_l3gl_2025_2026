import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isOnboardingComplete = true; // Change à true pour tester l'onboarding

  bool get isInitialized => _isInitialized;
  bool get isOnboardingComplete => _isOnboardingComplete;

  Future<void> init() async {
    // Simule un chargement (lecture SharedPreferences, etc.)
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = false; // ON RESTE À FALSE ICI
    notifyListeners();
  }

  // Marque l'onboarding comme terminé
  Future<void> completeOnboarding() async {
    _isOnboardingComplete = true;

    // On s'assure que le stockage local est aussi à jour
    await StorageService.instance.setOnboardingComplete(true);

    notifyListeners(); // Informe le main.dart pour mettre à jour l'affichage
  }
}