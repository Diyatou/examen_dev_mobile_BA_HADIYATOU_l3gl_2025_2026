import 'package:flutter/material.dart';

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

  void completeInitialization() {
    _isInitialized = true;
    notifyListeners(); // C'est CE signal qui déclenche le changement dans le main
  }
}