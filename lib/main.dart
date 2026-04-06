// lib/main.dart
//
// ─── POINT D'ENTRÉE ──────────────────────────────────────────
// AppShell = source UNIQUE de vérité pour :
//   • _navIndex     → quelle page est affichée
//   • _themeMode    → light / dark
//   • session       → UserSession.instance (auth)
//
// POURQUOI LA NAV NE MARCHAIT PAS AVANT :
//   Chaque page gérait son propre _currentNavIndex.
//   Quand la page tapait l'item 1, elle mettait à jour
//   SON propre état, mais le IndexedStack dans TestRoot
//   ne savait pas qu'il fallait changer de page.
//
// FIX : AppShell possède _navIndex et le passe à chaque page.
//   La page ne fait qu'appeler onNavTap(i) → AppShell réagit
//   → rebuild → la bonne page s'affiche.
// ─────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/user_session.dart';
import 'shared/models/spad_nav_item.dart';
import 'shared/widgets/spad_ai_assistant.dart';

// Pages visiteur
import 'features/public/presentation/screens/home_screen.dart';
import 'features/public/presentation/screens/offres_screen.dart';
import 'features/auth/presentation/screens/auth_hub_screen.dart';

// Dashboards
import 'features/dashboard/avs/avs_dashboard_screen.dart';
import 'features/dashboard/famille/famille_dashboard_screen.dart';
import 'features/dashboard/admin/admin_dashboard_screen.dart';

void main() {
  runApp(const SpadApp());
}

// ─────────────────────────────────────────────────────────────
// SPAD APP — racine, gère uniquement le thème
// ─────────────────────────────────────────────────────────────
class SpadApp extends StatefulWidget {
  const SpadApp({super.key});
  @override
  State<SpadApp> createState() => _SpadAppState();
}

class _SpadAppState extends State<SpadApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                      'SPAD Cameroun',
      theme:                      AppTheme.lightTheme,
      darkTheme:                  AppTheme.darkTheme,
      themeMode:                  _themeMode,
      debugShowCheckedModeBanner: false,
      home: AppShell(
        themeMode:     _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// APP SHELL — source unique de vérité pour la navigation
// ─────────────────────────────────────────────────────────────
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode      themeMode;
  final VoidCallback   onToggleTheme;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // ── État global navigation ─────────────────────────────────
  int _navIndex = 0;

  // ── Callbacks ─────────────────────────────────────────────

  /// Appelé par n'importe quelle page quand l'utilisateur
  /// tape un item de la BottomNav ou de la Sidebar.
  /// AppShell rebuild → la bonne page s'affiche.
  void _handleNavTap(int index) {
    setState(() => _navIndex = index);
  }

  /// Appelé par LoginScreen après authentification réussie.
  /// Met à jour la session et remet l'index à 0 (home du rôle).
  void _handleLogin({
    required String role,
    required String name,
    String email = '',
  }) {
    UserSession.instance.login(role: role, name: name, email: email);
    setState(() => _navIndex = 0);
  }

  /// Appelé par le bouton déconnexion dans SpadSidebar / menu.
  void _handleLogout() {
    UserSession.instance.logout();
    setState(() => _navIndex = 0);
  }

  // ── Construction de la page courante ──────────────────────

  Widget _buildCurrentPage() {
    final session = UserSession.instance;

    if (!session.isLoggedIn) {
      // ── Pages visiteur ──────────────────────────────────
      switch (_navIndex) {
        case 0:
          return HomeScreen(
            currentIndex: _navIndex,
            onNavTap:     _handleNavTap,
          );
        case 1:
          return OffresScreen(
            currentIndex: _navIndex,
            onNavTap:     _handleNavTap,
          );
        case 2:
          return AuthHubScreen(
            currentIndex: _navIndex,
            onNavTap:     _handleNavTap,
            onLogin:      _handleLogin,
          );
        default:
          return HomeScreen(currentIndex: 0, onNavTap: _handleNavTap);
      }
    }

    // ── Pages par rôle (connecté) ──────────────────────────
    switch (session.role) {
      case UserRole.avs:
        return AvsDashboardScreen(
          currentIndex: _navIndex,
          onNavTap:     _handleNavTap,
          onLogout:     _handleLogout,
        );
      case UserRole.famille:
        return FamilleDashboardScreen(
          currentIndex: _navIndex,
          onNavTap:     _handleNavTap,
          onLogout:     _handleLogout,
        );
      case UserRole.admin:
        return AdminDashboardScreen(
          currentIndex: _navIndex,
          onNavTap:     _handleNavTap,
          onLogout:     _handleLogout,
        );
      // Autres rôles → dashboard générique pour l'instant
      default:
        return _GenericDashboard(
          onLogout: _handleLogout,
          navIndex: _navIndex,
          onNavTap: _handleNavTap,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Page active ──────────────────────────────────────
        _buildCurrentPage(),

        // ── Bouton assistant IA SPAD ─────────────────────────
        // Remplace l'ancien bouton dark/light mode.
        // Positionné en bas à droite, au-dessus de la BottomNav.
        Positioned(
          bottom: 80,
          right:  16,
          child: SpadAIAssistant(
            themeMode:     widget.themeMode,
            onToggleTheme: widget.onToggleTheme,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DASHBOARD GÉNÉRIQUE — placeholder pour les rôles non codés
// ─────────────────────────────────────────────────────────────
class _GenericDashboard extends StatelessWidget {
  const _GenericDashboard({
    required this.onLogout,
    required this.navIndex,
    required this.onNavTap,
  });

  final VoidCallback      onLogout;
  final int               navIndex;
  final ValueChanged<int> onNavTap;

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;
    final scheme  = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard — ${session.role}'),
        actions: [
          IconButton(
            icon:     const Icon(Icons.logout),
            tooltip:  'Déconnexion',
            onPressed: onLogout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: scheme.primary),
            const SizedBox(height: 16),
            Text('Dashboard ${session.role}',
              style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('En cours de développement',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed:  onLogout,
              icon:       const Icon(Icons.logout),
              label:      const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}