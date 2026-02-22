import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // ChangeNotifier permet aux ecrans d'ecouter les changements
  bool _isOnboardingComplete = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  // Getters publics (à compléter)
  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  // Méthodes à implémenter

  // Charge l'état depuis le stockage local
  Future<void> init() async {
    _isLoading = true;
    notifyListeners(); /// notifyListener est l'alarme qui se declenche les changements dès que la
    /// fonction est appelé :exemple passe de true à false

    // TODO: Lire la valeur dans shared_preferences plus tard

    _isInitialized = true;
    _isLoading = false;
    notifyListeners();
  }

  // Marque l'onboarding comme terminé
  Future<void> completeOnboarding() async {
    _isOnboardingComplete = true;
    // TODO: Sauvegarder dans shared_preferences
    notifyListeners();
  }

  // Réinitialise l'onboarding (pour le test)
  Future<void> resetOnboarding() async {
    _isOnboardingComplete = false;
    // TODO: Sauvegarder dans shared_preferences
    notifyListeners();
  }
}