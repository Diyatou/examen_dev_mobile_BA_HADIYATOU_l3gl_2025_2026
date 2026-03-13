import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters publics
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// INITIALISATION : Tente de reconnecter l'utilisateur automatiquement
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. On cherche l'ID de l'utilisateur sauvegardé
      final String? savedUserId = StorageService.instance.getString('logged_user_id');

      if (savedUserId != null) {
        // 2. On récupère la liste des inscrits
        List<User> users = StorageService.instance.getUsers();

        // 3. On cherche si cet ID existe toujours
        if (users.any((u) => u.id == savedUserId)) {
          _currentUser = users.firstWhere((u) => u.id == savedUserId);
        }
      }
    } catch (e) {
      debugPrint("Erreur lors de l'initialisation Auth: $e");
      _currentUser = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// CONNEXION
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // On force une petite attente pour laisser le stockage se réveiller
      await Future.delayed(const Duration(milliseconds: 800));

      List<User> users = StorageService.instance.getUsers();

      // DEBUG : On regarde si on voit des gens dans la liste
      print("Tentative de login. Nombre d'utilisateurs inscrits trouvés : ${users.length}");

      bool exists = users.any((u) => u.email == email && u.password == password);

      if (exists) {
        _currentUser = users.firstWhere((u) => u.email == email && u.password == password);
        await StorageService.instance.saveString('logged_user_id', _currentUser!.id);
        print("Connexion réussie pour : ${_currentUser!.name}");
        return true;
      } else {
        _error = "Email ou mot de passe incorrect (Vérifie si tu t'es bien inscrit)";
        return false;
      }
    } catch (e) {
      _error = "Erreur technique : $e";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// INSCRIPTION
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. On récupère les utilisateurs déjà existants
      List<User> users = StorageService.instance.getUsers();

      // 2. Vérification d'unicité
      if (users.any((u) => u.email == email)) {
        _error = "Cet email est déjà utilisé";
        return false;
      }

      // 3. Création du nouvel utilisateur
      final newUser = User(
        id: const Uuid().v4(),
        name: name,
        email: email,
        password: password,
      );

      // 4. SAUVEGARDE CRITIQUE : On attend que ce soit écrit sur le disque
      users.add(newUser);
      await StorageService.instance.saveUsers(users); // On sauve la liste
      await StorageService.instance.saveString('logged_user_id', newUser.id); // On sauve la session

      _currentUser = newUser;
      print("Inscription réussie et sauvegardée pour : ${newUser.email}");
      return true;
    } catch (e) {
      _error = "Erreur lors de l'enregistrement : $e";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// DÉCONNEXION
  Future<void> logout() async {
    _currentUser = null;
    // On efface l'ID pour que init() ne nous reconnecte pas au prochain coup
    await StorageService.instance.remove('logged_user_id');
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}