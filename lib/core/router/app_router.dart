// lib/core/router/app_router.dart
//
// ─── COMMENT ÇA MARCHE — EXPLICATION CLAIRE ──────────────────
//
// PROBLÈME PRÉCÉDENT : ShellRoute + shell widgets non définis
// → la navigation ne fonctionnait pas.
//
// SOLUTION : StatefulShellRoute.indexedStack
//
// StatefulShellRoute.indexedStack gère la navigation par onglets.
// Il donne accès à `navigationShell` qui contient :
//   • navigationShell.currentIndex → onglet actif
//   • navigationShell.goBranch(i) → changer d'onglet
//
// Chaque rôle a son propre StatefulShellRoute avec ses branches.
// Le builder du ShellRoute = le widget qui affiche la navigation
//   (BottomNav mobile, Sidebar tablette/desktop).
//
// STANDALONE = GoRoute simple, sans shell.
// Utilisé pour : splash, login, register (pas de nav).
//
// DÉPENDANCE : go_router: ^14.0.0 dans pubspec.yaml
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spadcameroun/core/utils/user_session.dart';
import 'package:spadcameroun/features/auth/presentation/screens/login_screen.dart';
import 'package:spadcameroun/features/auth/presentation/screens/register_screen.dart';
import 'package:spadcameroun/features/dashboard/avs/tabs/avs_home_tab.dart';
import 'package:spadcameroun/features/dashboard/avs/tabs/avs_localisation_tab.dart';
import 'package:spadcameroun/features/dashboard/avs/tabs/avs_patient_tab.dart';
import 'package:spadcameroun/features/dashboard/avs/tabs/avs_rapport_tab.dart';
import 'package:spadcameroun/features/public/presentation/screens/home_screen.dart';
import 'package:spadcameroun/features/public/presentation/screens/offres_screen.dart';
// import '../../utils/user_session.dart';
import 'route_names.dart';

// ── Pages ─────────────────────────────────────────────────────
import '../../features/splash/splash_screen.dart';
// import '../../features/public/screens/home_screen.dart';
// import '../../features/public/screens/offres_screen.dart';
// import '../../features/auth/screens/login_screen.dart';
// import '../../features/auth/screens/register_screen.dart';
import '../../features/dashboard/avs/avs_shell.dart';
import '../../features/dashboard/famille/famille_shell.dart';
import '../../features/dashboard/admin/admin_shell.dart';
import '../../features/dashboard/generic/generic_shell.dart';

class AppRouter {
  AppRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey:        navigatorKey,
    initialLocation:     RouteNames.splash,
    debugLogDiagnostics: true, // logs dans la console (désactiver en prod)

    // ─────────────────────────────────────────────────────────
    // REDIRECT GLOBAL — guard d'authentification
    //
    // Appelé avant CHAQUE navigation.
    // • null → laisser passer
    // • '/une-route' → rediriger
    //
    // RÈGLE IMPORTANTE : ne jamais rediriger depuis /splash
    // Le splash gère sa propre navigation via context.go()
    // ─────────────────────────────────────────────────────────
    redirect: (context, state) {
      final location    = state.matchedLocation;
      final isLoggedIn  = UserSession.instance.isLoggedIn;
      final role        = UserSession.instance.role;

      // 1. Splash → jamais rediriger, elle se gère seule
      if (location == RouteNames.splash) return null;

      // 2. Non connecté → accès page protégée → login
      if (!isLoggedIn && !RouteNames.isPublic(location)) {
        return RouteNames.login;
      }

      // 3. Connecté → sur page publique → dashboard du rôle
      if (isLoggedIn && RouteNames.isPublic(location)) {
        return RouteNames.homeForRole(role);
      }

      // 4. Laisser passer
      return null;
    },

    routes: [
      // ── SPLASH ─────────────────────────────────────────────
      // Standalone : Scaffold seul, sans nav
      GoRoute(
        path:    RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),

      // ── VISITEUR — StatefulShellRoute avec 2 onglets ───────
      // Onglet 0 = Home (/), Onglet 1 = Offres (/offres)
      // L'AppBar de home a les boutons Connexion/S'inscrire
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => _VisitorShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.home,
              builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RouteNames.offres,
              builder: (_, __) => const OffresScreen()),
          ]),
        ],
      ),

      // ── AUTH — Standalone (SANS nav ni sidebar) ────────────
      GoRoute(path: RouteNames.login,    builder: (_, __) => const LoginScreen()),
      GoRoute(path: RouteNames.register, builder: (_, __) => const RegisterScreen()),

      // ── AVS ─────────────────────────────────────────────────
      // StatefulShellRoute avec 4 onglets
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => AvsShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.avs,
            builder: (_, __) => const AvsHomeTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.avsPatient,
            builder: (_, __) => const AvsPatientTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.avsRapports,
            builder: (_, __) => const AvsRapportsTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.avsLocalisation,
            builder: (_, __) => const AvsLocalisationTab())]),
        ],
      ),

      // ── FAMILLE ─────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => FamilleShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.famille,
            builder: (_, __) => const FamilleHomeTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.familleSante,
            builder: (_, __) => const FamilleSanteTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.familleRapports,
            builder: (_, __) => const FamilleRapportsTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.familleAlertes,
            builder: (_, __) => const FamilleAlertesTab())]),
        ],
      ),

      // ── ADMIN ───────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => AdminShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.admin,
            builder: (_, __) => const AdminHomeTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.adminUsers,
            builder: (_, __) => const AdminUsersTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.adminStats,
            builder: (_, __) => const AdminStatsTab())]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.adminActualites,
            builder: (_, __) => const AdminActualitesTab())]),
        ],
      ),

      // ── COORD PERSONNEL ─────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) =>
            GenericShell(shell: shell, role: 'coordPersonnel'),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.coordPersonnel,
            builder: (_, __) => const GenericTab(title: 'Accueil Coord. Personnel', icon: Icons.home))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.coordPersonnelAvs,
            builder: (_, __) => const GenericTab(title: 'Gestion AVS', icon: Icons.badge))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.coordPersonnelPat,
            builder: (_, __) => const GenericTab(title: 'Patients', icon: Icons.elderly))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.coordPersonnelPay,
            builder: (_, __) => const GenericTab(title: 'Paiements', icon: Icons.payments))]),
        ],
      ),

      // ── COORD SANTÉ ─────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) =>
            GenericShell(shell: shell, role: 'coordSante'),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.coordSante,
            builder: (_, __) => const GenericTab(title: 'Accueil Coord. Santé', icon: Icons.home))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.coordSantePlan,
            builder: (_, __) => const GenericTab(title: 'Plannings', icon: Icons.calendar_month))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.coordSanteAffect,
            builder: (_, __) => const GenericTab(title: 'Affectations', icon: Icons.assignment))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.coordSanteCarte,
            builder: (_, __) => const GenericTab(title: 'Carte GPS', icon: Icons.map))]),
        ],
      ),

      // ── MÉDECIN ─────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) =>
            GenericShell(shell: shell, role: 'medecin'),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.medecin,
            builder: (_, __) => const GenericTab(title: 'Accueil Médecin', icon: Icons.home))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.medecinRapports,
            builder: (_, __) => const GenericTab(title: 'Rapports patients', icon: Icons.description))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.medecinPrescription,
            builder: (_, __) => const GenericTab(title: 'Prescriptions', icon: Icons.medication))]),
        ],
      ),
    ],

    errorBuilder: (_, __) => const _NotFoundScreen(),
  );
}

// ─────────────────────────────────────────────────────────────
// VISITOR SHELL — Scaffold avec BottomNav 2 onglets
// ─────────────────────────────────────────────────────────────
class _VisitorShell extends StatelessWidget {
  const _VisitorShell({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body = le contenu de l'onglet actif (HomeScreen ou OffresScreen)
      body: shell,
      bottomNavigationBar: NavigationBar(
        // shell.currentIndex = onglet actif calculé par GoRouter
        selectedIndex: shell.currentIndex,
        // shell.goBranch(i) = naviguer vers l'onglet i
        // C'EST LE FIX DE LA NAVIGATION — GoRouter gère tout
        onDestinationSelected: (i) => shell.goBranch(i),
        destinations: const [
          NavigationDestination(
            icon:         Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label:        'Accueil',
          ),
          NavigationDestination(
            icon:         Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label:        'Offres',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PAGE 404
// ─────────────────────────────────────────────────────────────
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('404', style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Page introuvable'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(RouteNames.home),
            child: const Text('Retour à l\'accueil'),
          ),
        ]),
      ),
    );
  }
}
