// lib/main.dart
//
// ─── POINT D'ENTRÉE — TEST PHASE 2 ──────────────────────────
// Ce main.dart est temporaire pour tester la Phase 2.
// Il sera remplacé par le vrai main.dart en Phase 3
// avec GoRouter et le système d'authentification.
//
// POUR TESTER :
//   flutter run -d chrome      → test responsive web
//   flutter run -d android     → test mobile
//   Sur Chrome : redimensionne la fenêtre pour voir
//   la nav changer entre BottomNav / Sidebar
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// Thème Phase 1
import 'core/theme/app_theme.dart';

// Pages visiteur Phase 2
import 'features/public/presentation/screens/home_screen.dart';
import 'features/public/presentation/screens/offres_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';

void main() {
  // runApp() démarre l'application Flutter
  // Il prend le widget racine en paramètre
  runApp(const SpadApp());
}

class SpadApp extends StatefulWidget {
  const SpadApp({super.key});

  @override
  State<SpadApp> createState() => _SpadAppState();
}

// StatefulWidget car on gère le ThemeMode (light/dark)
class _SpadAppState extends State<SpadApp> {

  // ThemeMode.system : suit le mode du système d'exploitation
  // Change en .light ou .dark pour forcer
  ThemeMode _themeMode = ThemeMode.system;

  // Callback pour le bouton bascule light/dark dans le test
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:      'SPAD Cameroun',

      // Connecte les thèmes Phase 1
      theme:      AppTheme.lightTheme,
      darkTheme:  AppTheme.darkTheme,
      themeMode:  _themeMode,

      // Masque le bandeau rouge "DEBUG" en haut à droite
      debugShowCheckedModeBanner: false,

      // Page de départ — le TestRoot enveloppe la navigation
      home: TestRoot(onToggleTheme: _toggleTheme),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TEST ROOT — gère la navigation entre les 3 pages visiteur
// sans GoRouter (sera ajouté Phase 3)
// ─────────────────────────────────────────────────────────────
class TestRoot extends StatefulWidget {
  const TestRoot({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;

  @override
  State<TestRoot> createState() => _TestRootState();
}

class _TestRootState extends State<TestRoot> {

  // Index de la page affichée (0=Home, 1=Offres, 2=Register)
  int _pageIndex = 0;

  // IndexedStack : garde tous les widgets en mémoire
  // → ne recrée pas la page quand on revient dessus
  // → préserve le scroll, l'état des formulaires, etc.
  final List<Widget> _pages = const [
    HomeScreen(),
    OffresScreen(),
    RegisterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Page active — IndexedStack affiche seulement _pageIndex
        // mais garde les autres en mémoire (pas de rebuild)
        IndexedStack(
          index:    _pageIndex,
          children: _pages,
        ),

        // ── Bouton de test (bascule thème) ───────────────
        // Positionné en bas à droite, flottant au-dessus
        // SEULEMENT pour les tests — à supprimer en prod
        Positioned(
          bottom: 80, // au-dessus de la BottomNav
          right:  16,
          child: FloatingActionButton.small(
            heroTag:    'theme-toggle', // évite conflit avec FAB des pages
            tooltip:    'Basculer light/dark',
            onPressed:  widget.onToggleTheme,
            child: const Icon(Icons.brightness_6),
          ),
        ),
      ],
    );
  }
}