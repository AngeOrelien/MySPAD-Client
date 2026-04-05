// lib/core/theme/app_colors.dart
// Palette SPAD Cameroun — dérivée de Radix UI Color System
// Primaire : Teal  (#3CDADD dark / #00C7CC light)
// Secondaire : Green (#0C8C6B)

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Classe non instanciable

  // ═══════════════════════════════════════════════════
  // TEAL — SCALE LIGHT (teal-1 → teal-12)
  // ═══════════════════════════════════════════════════
  static const Color teal1  = Color(0xFFF8FEFE); // fond très subtil
  static const Color teal2  = Color(0xFFEEFCFC); // fond hover
  static const Color teal3  = Color(0xFFD1FBFB); // fond sélectionné
  static const Color teal4  = Color(0xFFB4F7F8);
  static const Color teal5  = Color(0xFF96F0F2);
  static const Color teal6  = Color(0xFF73E6E8); // border subtile
  static const Color teal7  = Color(0xFF37D7DA); // border hover
  static const Color teal8  = Color(0xFF00C0C5);
  static const Color teal9  = Color(0xFF00C7CC); // ★ SOLID (light)
  static const Color teal10 = Color(0xFF00BBBF); // solid hover
  static const Color teal11 = Color(0xFF007E81); // texte basse intensité
  static const Color teal12 = Color(0xFF004345); // texte haute intensité

  // ═══════════════════════════════════════════════════
  // TEAL — SCALE DARK (teal-1 → teal-12)
  // ═══════════════════════════════════════════════════
  static const Color tealDark1  = Color(0xFF081313);
  static const Color tealDark2  = Color(0xFF0D1B1B);
  static const Color tealDark3  = Color(0xFF002D2E);
  static const Color tealDark4  = Color(0xFF003B3D);
  static const Color tealDark5  = Color(0xFF00484A);
  static const Color tealDark6  = Color(0xFF005759); // border subtile
  static const Color tealDark7  = Color(0xFF006A6C); // border hover
  static const Color tealDark8  = Color(0xFF008285);
  static const Color tealDark9  = Color(0xFF3CDADD); // ★ SOLID (dark) ← ta couleur
  static const Color tealDark10 = Color(0xFF2ACFD2); // solid hover
  static const Color tealDark11 = Color(0xFF31D3D6); // texte basse intensité
  static const Color tealDark12 = Color(0xFFB5F1F2); // texte haute intensité

  // ═══════════════════════════════════════════════════
  // GREEN — SCALE LIGHT (secondaire)  #0C8C6B
  // ═══════════════════════════════════════════════════
  static const Color green1  = Color(0xFFF0FAF6);
  static const Color green2  = Color(0xFFD0F0E4);
  static const Color green3  = Color(0xFFA3E0C8);
  static const Color green4  = Color(0xFF6ECAAA);
  static const Color green5  = Color(0xFF3DB28D);
  static const Color green6  = Color(0xFF1E9E78);
  static const Color green7  = Color(0xFF0C8C6B); // ★ SOLID secondaire
  static const Color green8  = Color(0xFF097A5C);
  static const Color green9  = Color(0xFF075C45);
  static const Color green10 = Color(0xFF054030);
  static const Color green11 = Color(0xFF032820);
  static const Color green12 = Color(0xFF011510);

  // ═══════════════════════════════════════════════════
  // GREEN — SCALE DARK
  // ═══════════════════════════════════════════════════
  static const Color greenDark1  = Color(0xFF0A1A14);
  static const Color greenDark2  = Color(0xFF102419);
  static const Color greenDark3  = Color(0xFF0E3324);
  static const Color greenDark4  = Color(0xFF0F422F);
  static const Color greenDark5  = Color(0xFF0F543B);
  static const Color greenDark6  = Color(0xFF0D6849);
  static const Color greenDark7  = Color(0xFF0C8C6B); // ★ partagé light/dark
  static const Color greenDark8  = Color(0xFF10A881);
  static const Color greenDark9  = Color(0xFF14C99A);
  static const Color greenDark10 = Color(0xFF1DE0AA);
  static const Color greenDark11 = Color(0xFF20E8B0);
  static const Color greenDark12 = Color(0xFFA8F0D8);

  // ═══════════════════════════════════════════════════
  // GRAY — SCALE LIGHT (Radix)
  // ═══════════════════════════════════════════════════
  static const Color gray1  = Color(0xFFFCFCFD);
  static const Color gray2  = Color(0xFFF9F9FB);
  static const Color gray3  = Color(0xFFF0F0F4);
  static const Color gray4  = Color(0xFFE7E8ED);
  static const Color gray5  = Color(0xFFE0E1E7);
  static const Color gray6  = Color(0xFFD8D9E0);
  static const Color gray7  = Color(0xFFCDCED7);
  static const Color gray8  = Color(0xFFB9BBC7);
  static const Color gray9  = Color(0xFF8C8D99);
  static const Color gray10 = Color(0xFF81828D);
  static const Color gray11 = Color(0xFF62636C);
  static const Color gray12 = Color(0xFF1F1F25);

  // ═══════════════════════════════════════════════════
  // GRAY — SCALE DARK (Radix)
  // ═══════════════════════════════════════════════════
  static const Color grayDark1  = Color(0xFF111113);
  static const Color grayDark2  = Color(0xFF19191B);
  static const Color grayDark3  = Color(0xFF222325);
  static const Color grayDark4  = Color(0xFF292A2E);
  static const Color grayDark5  = Color(0xFF303136);
  static const Color grayDark6  = Color(0xFF393A40);
  static const Color grayDark7  = Color(0xFF46484F);
  static const Color grayDark8  = Color(0xFF5F606A);
  static const Color grayDark9  = Color(0xFF6C6E79);
  static const Color grayDark10 = Color(0xFF797B86);
  static const Color grayDark11 = Color(0xFFB2B3BD);
  static const Color grayDark12 = Color(0xFFEEEEF0);

  // ═══════════════════════════════════════════════════
  // STATUTS (fixes — identiques light/dark via opacity)
  // ═══════════════════════════════════════════════════
  static const Color success = Color(0xFF1E8449);
  static const Color warning = Color(0xFFF39C12);
  static const Color error   = Color(0xFFC0392B);
  static const Color info    = Color(0xFF2980B9);

  // ═══════════════════════════════════════════════════
  // TOKENS SÉMANTIQUES — LIGHT MODE
  // Utilisés dans ColorScheme.light() de app_theme.dart
  // ═══════════════════════════════════════════════════
  static const Color primaryLight       = teal9;      // solid bg light
  static const Color primaryLightHover  = teal10;
  static const Color primaryLightText   = teal11;     // texte sur fond clair
  static const Color primaryLightBg     = teal1;      // fond de page tealé
  static const Color primaryLightBorder = teal6;

  static const Color secondaryLight     = green7;     // #0C8C6B
  static const Color secondaryLightText = green9;

  static const Color backgroundLight    = gray1;
  static const Color surfaceLight       = Color(0xFFFFFFFF);
  static const Color textPrimaryLight   = gray12;
  static const Color textSecondaryLight = gray11;
  static const Color borderLight        = gray6;

  // ═══════════════════════════════════════════════════
  // TOKENS SÉMANTIQUES — DARK MODE
  // Utilisés dans ColorScheme.dark() de app_theme.dart
  // ═══════════════════════════════════════════════════
  static const Color primaryDark        = tealDark9;  // #3CDADD ← ta couleur
  static const Color primaryDarkHover   = tealDark10;
  static const Color primaryDarkText    = tealDark11;
  static const Color primaryDarkBg      = tealDark1;
  static const Color primaryDarkBorder  = tealDark6;

  static const Color secondaryDark      = greenDark9; // #14C99A (plus lumineux)
  static const Color secondaryDarkText  = greenDark11;

  static const Color backgroundDark     = grayDark1;  // #111113
  static const Color surfaceDark        = grayDark2;  // #19191B
  static const Color textPrimaryDark    = grayDark12;
  static const Color textSecondaryDark  = grayDark11;
  static const Color borderDark         = grayDark6;

  // Couleur texte sur fond primaire (boutons, chips)
  // teal-contrast = #fff en light, #032728 en dark
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onPrimaryDark  = Color(0xFF032728);

  // Couleur d'accentuation pour éléments interactifs (liens, icônes)
  static const Color accent = teal8; // #00C0C5 (plus sombre que le solid)
}