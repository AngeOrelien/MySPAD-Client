// lib/core/bloc/auth/auth_bloc.dart
// ─── AUTH BLOC ────────────────────────────────────────────────
// Gère l'état d'auth avec le pattern Events → States.
// pubspec.yaml : flutter_bloc: ^8.1.6, equatable: ^2.0.5
// ─────────────────────────────────────────────────────────────
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/user_session.dart';

// ══════════════════ EVENTS ════════════════════════════════════
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override List<Object?> get props => [];
}

/// Déclenché au démarrage de l'app pour vérifier si déjà connecté
class AuthCheckRequested extends AuthEvent { const AuthCheckRequested(); }

/// L'utilisateur clique "Se connecter"
class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});
  final String email, password;
  @override List<Object?> get props => [email, password];
}

/// L'utilisateur clique "S'inscrire" (familles seulement)
class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.nom,
    required this.email,
    required this.telephone,
    required this.password,
  });
  final String nom, email, telephone, password;
  @override List<Object?> get props => [nom, email, telephone, password];
}

/// L'utilisateur clique "Déconnexion"
class AuthLogoutRequested extends AuthEvent { const AuthLogoutRequested(); }

// ══════════════════ STATES ════════════════════════════════════
abstract class AuthState extends Equatable {
  const AuthState();
  @override List<Object?> get props => [];
}

class AuthInitial       extends AuthState { const AuthInitial(); }
class AuthLoading       extends AuthState { const AuthLoading(); }
class AuthUnauthenticated extends AuthState { const AuthUnauthenticated(); }

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.role, required this.name, this.email = ''});
  final String role, name, email;
  @override List<Object?> get props => [role, name, email];
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
  @override List<Object?> get props => [message];
}

class AuthRegisterSuccess extends AuthState { const AuthRegisterSuccess(); }

// ══════════════════ BLOC ═════════════════════════════════════
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  // ── Comptes démo (Phase 2) ────────────────────────────────
  static const _demoAccounts = {
    'avs@spad.cm':       {'role': 'avs',           'name': 'Jean Ngono',     'password': 'avs1234'},
    'famille@spad.cm':   {'role': 'famille',        'name': 'Marie Famille',  'password': 'fam1234'},
    'admin@spad.cm':     {'role': 'admin',          'name': 'Admin SPAD',     'password': 'admin1234'},
    'coord@spad.cm':     {'role': 'coordPersonnel', 'name': 'Alice Coord',    'password': 'coord1234'},
    'sante@spad.cm':     {'role': 'coordSante',     'name': 'Paul Santé',     'password': 'sante1234'},
    'medecin@spad.cm':   {'role': 'medecin',        'name': 'Dr. Kamga',      'password': 'med1234'},
  };

  Future<void> _onCheck(AuthCheckRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    // Phase 7 : lire token depuis flutter_secure_storage ici
    final s = UserSession.instance;
    if (s.isLoggedIn) {
      emit(AuthAuthenticated(role: s.role, name: s.name, email: s.email));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    // Phase 7 : remplacer par POST /api/auth/login
    final acc = _demoAccounts[e.email.toLowerCase().trim()];
    if (acc != null && acc['password'] == e.password) {
      UserSession.instance.login(role: acc['role']!, name: acc['name']!, email: e.email);
      emit(AuthAuthenticated(role: acc['role']!, name: acc['name']!, email: e.email));
    } else {
      emit(const AuthError('Email ou mot de passe incorrect.'));
    }
  }

  Future<void> _onRegister(AuthRegisterRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 1000));
    // Phase 7 : POST /api/auth/register → crée compte famille "pending"
    emit(const AuthRegisterSuccess());
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    UserSession.instance.logout();
    // Phase 7 : supprimer le token de flutter_secure_storage
    emit(const AuthUnauthenticated());
  }
}
