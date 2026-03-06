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
  // Logique StorageService à venir...

  _isLoading = false;
  notifyListeners();
  }

  //[span_5](start_span)[span_6](start_span)// Connexion[span_5](end_span)[span_6](end_span)
  Future<bool> login(String email, String password) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  //[span_7](start_span)// Logique attendue : Chercher l'user dans StorageService[span_7](end_span)
  // Simulation pour l'instant :
  await Future.delayed(const Duration(seconds: 1));

  _isLoading = false;
  notifyListeners();
  return false; // Retourne true si trouvé
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