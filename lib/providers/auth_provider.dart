import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  //[span_2](start_span) ; // Propriétés privées[span_2](end_span)
  User? _currentUser ;
  bool _isLoading = false;
  String? _error;

  //[span_3](start_span)// Getters publics[span_3](end_span)
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  //[span_4](start_span)// Initialisation : charger l'utilisateur depuis le stockage[span_4](end_span)
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    // FORÇAGE ICI : On s'assure que l'utilisateur est bien vide au début
    _currentUser = null;

    // Plus tard, on ira chercher dans StorageService ici

    _isLoading = false;
    notifyListeners(); // C'est ce notify qui va dire au main.dart d'afficher le Login !
  }

  //[span_5](start_span)[span_6](start_span)// Connexion[span_5](end_span)[span_6](end_span)

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    // Simulation de validation (on accepte n'importe quoi pour l'instant)
    if (email.isNotEmpty && password.length >= 6) {
      // On crée un utilisateur fictif pour "allumer" isAuthenticated
      _currentUser = User(
        id: '1',
        name: 'Utilisateur Test',
        email: email, password: '',
      );

      _isLoading = false;
      notifyListeners();
      return true; // LA CONNEXION RÉUSSIT !
    } else {
      _error = "Email ou mot de passe incorrect";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //[span_8](start_span)// Inscription[span_8](end_span)
  Future<bool> register(String name, String email, String password) async {
  _isLoading = true;
  notifyListeners();
  // Logique UUID et StorageService à venir...
  _isLoading = false;
  notifyListeners();
  return true;
  }

  void logout() {
  _currentUser = null;
  notifyListeners();
  }

  void clearError() {
  _error = null;
  notifyListeners();
  }

}