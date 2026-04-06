// lib/core/utils/responsive_utils.dart
//
// ─── RESPONSIVE UTILS ────────────────────────────────────────
// Classe utilitaire STATIQUE — jamais instanciée.
// Répond à une seule question : "sur quelle surface suis-je ?"
//
// RÈGLE D'OR :
//   Utilise toujours cette classe plutôt que d'écrire
//   MediaQuery.of(context).size.width < 600 directement
//   dans tes widgets — comme ça tu changes les breakpoints
//   en un seul endroit si besoin.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ─── L'enum des 3 surfaces possibles ─────────────────────────
// Un enum est un type qui ne peut prendre qu'un nombre
// fini de valeurs. Ici : mobile, tablet, ou desktop.
enum ScreenType { mobile, tablet, desktop }

class ResponsiveUtils {
  // Constructeur privé → personne ne peut faire ResponsiveUtils()
  ResponsiveUtils._();

  // ─────────────────────────────────────────────────────────
  // LES 2 BREAKPOINTS — valeurs en pixels logiques (dp)
  // Pixel logique ≠ pixel physique. Flutter travaille
  // toujours en pixels logiques, indépendamment de la densité
  // de l'écran (Retina, AMOLED, etc.)
  // ─────────────────────────────────────────────────────────

  /// Limite basse : en dessous → mobile
  static const double mobileBreak = 600;

  /// Limite haute : au-dessus → desktop
  static const double tabletBreak = 1024;

  // ─────────────────────────────────────────────────────────
  // DÉTECTION — 3 getters booléens + 1 getter enum
  //
  // MediaQuery.of(context) :
  //   → lit les informations de l'écran depuis le contexte
  //   → .size.width = largeur actuelle en pixels logiques
  //   → se met à jour automatiquement si l'écran est redimensionné
  // ─────────────────────────────────────────────────────────

  /// Retourne true si on est sur téléphone (< 600dp)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreak;

  /// Retourne true si on est sur tablette (600–1023dp)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreak && width < tabletBreak;
  }

  /// Retourne true si on est sur desktop/web large (≥ 1024dp)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreak;

  /// Retourne l'enum ScreenType correspondant à la surface actuelle.
  /// Préférable aux 3 booléens dans un switch/case.
  static ScreenType screenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreak) return ScreenType.mobile;
    if (width < tabletBreak) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  // ─────────────────────────────────────────────────────────
  // HELPER GÉNÉRIQUE — responsiveValue<T>
  //
  // Générique (<T>) = fonctionne avec n'importe quel type :
  //   double, int, String, Widget, EdgeInsets, etc.
  //
  // Utilisation :
  //   double pad = ResponsiveUtils.responsiveValue(context,
  //     mobile: 16, tablet: 32, desktop: 64);
  // ─────────────────────────────────────────────────────────

  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet, // facultatif — si null, utilise mobile
    required T desktop,
  }) {
    final type = screenType(context);
    switch (type) {
      case ScreenType.desktop:
        return desktop;
      case ScreenType.tablet:
        return tablet ?? mobile; // fallback sur mobile si tablet non fourni
      case ScreenType.mobile:
        return mobile;
    }
  }

  // ─────────────────────────────────────────────────────────
  // VALEURS PRÉCALCULÉES — utilitaires courants
  // Évite de répéter responsiveValue partout pour les cas
  // les plus fréquents dans l'app SPAD.
  // ─────────────────────────────────────────────────────────

  /// Padding horizontal des pages (marges gauche/droite)
  static double horizontalPadding(BuildContext context) =>
      responsiveValue(context, mobile: 16.0, tablet: 32.0, desktop: 80.0);

  /// Nombre de colonnes pour une grille de cards
  static int gridColumns(BuildContext context) =>
      responsiveValue(context, mobile: 1, tablet: 2, desktop: 3);

  /// Largeur max du contenu principal (pour éviter les lignes trop longues sur grand écran)
  static double maxContentWidth(BuildContext context) =>
      responsiveValue(context, mobile: double.infinity, tablet: 900, desktop: 1200);

  /// Largeur de la sidebar
  static double sidebarWidth(BuildContext context) =>
      responsiveValue(context, mobile: 0, tablet: 260, desktop: 280);

  /// Vrai si la sidebar doit être visible (tablette et desktop)
  static bool showSidebar(BuildContext context) => !isMobile(context);

  /// Vrai si la BottomNav doit être visible (mobile seulement)
  static bool showBottomNav(BuildContext context) => isMobile(context);
}