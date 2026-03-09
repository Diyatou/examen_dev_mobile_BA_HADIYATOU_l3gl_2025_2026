import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

/**
 * Pattern Singleton:
 * Pour avoir une seule instance
 */
class StorageService {
  //===== Singleton ==========
  /// Instance Unique (privee)
  static StorageService? _instance;

  /// Getter pour acceder a l'instance
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Constructeur prive
  StorageService._();

  //===== SharedPreferences ==========
  /**
   * SharedPreferences utilise des opérations asynchrones
   * car il lit/ecrtit sur le disque
   *
   * Le mot-cle await attend que l'operation se termine
   * La fonction doit etre marque async et retourner un Future
   * Les variables doivent être marqué par late
   */
  late SharedPreferences _prefs;

  /// Indicateur d'initialisation
  bool _initialized = false;

  Future<void> init() async {
    if(_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // ======== Cles de Stockage =========
  static const String _keyOnboardingConmplete = 'onboarding_complete';


  bool get isOnboardingComplete {
    return _prefs.getBool(_keyOnboardingConmplete) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_keyOnboardingConmplete, value);
  }

  Future<void> clear() async {
    await _prefs?.clear(); // Cette ligne vide toute la mémoire de l'appli
  }

  // Dans lib/services/storage_service.dart

// Sauvegarder les infos de l'utilisateur séparément
  Future<void> saveUserData(String name, String email, String password) async {
    await _prefs?.setString('user_name', name);
    await _prefs?.setString('user_email', email);
    await _prefs?.setString('user_password', password);
  }

// Récupérer uniquement l'email pour le test de connexion
  String? getSavedEmail() => _prefs?.getString('user_email');
  String? getSavedPassword() => _prefs?.getString('user_password');
  String? getSavedName() => _prefs?.getString('user_name');

  // Récupérer la liste de tous les inscrits
  List<User> getUsers() {
    final String? usersJson = _prefs?.getString('all_users');
    if (usersJson == null) return [];

    final List<dynamic> decodedList = jsonDecode(usersJson);
    return decodedList.map((item) => User.fromMap(item)).toList();
  }

// 2. Sauvegarder la liste complète (après un register)
  Future<void> saveUsers(List<User> users) async {
    final String encodedData = jsonEncode(users.map((u) => u.toMap()).toList());
    await _prefs?.setString('all_users', encodedData);
  }

}