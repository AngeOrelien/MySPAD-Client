// lib/core/theme/app_text_styles.dart
//
// Typographie SPAD Cameroun
// ─────────────────────────────────────────────
//  Titres / Headings : Poppins  (expressif, moderne)
//  Corps / UI        : Inter    (lisibilité écran optimale)
// ─────────────────────────────────────────────
// Dépendances pubspec.yaml :
//   fonts:
//     - family: Poppins
//       fonts:
//         - asset: assets/fonts/Poppins-Regular.ttf
//         - asset: assets/fonts/Poppins-Medium.ttf    weight: 500
//         - asset: assets/fonts/Poppins-SemiBold.ttf  weight: 600
//         - asset: assets/fonts/Poppins-Bold.ttf      weight: 700
//     - family: Inter
//       fonts:
//         - asset: assets/fonts/Inter-Regular.ttf
//         - asset: assets/fonts/Inter-Medium.ttf      weight: 500
//         - asset: assets/fonts/Inter-SemiBold.ttf    weight: 600
// ─────────────────────────────────────────────
// Si les polices ne sont pas encore installées,
// remplace 'Poppins' par 'Roboto' et 'Inter' par
// le défaut Flutter — aucun autre changement nécessaire.
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

// ─── Constantes internes ─────────────────────────────────────
const String _heading = 'Poppins'; // polices de titres
const String _body    = 'Inter';   // polices de corps

// Raccourcis poids
const FontWeight _regular  = FontWeight.w400;
const FontWeight _medium   = FontWeight.w500;
const FontWeight _semiBold = FontWeight.w600;
const FontWeight _bold     = FontWeight.w700;

class AppTextStyles {
  AppTextStyles._();

  // ═══════════════════════════════════════════════════════════
  // DISPLAY  —  grands titres hors-normes (hero section, splash)
  // ═══════════════════════════════════════════════════════════

  /// 48px · Bold · Poppins — Hero section, splash
  static const TextStyle displayLarge = TextStyle(
    fontFamily:    _heading,
    fontSize:      48,
    fontWeight:    _bold,
    height:        1.1,
    letterSpacing: -1.0,
  );

  /// 36px · SemiBold · Poppins — Sous-titres hero, banners
  static const TextStyle displayMedium = TextStyle(
    fontFamily:    _heading,
    fontSize:      36,
    fontWeight:    _semiBold,
    height:        1.2,
    letterSpacing: -0.5,
  );

  /// 28px · SemiBold · Poppins — Headers de sections publiques
  static const TextStyle displaySmall = TextStyle(
    fontFamily:    _heading,
    fontSize:      28,
    fontWeight:    _semiBold,
    height:        1.25,
    letterSpacing: -0.25,
  );

  // ═══════════════════════════════════════════════════════════
  // HEADLINE  —  titres de pages et sections dans l'app
  // ═══════════════════════════════════════════════════════════

  /// 24px · SemiBold · Poppins — Titre de page dashboard
  static const TextStyle headlineLarge = TextStyle(
    fontFamily:    _heading,
    fontSize:      24,
    fontWeight:    _semiBold,
    height:        1.3,
    letterSpacing: -0.2,
  );

  /// 20px · SemiBold · Poppins — Titre de section / dialog
  static const TextStyle headlineMedium = TextStyle(
    fontFamily:    _heading,
    fontSize:      20,
    fontWeight:    _semiBold,
    height:        1.3,
    letterSpacing: -0.1,
  );

  /// 18px · Medium · Poppins — Sous-section, AppBar title
  static const TextStyle headlineSmall = TextStyle(
    fontFamily:    _heading,
    fontSize:      18,
    fontWeight:    _medium,
    height:        1.35,
    letterSpacing: 0,
  );

  // ═══════════════════════════════════════════════════════════
  // TITLE  —  étiquettes de navigation, titres de cards
  // ═══════════════════════════════════════════════════════════

  /// 16px · SemiBold · Poppins — Titre de card, list item important
  static const TextStyle titleLarge = TextStyle(
    fontFamily:    _heading,
    fontSize:      16,
    fontWeight:    _semiBold,
    height:        1.4,
    letterSpacing: 0,
  );

  /// 14px · Medium · Inter — Label BottomNav actif, tab label
  static const TextStyle titleMedium = TextStyle(
    fontFamily:    _body,
    fontSize:      14,
    fontWeight:    _medium,
    height:        1.4,
    letterSpacing: 0.1,
  );

  /// 12px · Medium · Inter — Badge, chip, tag label
  static const TextStyle titleSmall = TextStyle(
    fontFamily:    _body,
    fontSize:      12,
    fontWeight:    _medium,
    height:        1.4,
    letterSpacing: 0.1,
  );

  // ═══════════════════════════════════════════════════════════
  // BODY  —  texte courant, paragraphes, descriptions
  // ═══════════════════════════════════════════════════════════

  /// 16px · Regular · Inter — Corps principal, actualités
  static const TextStyle bodyLarge = TextStyle(
    fontFamily:    _body,
    fontSize:      16,
    fontWeight:    _regular,
    height:        1.6,
    letterSpacing: 0.15,
  );

  /// 14px · Regular · Inter — Description, détails rapport
  static const TextStyle bodyMedium = TextStyle(
    fontFamily:    _body,
    fontSize:      14,
    fontWeight:    _regular,
    height:        1.55,
    letterSpacing: 0.1,
  );

  /// 12px · Regular · Inter — Métadonnées, horodatage, hint
  static const TextStyle bodySmall = TextStyle(
    fontFamily:    _body,
    fontSize:      12,
    fontWeight:    _regular,
    height:        1.5,
    letterSpacing: 0.25,
  );

  // ═══════════════════════════════════════════════════════════
  // LABEL  —  boutons, inputs, formulaires
  // ═══════════════════════════════════════════════════════════

  /// 16px · SemiBold · Inter — Texte de bouton principal (ElevatedButton)
  static const TextStyle labelLarge = TextStyle(
    fontFamily:    _body,
    fontSize:      16,
    fontWeight:    _semiBold,
    height:        1.0,
    letterSpacing: 0.1,
  );

  /// 14px · Medium · Inter — Texte de bouton secondaire, TextButton
  static const TextStyle labelMedium = TextStyle(
    fontFamily:    _body,
    fontSize:      14,
    fontWeight:    _medium,
    height:        1.0,
    letterSpacing: 0.1,
  );

  /// 11px · Medium · Inter — Label BottomNav inactif, overline
  static const TextStyle labelSmall = TextStyle(
    fontFamily:    _body,
    fontSize:      11,
    fontWeight:    _medium,
    height:        1.0,
    letterSpacing: 0.5,
  );

  // ═══════════════════════════════════════════════════════════
  // STYLES SPÉCIAUX  —  cas d'usage SPAD spécifiques
  // ═══════════════════════════════════════════════════════════

  /// Statut rapport : "Soumis", "En retard", "Validé"
  static const TextStyle statusBadge = TextStyle(
    fontFamily:    _body,
    fontSize:      11,
    fontWeight:    _semiBold,
    height:        1.0,
    letterSpacing: 0.4,
  );

  /// Valeur stat sur dashboard : "12", "89%", "3 patients"
  static const TextStyle statValue = TextStyle(
    fontFamily:    _heading,
    fontSize:      32,
    fontWeight:    _bold,
    height:        1.0,
    letterSpacing: -0.5,
  );

  /// Libellé sous une stat dashboard : "rapports soumis"
  static const TextStyle statLabel = TextStyle(
    fontFamily:    _body,
    fontSize:      12,
    fontWeight:    _regular,
    height:        1.3,
    letterSpacing: 0.2,
  );

  /// Titre section hero sur la home publique
  static const TextStyle heroTitle = TextStyle(
    fontFamily:    _heading,
    fontSize:      42,
    fontWeight:    _bold,
    height:        1.15,
    letterSpacing: -0.8,
  );

  /// Sous-titre hero
  static const TextStyle heroSubtitle = TextStyle(
    fontFamily:    _body,
    fontSize:      18,
    fontWeight:    _regular,
    height:        1.6,
    letterSpacing: 0.1,
  );

  /// Timestamp / date dans les rapports et actualités
  static const TextStyle timestamp = TextStyle(
    fontFamily:    _body,
    fontSize:      11,
    fontWeight:    _regular,
    height:        1.4,
    letterSpacing: 0.3,
  );

  // ═══════════════════════════════════════════════════════════
  // TEXT THEME  —  mapping vers MaterialApp TextTheme
  // Branché dans AppTheme.lightTheme et AppTheme.darkTheme
  // ═══════════════════════════════════════════════════════════

  /// Fournit le TextTheme complet pour Material 3.
  /// NB : la couleur n'est pas définie ici — elle vient du
  /// ColorScheme. N'ajoute JAMAIS de couleur dans ces styles,
  /// sinon le dark mode ne fonctionnera pas automatiquement.
  static TextTheme get textTheme => const TextTheme(
    // Display
    displayLarge:   displayLarge,
    displayMedium:  displayMedium,
    displaySmall:   displaySmall,
    // Headline
    headlineLarge:  headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall:  headlineSmall,
    // Title
    titleLarge:     titleLarge,
    titleMedium:    titleMedium,
    titleSmall:     titleSmall,
    // Body
    bodyLarge:      bodyLarge,
    bodyMedium:     bodyMedium,
    bodySmall:      bodySmall,
    // Label
    labelLarge:     labelLarge,
    labelMedium:    labelMedium,
    labelSmall:     labelSmall,
  );
}