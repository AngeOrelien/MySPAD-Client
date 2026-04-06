// lib/core/theme/app_colors.dart
//
// Palette SPAD Cameroun — Radix UI Color System (version très assombrie)
// ─────────────────────────────────────────────────────────────────
//  Primaire  : Teal   (#009A9E light / #20A8AB dark)
//  Secondaire: Green  (#08664F light / #0C9973 dark)
//  Accent    : Amber  (#C28018 light / #C88A18 dark)
//  Neutre    : Gray   (Radix gray scale, fortement assombrie)
// ─────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════
  // TEAL — SCALE LIGHT (assombrie encore)
  // ═══════════════════════════════════════════════════════════════
  static const Color teal1  = Color(0xFFF0FAFA);
  static const Color teal2  = Color(0xFFE0F7F7);
  static const Color teal3  = Color(0xFFBCF0F0);
  static const Color teal4  = Color(0xFF98E8E9);
  static const Color teal5  = Color(0xFF74DFE1);
  static const Color teal6  = Color(0xFF50D3D5);
  static const Color teal7  = Color(0xFF26C2C5);
  static const Color teal8  = Color(0xFF00A8AC);
  static const Color teal9  = Color.fromARGB(255, 0, 126, 189);
  static const Color teal10 = Color(0xFF008C90);
  static const Color teal11 = Color(0xFF006568);
  static const Color teal12 = Color(0xFF003638);

  // ═══════════════════════════════════════════════════════════════
  // TEAL — SCALE DARK (assombrie encore)
  // ═══════════════════════════════════════════════════════════════
  static const Color tealDark1  = Color(0xFF030D0D);
  static const Color tealDark2  = Color(0xFF071515);
  static const Color tealDark3  = Color(0xFF002021);
  static const Color tealDark4  = Color(0xFF002C2E);
  static const Color tealDark5  = Color(0xFF00393B);
  static const Color tealDark6  = Color(0xFF004648);
  static const Color tealDark7  = Color(0xFF005457);
  static const Color tealDark8  = Color(0xFF006C70);
  static const Color tealDark9  = Color(0xFF20A8AB); // ★ plus sombre
  static const Color tealDark10 = Color(0xFF1C979A);
  static const Color tealDark11 = Color(0xFF22B3B6);
  static const Color tealDark12 = Color(0xFF95DCDE);

  // ═══════════════════════════════════════════════════════════════
  // GREEN — SCALE LIGHT (assombrie encore)
  // ═══════════════════════════════════════════════════════════════
  static const Color green1  = Color(0xFFEAF6F2);
  static const Color green2  = Color(0xFFC0ECE0);
  static const Color green3  = Color(0xFF8ADBBB);
  static const Color green4  = Color(0xFF52C89C);
  static const Color green5  = Color(0xFF28B47E);
  static const Color green6  = Color(0xFF0EA068);
  static const Color green7  = Color(0xFF08664F); // ★ plus sombre
  static const Color green8  = Color.fromARGB(255, 0, 142, 104);
  static const Color green9  = Color(0xFF054535);
  static const Color green10 = Color(0xFF043026);
  static const Color green11 = Color(0xFF021F18);
  static const Color green12 = Color(0xFF01100C);

  // ═══════════════════════════════════════════════════════════════
  // GREEN — SCALE DARK (assombrie encore)
  // ═══════════════════════════════════════════════════════════════
  static const Color greenDark1  = Color(0xFF05140F);
  static const Color greenDark2  = Color(0xFF0A1C16);
  static const Color greenDark3  = Color(0xFF09281C);
  static const Color greenDark4  = Color(0xFF0A3424);
  static const Color greenDark5  = Color(0xFF0A442E);
  static const Color greenDark6  = Color(0xFF08553A);
  static const Color greenDark7  = Color(0xFF08664F); // même solid
  static const Color greenDark8  = Color(0xFF0C8A6B);
  static const Color greenDark9  = Color(0xFF0C9973); // ★ plus sombre
  static const Color greenDark10 = Color(0xFF10B286);
  static const Color greenDark11 = Color(0xFF14C595);
  static const Color greenDark12 = Color(0xFF8CE5CC);

  // ═══════════════════════════════════════════════════════════════
  // AMBER — ACCENT (assombri encore)
  // ═══════════════════════════════════════════════════════════════
  static const Color amber1  = Color(0xFFFFF5E6);
  static const Color amber2  = Color(0xFFFFEECC);
  static const Color amber3  = Color(0xFFFFDD99);
  static const Color amber4  = Color(0xFFFFCC66);
  static const Color amber5  = Color(0xFFFFBB33);
  static const Color amber6  = Color(0xFFE6AA00);
  static const Color amber7  = Color(0xFFCC9500);
  static const Color amber8  = Color(0xFFB38000);
  static const Color amber9  = Color(0xFFC28018); // ★ plus sombre
  static const Color amber10 = Color(0xFFAD7215);
  static const Color amber11 = Color(0xFF7A4F00);
  static const Color amber12 = Color(0xFF3B2800);

  // Scale Dark — assombrie encore
  static const Color amberDark1  = Color(0xFF100B00);
  static const Color amberDark2  = Color(0xFF181200);
  static const Color amberDark3  = Color(0xFF261D00);
  static const Color amberDark4  = Color(0xFF332700);
  static const Color amberDark5  = Color(0xFF413200);
  static const Color amberDark6  = Color(0xFF533F00);
  static const Color amberDark7  = Color(0xFF6B5200);
  static const Color amberDark8  = Color(0xFF846600);
  static const Color amberDark9  = Color(0xFFC88A18); // ★ plus sombre
  static const Color amberDark10 = Color(0xFFB87A14);
  static const Color amberDark11 = Color(0xFFFFB840);
  static const Color amberDark12 = Color(0xFFFFE0A0);

  // ═══════════════════════════════════════════════════════════════
  // GRAY — SCALE LIGHT (assombrie encore)
  // ═══════════════════════════════════════════════════════════════
  static const Color gray1  = Color(0xFFF0F0F5);
  static const Color gray2  = Color(0xFFE8E8F0);
  static const Color gray3  = Color(0xFFDFDFE8);
  static const Color gray4  = Color(0xFFD6D6E0);
  static const Color gray5  = Color(0xFFCCCDD8);
  static const Color gray6  = Color(0xFFC2C3CF);
  static const Color gray7  = Color(0xFFB5B6C4);
  static const Color gray8  = Color(0xFFA0A1B2);
  static const Color gray9  = Color(0xFF777885);
  static const Color gray10 = Color(0xFF6B6C7A);
  static const Color gray11 = Color(0xFF4F505C);
  static const Color gray12 = Color(0xFF141418);

  // ═══════════════════════════════════════════════════════════════
  // GRAY — SCALE DARK (assombrie encore)
  // ═══════════════════════════════════════════════════════════════
  static const Color grayDark1  = Color(0xFF050508);
  static const Color grayDark2  = Color(0xFF0C0C10);
  static const Color grayDark3  = Color(0xFF131318);
  static const Color grayDark4  = Color(0xFF19191F);
  static const Color grayDark5  = Color(0xFF1F1F26);
  static const Color grayDark6  = Color(0xFF27272F);
  static const Color grayDark7  = Color(0xFF32323C);
  static const Color grayDark8  = Color(0xFF454550);
  static const Color grayDark9  = Color(0xFF51515E);
  static const Color grayDark10 = Color(0xFF5E5E6C);
  static const Color grayDark11 = Color(0xFF9999A8);
  static const Color grayDark12 = Color(0xFFD8D8E0);

  // ═══════════════════════════════════════════════════════════════
  // STATUTS SÉMANTIQUES (assombris)
  // ═══════════════════════════════════════════════════════════════
  static const Color success        = Color(0xFF155A33);
  static const Color successLight   = Color(0xFFC8E6D9);
  static const Color warning        = Color(0xFFC47D0A);
  static const Color warningLight   = Color(0xFFFDF2E0);
  static const Color error          = Color(0xFF922B21);
  static const Color errorLight     = Color(0xFFF2E0E0);
  static const Color info           = Color(0xFF1B5E8C);
  static const Color infoLight      = Color(0xFFD0E3F0);

  // ═══════════════════════════════════════════════════════════════
  // TOKENS SÉMANTIQUES — LIGHT MODE
  // ═══════════════════════════════════════════════════════════════
  static const Color primaryLight       = teal9;       // #009A9E
  static const Color primaryLightHover  = teal10;      // #008C90
  static const Color primaryLightBg     = teal1;       // #F0FAFA
  static const Color primaryLightBorder = teal6;       // #50D3D5
  static const Color primaryLightText   = teal11;      // #006568
  static const Color onPrimaryLight     = Color(0xFFFFFFFF);

  static const Color secondaryLight     = green7;      // #08664F
  static const Color secondaryLightBg   = green1;      // #EAF6F2
  static const Color secondaryLightText = green9;      // #054535
  static const Color onSecondaryLight   = Color(0xFFFFFFFF);

  static const Color accentLight        = amber9;      // #C28018
  static const Color accentLightBg      = amber1;      // #FFF5E6
  static const Color accentLightBorder  = amber6;      // #E6AA00
  static const Color accentLightText    = amber11;     // #7A4F00
  static const Color onAccentLight      = Color(0xFF3B2800);

  static const Color backgroundLight    = gray1;       // #F0F0F5
  static const Color surfaceLight       = Color(0xFFFFFFFF);
  static const Color surfaceElevLight   = gray2;       // #E8E8F0
  static const Color borderLight        = gray6;       // #C2C3CF
  static const Color borderFocusLight   = teal7;       // #26C2C5
  static const Color textPrimaryLight   = gray12;      // #141418
  static const Color textSecondaryLight = gray11;      // #4F505C
  static const Color textPlaceholder    = gray9;       // #777885
  static const Color textDisabled       = gray10;      // #6B6C7A

  // ═══════════════════════════════════════════════════════════════
  // TOKENS SÉMANTIQUES — DARK MODE
  // ═══════════════════════════════════════════════════════════════
  static const Color primaryDark        = tealDark9;   // #20A8AB
  static const Color primaryDarkHover   = tealDark10;  // #1C979A
  static const Color primaryDarkBg      = tealDark1;   // #030D0D
  static const Color primaryDarkBorder  = tealDark6;   // #004648
  static const Color primaryDarkText    = tealDark11;  // #22B3B6
  static const Color onPrimaryDark      = Color(0xFF021E1F);

  static const Color secondaryDark      = greenDark9;  // #0C9973
  static const Color secondaryDarkBg    = greenDark1;  // #05140F
  static const Color secondaryDarkText  = greenDark11; // #14C595
  static const Color onSecondaryDark    = Color(0xFF021E1F);

  static const Color accentDark         = amberDark9;  // #C88A18
  static const Color accentDarkBg       = amberDark1;  // #100B00
  static const Color accentDarkBorder   = amberDark6;  // #533F00
  static const Color accentDarkText     = amberDark11; // #FFB840
  static const Color onAccentDark       = Color(0xFF1A1200);

  static const Color backgroundDark     = grayDark1;   // #050508
  static const Color surfaceDark        = grayDark2;   // #0C0C10
  static const Color surfaceElevDark    = grayDark3;   // #131318
  static const Color borderDark         = grayDark6;   // #27272F
  static const Color borderFocusDark    = tealDark7;   // #005457
  static const Color textPrimaryDark    = grayDark12;  // #D8D8E0
  static const Color textSecondaryDark  = grayDark11;  // #9999A8
  static const Color textPlaceholderDark = grayDark9;  // #51515E
  static const Color textDisabledDark   = grayDark10;  // #5E5E6C
}