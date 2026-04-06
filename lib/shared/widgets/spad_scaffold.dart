// lib/shared/widgets/spad_scaffold.dart
//
// ─── SPAD SCAFFOLD — LE SCAFFOLD MAÎTRE ─────────────────────
// Composant central de l'app. Chaque page l'utilise comme
// wrapper — il décide seul de la navigation à afficher.
//
// PRINCIPE DE RESPONSABILITÉ UNIQUE :
//   → Les pages ne savent pas sur quelle surface elles s'affichent
//   → SpadScaffold gère tout seul : mobile/tablet/desktop
//   → Les pages passent juste body + navItems + currentIndex
//
// LES 3 MODES :
//   Mobile  (< 600dp)  → Scaffold + BottomNavigationBar
//   Tablet  (600–1024) → Row(Sidebar fixe | body)
//   Desktop (> 1024dp) → Row(Sidebar collapse | body)
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/spad_nav_item.dart';
import '../widgets/spad_bottom_nav.dart';
import '../widgets/spad_sidebar.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/theme/app_colors.dart';

class SpadScaffold extends StatefulWidget {
  const SpadScaffold({
    super.key,
    required this.body,          // contenu principal de la page
    required this.navItems,      // items du rôle connecté
    required this.currentIndex,  // index de la page active
    required this.onNavTap,      // callback changement de page
    this.appBar,                 // AppBar personnalisée (optionnel)
    this.fab,                    // FloatingActionButton (optionnel)
    this.userName,               // affiché dans la sidebar
    this.userRole,               // rôle affiché dans la sidebar
  });

  final Widget body;
  final List<SpadNavItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onNavTap;
  final PreferredSizeWidget? appBar; // PreferredSizeWidget = type de AppBar
  final Widget? fab;
  final String? userName;
  final String? userRole;

  @override
  State<SpadScaffold> createState() => _SpadScaffoldState();
}

// StatefulWidget car on gère l'état du collapse de la sidebar desktop
class _SpadScaffoldState extends State<SpadScaffold> {

  // État local : sidebar desktop ouverte ou fermée
  // bool simple → pas besoin de Bloc/Provider pour ça
  bool _sidebarCollapsed = false;

  void _toggleSidebar() {
    // setState() dit à Flutter "re-rends ce widget"
    setState(() {
      _sidebarCollapsed = !_sidebarCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // On lit la surface UNE seule fois dans build()
    // et on passe la valeur aux méthodes privées
    final screenType = ResponsiveUtils.screenType(context);

    // Switch exhaustif sur l'enum → pas de default nécessaire
    return switch (screenType) {
      ScreenType.mobile  => _buildMobile(),
      ScreenType.tablet  => _buildTablet(),
      ScreenType.desktop => _buildDesktop(),
    };
  }

  // ─────────────────────────────────────────────────────────
  // MODE MOBILE — Scaffold standard + BottomNavigationBar
  // ─────────────────────────────────────────────────────────
  Widget _buildMobile() {
    return Scaffold(
      // AppBar fournie par la page, ou null (pas d'AppBar)
      appBar: widget.appBar,

      // Corps de la page
      body: widget.body,

      // BottomNav avec les items du rôle
      bottomNavigationBar: SpadBottomNav(
        items:        widget.navItems,
        currentIndex: widget.currentIndex,
        onTap:        widget.onNavTap,
      ),

      // FAB (bouton d'action flottant) si fourni
      floatingActionButton: widget.fab,
    );
  }

  // ─────────────────────────────────────────────────────────
  // MODE TABLET — Row(Sidebar fixe | Expanded body)
  // Pas d'AppBar — la sidebar prend son rôle
  // ─────────────────────────────────────────────────────────
  Widget _buildTablet() {
    return Scaffold(
      // Sur tablette, pas de BottomNav, pas d'AppBar standard
      // La sidebar contient la navigation complète
      body: Row(
        children: [
          // Sidebar fixe à gauche — largeur 260dp
          SpadSidebar(
            items:        widget.navItems,
            currentIndex: widget.currentIndex,
            onTap:        widget.onNavTap,
            userName:     widget.userName,
            userRole:     widget.userRole,
            // Tablette : pas de bouton collapse
          ),

          // Séparateur vertical
          VerticalDivider(
            width:     1,
            thickness: 1,
            color:     Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),

          // Corps de la page — Expanded prend tout l'espace restant
          Expanded(child: widget.body),
        ],
      ),
      floatingActionButton: widget.fab,
    );
  }

  // ─────────────────────────────────────────────────────────
  // MODE DESKTOP — Row(Sidebar collapse | Expanded body)
  // La sidebar peut se réduire à 72dp (icônes seulement)
  // ─────────────────────────────────────────────────────────
  Widget _buildDesktop() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar avec gestion collapse
          SpadSidebar(
            items:             widget.navItems,
            currentIndex:      widget.currentIndex,
            onTap:             widget.onNavTap,
            isCollapsed:       _sidebarCollapsed,
            onToggleCollapse:  _toggleSidebar, // passe le callback
            userName:          widget.userName,
            userRole:          widget.userRole,
          ),

          VerticalDivider(
            width:     1,
            thickness: 1,
            color:     Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),

          Expanded(child: widget.body),
        ],
      ),
      floatingActionButton: widget.fab,
    );
  }
}