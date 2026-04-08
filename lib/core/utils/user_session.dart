// lib/core/utils/user_session.dart
// ─── SINGLETON SESSION UTILISATEUR ───────────────────────────
// Stockage EN MÉMOIRE pour l'instant.
// Phase 7 : remplacer par flutter_secure_storage + token JWT.
// ─────────────────────────────────────────────────────────────
class UserSession {
  UserSession._();
  static final instance = UserSession._();

  bool   _isLoggedIn = false;
  String _role       = '';
  String _name       = '';
  String _email      = '';

  bool   get isLoggedIn => _isLoggedIn;
  String get role       => _role;
  String get name       => _name;
  String get email      => _email;
  String get initials {
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return _name.isNotEmpty ? _name[0].toUpperCase() : '?';
  }

  void login({required String role, required String name, String email = ''}) {
    _isLoggedIn = true;
    _role  = role;
    _name  = name;
    _email = email;
  }

  void logout() {
    _isLoggedIn = false;
    _role  = '';
    _name  = '';
    _email = '';
  }
}

class UserRole {
  UserRole._();
  static const visitor        = 'visitor';
  static const famille        = 'famille';
  static const avs            = 'avs';
  static const admin          = 'admin';
  static const coordPersonnel = 'coordPersonnel';
  static const coordSante     = 'coordSante';
  static const medecin        = 'medecin';
}
