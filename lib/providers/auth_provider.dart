import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';

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

  // ... dans ta méthode login ...
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Petit délai pour simuler le réseau et laisser l'UI respirer
      await Future.delayed(const Duration(milliseconds: 500));

      // 1. Récupération des utilisateurs
      List<User> users = StorageService.instance.getUsers();

      // 2. Recherche sécurisée
      // On utilise any() avant firstWhere pour éviter que firstWhere ne plante si rien n'est trouvé
      bool exists = users.any((u) => u.email == email && u.password == password);

      if (exists) {
        _currentUser = users.firstWhere((u) => u.email == email && u.password == password);
        return true;
      } else {
        _error = "Email ou mot de passe incorrect";
        return false;
      }
    } catch (e) {
      _error = "Une erreur est survenue lors de la connexion";
      debugPrint("Erreur Login: $e"); // Pour voir le vrai problème dans la console
      return false;
    } finally {
      // CE BLOC S'EXÉCUTE TOUJOURS (Succès ou Échec)
      // C'est ce qui garantit que le bouton s'arrête de charger
      _isLoading = false;
      notifyListeners();
    }
  }

// ... dans ta méthode register ...
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    List<User> users = StorageService.instance.getUsers();

    // 1. Vérifier si l'email existe déjà
    if (users.any((u) => u.email == email)) {
      _error = "Cet email est déjà utilisé";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // 2. Créer l'objet User avec un ID généré par UUID
    final newUser = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
      password: password,
    );

    // 3. Sauvegarder
    users.add(newUser);
    await StorageService.instance.saveUsers(users);

    // 4. Définir comme utilisateur courant
    _currentUser = newUser;
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