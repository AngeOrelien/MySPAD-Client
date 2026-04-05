// lib/core/theme/app_colors.dart
//
// Palette SPAD Cameroun — Radix UI Color System
// ─────────────────────────────────────────────
//  Primaire  : Teal   (#00C7CC light / #3CDADD dark)
//  Secondaire: Green  (#0C8C6B)
//  Accent    : Amber  (#F5A623 light / #FFB224 dark)
//  Neutre    : Gray   (Radix gray scale)
// ─────────────────────────────────────────────
// Utilisation :
//   AppColors.primaryLight    → token sémantique (light)
//   AppColors.primaryDark     → token sémantique (dark)
//   AppColors.teal9           → valeur brute Radix (éviter dans les widgets)
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Classe non instanciable — tout est static const

  // ═══════════════════════════════════════════════════════════
  // TEAL — SCALE LIGHT  (Radix teal-1 → teal-12)
  // ═══════════════════════════════════════════════════════════
  static const Color teal1  = Color(0xFFF8FEFE); // fond app très subtil
  static const Color teal2  = Color(0xFFEEFCFC); // fond hover
  static const Color teal3  = Color(0xFFD1FBFB); // fond sélectionné / actif
  static const Color teal4  = Color(0xFFB4F7F8);
  static const Color teal5  = Color(0xFF96F0F2);
  static const Color teal6  = Color(0xFF73E6E8); // bordure subtile
  static const Color teal7  = Color(0xFF37D7DA); // bordure hover
  static const Color teal8  = Color(0xFF00C0C5);
  static const Color teal9  = Color(0xFF00C7CC); // ★ SOLID — fond bouton light
  static const Color teal10 = Color(0xFF00BBBF); // hover bouton
  static const Color teal11 = Color(0xFF007E81); // texte / icône sur fond clair
  static const Color teal12 = Color(0xFF004345); // texte haute intensité

  // ═══════════════════════════════════════════════════════════
  // TEAL — SCALE DARK  (Radix teal-1 → teal-12)
  // ═══════════════════════════════════════════════════════════
  static const Color tealDark1  = Color(0xFF081313);
  static const Color tealDark2  = Color(0xFF0D1B1B);
  static const Color tealDark3  = Color(0xFF002D2E);
  static const Color tealDark4  = Color(0xFF003B3D);
  static const Color tealDark5  = Color(0xFF00484A);
  static const Color tealDark6  = Color(0xFF005759); // bordure subtile dark
  static const Color tealDark7  = Color(0xFF006A6C); // bordure hover dark
  static const Color tealDark8  = Color(0xFF008285);
  static const Color tealDark9  = Color(0xFF3CDADD); // ★ SOLID dark — ta couleur
  static const Color tealDark10 = Color(0xFF2ACFD2); // hover dark
  static const Color tealDark11 = Color(0xFF31D3D6); // texte / icône sur fond sombre
  static const Color tealDark12 = Color(0xFFB5F1F2); // texte haute intensité dark

  // ═══════════════════════════════════════════════════════════
  // GREEN — SCALE LIGHT  (secondaire #0C8C6B)
  // ═══════════════════════════════════════════════════════════
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

  // ═══════════════════════════════════════════════════════════
  // GREEN — SCALE DARK
  // ═══════════════════════════════════════════════════════════
  static const Color greenDark1  = Color(0xFF0A1A14);
  static const Color greenDark2  = Color(0xFF102419);
  static const Color greenDark3  = Color(0xFF0E3324);
  static const Color greenDark4  = Color(0xFF0F422F);
  static const Color greenDark5  = Color(0xFF0F543B);
  static const Color greenDark6  = Color(0xFF0D6849);
  static const Color greenDark7  = Color(0xFF0C8C6B); // même solid en dark
  static const Color greenDark8  = Color(0xFF10A881);
  static const Color greenDark9  = Color(0xFF14C99A); // ★ plus lumineux en dark
  static const Color greenDark10 = Color(0xFF1DE0AA);
  static const Color greenDark11 = Color(0xFF20E8B0);
  static const Color greenDark12 = Color(0xFFA8F0D8);

  // ═══════════════════════════════════════════════════════════
  // AMBER — ACCENT  (complémentaire du teal sur la roue)
  // Usage : badges, tags, alertes douces, CTAs secondaires,
  //         highlights, icônes pill
  // ═══════════════════════════════════════════════════════════

  // Scale Light
  static const Color amber1  = Color(0xFFFFFCF0); // fond amber très subtil
  static const Color amber2  = Color(0xFFFFF7D9); // fond hover
  static const Color amber3  = Color(0xFFFFEEA8); // fond sélectionné
  static const Color amber4  = Color(0xFFFFE370);
  static const Color amber5  = Color(0xFFFFD73D);
  static const Color amber6  = Color(0xFFF5C800); // bordure amber
  static const Color amber7  = Color(0xFFE0AC00); // bordure hover
  static const Color amber8  = Color(0xFFCA9400);
  static const Color amber9  = Color(0xFFF5A623); // ★ SOLID accent light
  static const Color amber10 = Color(0xFFE09520); // hover
  static const Color amber11 = Color(0xFF9A6400); // texte sur fond clair
  static const Color amber12 = Color(0xFF4D3200); // texte haute intensité

  // Scale Dark
  static const Color amberDark1  = Color(0xFF1A1200);
  static const Color amberDark2  = Color(0xFF221A00);
  static const Color amberDark3  = Color(0xFF342800);
  static const Color amberDark4  = Color(0xFF443400);
  static const Color amberDark5  = Color(0xFF564200);
  static const Color amberDark6  = Color(0xFF6E5500); // bordure dark
  static const Color amberDark7  = Color(0xFF8C6E00); // bordure hover dark
  static const Color amberDark8  = Color(0xFFAA8800);
  static const Color amberDark9  = Color(0xFFFFB224); // ★ SOLID accent dark (+ lumineux)
  static const Color amberDark10 = Color(0xFFFFA800); // hover dark
  static const Color amberDark11 = Color(0xFFFFCC4D); // texte sur fond sombre
  static const Color amberDark12 = Color(0xFFFFECA8); // texte haute intensité dark

  // ═══════════════════════════════════════════════════════════
  // GRAY — SCALE LIGHT  (Radix gray)
  // ═══════════════════════════════════════════════════════════
  static const Color gray1  = Color(0xFFFCFCFD); // fond page
  static const Color gray2  = Color(0xFFF9F9FB); // fond subtle
  static const Color gray3  = Color(0xFFF0F0F4); // fond hover
  static const Color gray4  = Color(0xFFE7E8ED); // fond sélectionné
  static const Color gray5  = Color(0xFFE0E1E7); // fond actif
  static const Color gray6  = Color(0xFFD8D9E0); // bordure
  static const Color gray7  = Color(0xFFCDCED7); // bordure hover
  static const Color gray8  = Color(0xFFB9BBC7); // bordure focus
  static const Color gray9  = Color(0xFF8C8D99); // placeholder
  static const Color gray10 = Color(0xFF81828D); // texte désactivé
  static const Color gray11 = Color(0xFF62636C); // texte secondaire
  static const Color gray12 = Color(0xFF1F1F25); // texte primaire

  // ═══════════════════════════════════════════════════════════
  // GRAY — SCALE DARK  (Radix gray dark)
  // ═══════════════════════════════════════════════════════════
  static const Color grayDark1  = Color(0xFF111113); // fond page dark
  static const Color grayDark2  = Color(0xFF19191B); // fond surface dark
  static const Color grayDark3  = Color(0xFF222325); // fond hover dark
  static const Color grayDark4  = Color(0xFF292A2E); // fond sélectionné dark
  static const Color grayDark5  = Color(0xFF303136); // fond actif dark
  static const Color grayDark6  = Color(0xFF393A40); // bordure dark
  static const Color grayDark7  = Color(0xFF46484F); // bordure hover dark
  static const Color grayDark8  = Color(0xFF5F606A); // bordure focus dark
  static const Color grayDark9  = Color(0xFF6C6E79); // placeholder dark
  static const Color grayDark10 = Color(0xFF797B86); // texte désactivé dark
  static const Color grayDark11 = Color(0xFFB2B3BD); // texte secondaire dark
  static const Color grayDark12 = Color(0xFFEEEEF0); // texte primaire dark

  // ═══════════════════════════════════════════════════════════
  // STATUTS SÉMANTIQUES  (fixes, identiques light/dark)
  // Ajuster via withOpacity() pour les variantes de fond
  // ═══════════════════════════════════════════════════════════
  static const Color success        = Color(0xFF1E8449);
  static const Color successLight   = Color(0xFFD5F5E3);
  static const Color warning        = Color(0xFFF39C12);
  static const Color warningLight   = Color(0xFFFEF9E7);
  static const Color error          = Color(0xFFC0392B);
  static const Color errorLight     = Color(0xFFFDEDEC);
  static const Color info           = Color(0xFF2980B9);
  static const Color infoLight      = Color(0xFFD6EAF8);

  // ═══════════════════════════════════════════════════════════
  // TOKENS SÉMANTIQUES — LIGHT MODE
  // Ce sont ces constantes que tu utilises dans app_theme.dart
  // et dans tes widgets via Theme.of(context).colorScheme
  // ═══════════════════════════════════════════════════════════

  // -- Primaire (Teal) --
  static const Color primaryLight       = teal9;       // #00C7CC  → solid
  static const Color primaryLightHover  = teal10;      // #00BBBF  → hover
  static const Color primaryLightBg     = teal1;       // #F8FEFE  → fond subtil
  static const Color primaryLightBorder = teal6;       // #73E6E8  → bordure
  static const Color primaryLightText   = teal11;      // #007E81  → texte sur blanc
  static const Color onPrimaryLight     = Color(0xFFFFFFFF); // texte SUR bouton primaire

  // -- Secondaire (Green) --
  static const Color secondaryLight     = green7;      // #0C8C6B
  static const Color secondaryLightBg  = green1;       // #F0FAF6
  static const Color secondaryLightText = green9;      // #075C45
  static const Color onSecondaryLight   = Color(0xFFFFFFFF);

  // -- Accent (Amber) --
  static const Color accentLight        = amber9;      // #F5A623  ★
  static const Color accentLightBg      = amber1;      // #FFFCF0
  static const Color accentLightBorder  = amber6;      // #F5C800
  static const Color accentLightText    = amber11;     // #9A6400
  static const Color onAccentLight      = Color(0xFF4D3200); // texte SUR fond accent

  // -- Neutre / Layout --
  static const Color backgroundLight    = gray1;       // #FCFCFD
  static const Color surfaceLight       = Color(0xFFFFFFFF);
  static const Color surfaceElevLight   = gray2;       // #F9F9FB  (cards, sheets)
  static const Color borderLight        = gray6;       // #D8D9E0
  static const Color borderFocusLight   = teal7;       // #37D7DA  (input focus)
  static const Color textPrimaryLight   = gray12;      // #1F1F25
  static const Color textSecondaryLight = gray11;      // #62636C
  static const Color textPlaceholder    = gray9;       // #8C8D99
  static const Color textDisabled       = gray10;      // #81828D

  // ═══════════════════════════════════════════════════════════
  // TOKENS SÉMANTIQUES — DARK MODE
  // ═══════════════════════════════════════════════════════════

  // -- Primaire (Teal dark) --
  static const Color primaryDark        = tealDark9;   // #3CDADD  ★ ta couleur
  static const Color primaryDarkHover   = tealDark10;  // #2ACFD2
  static const Color primaryDarkBg      = tealDark1;   // #081313
  static const Color primaryDarkBorder  = tealDark6;   // #005759
  static const Color primaryDarkText    = tealDark11;  // #31D3D6
  static const Color onPrimaryDark      = Color(0xFF032728); // texte SUR bouton primaire dark

  // -- Secondaire (Green dark) --
  static const Color secondaryDark      = greenDark9;  // #14C99A (+ lumineux)
  static const Color secondaryDarkBg    = greenDark1;  // #0A1A14
  static const Color secondaryDarkText  = greenDark11; // #20E8B0
  static const Color onSecondaryDark    = Color(0xFF032728);

  // -- Accent (Amber dark) --
  static const Color accentDark         = amberDark9;  // #FFB224  ★
  static const Color accentDarkBg       = amberDark1;  // #1A1200
  static const Color accentDarkBorder   = amberDark6;  // #6E5500
  static const Color accentDarkText     = amberDark11; // #FFCC4D
  static const Color onAccentDark       = Color(0xFF1A1200); // texte SUR fond accent dark

  // -- Neutre / Layout dark --
  static const Color backgroundDark     = grayDark1;   // #111113
  static const Color surfaceDark        = grayDark2;   // #19191B
  static const Color surfaceElevDark    = grayDark3;   // #222325  (cards, sheets)
  static const Color borderDark         = grayDark6;   // #393A40
  static const Color borderFocusDark    = tealDark7;   // #006A6C
  static const Color textPrimaryDark    = grayDark12;  // #EEEEF0
  static const Color textSecondaryDark  = grayDark11;  // #B2B3BD
  static const Color textPlaceholderDark = grayDark9;  // #6C6E79
  static const Color textDisabledDark   = grayDark10;  // #797B86
}