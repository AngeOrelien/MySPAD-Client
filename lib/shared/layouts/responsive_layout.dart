// lib/shared/layouts/responsive_layout.dart
//
// ─── RESPONSIVE LAYOUT ───────────────────────────────────────
// Widget générique qui sélectionne le bon layout
// selon la surface d'affichage.
//
// DIFFÉRENCE avec ResponsiveUtils :
//   ResponsiveUtils  → classe utilitaire, répond à une question
//   ResponsiveLayout → widget, affiche le bon enfant
//
// QUAND l'utiliser ?
//   Quand le CONTENU change entre surfaces (pas juste la taille).
//   Ex : sur mobile la home affiche une liste,
//        sur desktop elle affiche 2 colonnes côte à côte.
//
// QUAND NE PAS l'utiliser ?
//   Si seul le padding/fontSize change → utilise responsiveValue()
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../core/utils/responsive_utils.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,   // widget rendu sur téléphone
    this.tablet,            // widget rendu sur tablette (facultatif)
    required this.desktop,  // widget rendu sur desktop/web
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder écoute les contraintes de son parent,
    // pas forcément l'écran entier.
    // → Plus précis dans les layouts imbriqués.
    // → Se met à jour si la fenêtre est redimensionnée (web).
    return LayoutBuilder(
      builder: (context, constraints) {
        // constraints.maxWidth = largeur disponible pour CE widget
        if (constraints.maxWidth >= ResponsiveUtils.tabletBreak) {
          return desktop;
        }
        if (constraints.maxWidth >= ResponsiveUtils.mobileBreak) {
          // Si tablet non fourni, on affiche mobile
          // (moins de duplication de code)
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RESPONSIVE VISIBILITY — afficher/cacher selon surface
// Pratique pour cacher des éléments sur certaines surfaces
// sans dupliquer de code dans les widgets parents.
// ─────────────────────────────────────────────────────────────

/// Affiche [child] seulement sur mobile
class MobileOnly extends StatelessWidget {
  const MobileOnly({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Si pas mobile → retourne un widget vide de taille 0
    return ResponsiveUtils.isMobile(context)
        ? child
        : const SizedBox.shrink();
  }
}

/// Affiche [child] seulement sur tablette et desktop
class DesktopOnly extends StatelessWidget {
  const DesktopOnly({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return !ResponsiveUtils.isMobile(context)
        ? child
        : const SizedBox.shrink();
  }
}