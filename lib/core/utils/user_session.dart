// lib/core/utils/user_session.dart
//
// ─── SESSION UTILISATEUR ─────────────────────────────────────
// Gère l'état d'authentification GLOBAL de l'app.
// Phase 2 : stockage en mémoire (perdu au redémarrage)
// Phase 4 : remplacé par flutter_secure_storage + Bloc
//
// UTILISATION :
//   UserSession.instance.login(role: 'avs', name: 'Jean')
//   UserSession.instance.isLoggedIn  → true
//   UserSession.instance.role        → 'avs'
//
// POUR LA PERSISTENCE (Phase 4) :
//   Ajouter dans pubspec.yaml :
//     shared_preferences: ^2.3.0
//     flutter_secure_storage: ^9.0.0
//   Stocker le token JWT dans SecureStorage
//   Au démarrage, lire le token et valider avec le backend
// ─────────────────────────────────────────────────────────────

class UserSession {
  // Singleton — une seule instance dans toute l'app
  UserSession._();
  static final UserSession instance = UserSession._();

  // ── État en mémoire ────────────────────────────────────────
  bool   _isLoggedIn = false;
  String _role       = 'visitor';  // visitor | famille | avs | admin | coordPersonnel | coordSante | medecin
  String _name       = '';
  String _email      = '';
  String _token      = '';

  // ── Getters publics ────────────────────────────────────────
  bool   get isLoggedIn => _isLoggedIn;
  String get role       => _role;
  String get name       => _name;
  String get email      => _email;
  String get token      => _token;

  // Initiales pour l'avatar (ex: "Jean Dupont" → "JD")
  String get initials {
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _name.isNotEmpty ? _name[0].toUpperCase() : 'U';
  }

  // ── Actions ────────────────────────────────────────────────

  /// Appele après validation du backend
  void login({
    required String role,
    required String name,
    String email = '',
    String token = '',
  }) {
    _isLoggedIn = true;
    _role       = role;
    _name       = name;
    _email      = email;
    _token      = token;
    // Phase 4 : await _secureStorage.write(key: 'token', value: token);
  }

  void logout() {
    _isLoggedIn = false;
    _role       = 'visitor';
    _name       = '';
    _email      = '';
    _token      = '';
    // Phase 4 : await _secureStorage.delete(key: 'token');
  }
}

// ─────────────────────────────────────────────────────────────
// RÔLES CONSTANTS — évite les typos partout dans l'app
// ─────────────────────────────────────────────────────────────
class UserRole {
  UserRole._();
  static const String visitor        = 'visitor';
  static const String famille        = 'famille';
  static const String avs            = 'avs';
  static const String admin          = 'admin';
  static const String coordPersonnel = 'coordPersonnel';
  static const String coordSante     = 'coordSante';
  static const String medecin        = 'medecin';
}