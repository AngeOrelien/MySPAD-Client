// lib/core/theme/app_theme.dart
//
// Thèmes SPAD Cameroun — Material 3
// ─────────────────────────────────────────────
// Usage dans MaterialApp :
//   theme:      AppTheme.lightTheme,
//   darkTheme:  AppTheme.darkTheme,
//   themeMode:  ThemeMode.system,
// ─────────────────────────────────────────────
// Pour basculer manuellement via un Cubit/Provider :
//   themeMode: ThemeMode.light  ou  ThemeMode.dark
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────────────────
  // Constantes de forme partagées light + dark
  // ─────────────────────────────────────────────────────────
  static const double _radiusSm  = 6.0;
  static const double _radiusMd  = 10.0;
  static const double _radiusLg  = 14.0;
  static const double _radiusXl  = 20.0;
  static const double _radiusFull = 999.0; // pill

  static const _shapeSm   = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_radiusSm)));
  static const _shapeMd   = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_radiusMd)));
  static const _shapeLg   = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_radiusLg)));
  static const _shapeXl   = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_radiusXl)));
  static const _shapePill = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_radiusFull)));

  // ═══════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ═══════════════════════════════════════════════════════════
  static ThemeData get lightTheme => ThemeData(
    useMaterial3:              true,
    brightness:                Brightness.light,
    fontFamily:                'Inter', // fallback global

    // ── ColorScheme ──────────────────────────────────────────
    colorScheme: const ColorScheme.light(
      // Primaire
      primary:          AppColors.primaryLight,       // #00C7CC
      onPrimary:        AppColors.onPrimaryLight,     // #FFFFFF
      primaryContainer: AppColors.teal3,              // #D1FBFB (fond chips/badges)
      onPrimaryContainer: AppColors.teal12,           // #004345

      // Secondaire
      secondary:          AppColors.secondaryLight,   // #0C8C6B
      onSecondary:        AppColors.onSecondaryLight, // #FFFFFF
      secondaryContainer: AppColors.green1,           // #F0FAF6
      onSecondaryContainer: AppColors.green9,         // #075C45

      // Tertiaire → Accent
      tertiary:          AppColors.accentLight,       // #F5A623
      onTertiary:        AppColors.onAccentLight,     // #4D3200
      tertiaryContainer: AppColors.amber1,            // #FFFCF0
      onTertiaryContainer: AppColors.amber12,         // #4D3200

      // Surface & Background
      surface:           AppColors.surfaceLight,      // #FFFFFF
      onSurface:         AppColors.textPrimaryLight,  // #1F1F25
      surfaceVariant:    AppColors.surfaceElevLight,  // #F9F9FB
      onSurfaceVariant:  AppColors.textSecondaryLight,// #62636C
      background:        AppColors.backgroundLight,   // #FCFCFD
      onBackground:      AppColors.textPrimaryLight,

      // Outline
      outline:           AppColors.borderLight,       // #D8D9E0
      outlineVariant:    AppColors.gray5,             // #E0E1E7

      // Erreur
      error:             AppColors.error,             // #C0392B
      onError:           Colors.white,
      errorContainer:    AppColors.errorLight,        // #FDEDEC
      onErrorContainer:  AppColors.error,

      // Shadow / Scrim
      shadow:            Color(0x1A000000),           // 10% opaque
      scrim:             Color(0x80000000),
    ),

    scaffoldBackgroundColor: AppColors.backgroundLight,

    // ── TextTheme ────────────────────────────────────────────
    textTheme: AppTextStyles.textTheme,

    // ── AppBar ───────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      // backgroundColor:  AppColors.surfaceLight,
      backgroundColor: AppColors.primaryLight,
      foregroundColor:  AppColors.textPrimaryLight,
      surfaceTintColor: Colors.transparent,
      elevation:        0,
      scrolledUnderElevation: 1,
      centerTitle:      false,
      titleTextStyle:   AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryLight,
        size:  24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shape: const Border(
        bottom: BorderSide(color: AppColors.borderLight, width: 1),
      ),
    ),

    // ── BottomNavigationBar ──────────────────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:      AppColors.surfaceLight,
      selectedItemColor:    AppColors.primaryLight,
      unselectedItemColor:  AppColors.textSecondaryLight,
      selectedLabelStyle:   AppTextStyles.labelSmall.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTextStyles.labelSmall,
      type:                 BottomNavigationBarType.fixed,
      elevation:            8,
      showSelectedLabels:   true,
      showUnselectedLabels: true,
    ),

    // ── NavigationBar (Material 3) ───────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:          AppColors.surfaceLight,
      indicatorColor:           AppColors.teal3,    // fond icône active
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: AppColors.primaryLight);
        }
        return const IconThemeData(color: AppColors.textSecondaryLight);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTextStyles.labelSmall.copyWith(
            color:      AppColors.primaryLight,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondaryLight,
        );
      }),
      elevation:    8,
      surfaceTintColor: Colors.transparent,
    ),

    // ── Drawer / Sidebar ─────────────────────────────────────
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation:       16,
      width:           280,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight:    Radius.circular(_radiusXl),
          bottomRight: Radius.circular(_radiusXl),
        ),
      ),
    ),

    // ── Card ─────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color:        AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation:    0,
      margin:       EdgeInsets.zero,
      shape:        _shapeLg,
      clipBehavior: Clip.antiAlias,
    ),

    // ── ElevatedButton ───────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) return AppColors.gray4;
          if (states.contains(MaterialState.pressed))  return AppColors.primaryLightHover;
          return AppColors.primaryLight;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) return AppColors.textDisabled;
          return AppColors.onPrimaryLight;
        }),
        textStyle: MaterialStateProperty.all(AppTextStyles.labelLarge),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape: MaterialStateProperty.all(_shapeMd),
        elevation: MaterialStateProperty.all(0),
        overlayColor: MaterialStateProperty.all(
          AppColors.onPrimaryLight.withOpacity(0.08),
        ),
      ),
    ),

    // ── OutlinedButton ───────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.primaryLight),
        textStyle:       MaterialStateProperty.all(AppTextStyles.labelLarge),
        side:            MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return const BorderSide(color: AppColors.primaryLightHover, width: 1.5);
          }
          return const BorderSide(color: AppColors.primaryLightBorder, width: 1.5);
        }),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape:     MaterialStateProperty.all(_shapeMd),
        elevation: MaterialStateProperty.all(0),
      ),
    ),

    // ── TextButton ───────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.primaryLight),
        textStyle:       MaterialStateProperty.all(AppTextStyles.labelMedium),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        shape: MaterialStateProperty.all(_shapeSm),
      ),
    ),

    // ── FloatingActionButton ─────────────────────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentLight,
      foregroundColor: AppColors.onAccentLight,
      elevation:       4,
      shape:           RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_radiusLg)),
      ),
    ),

    // ── TextField / InputDecoration ──────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled:           true,
      fillColor:        AppColors.gray2,
      contentPadding:   const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.gray4),
      ),
      hintStyle:  AppTextStyles.bodyMedium.copyWith(color: AppColors.textPlaceholder),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      prefixIconColor: AppColors.textSecondaryLight,
      suffixIconColor: AppColors.textSecondaryLight,
    ),

    // ── Chip ─────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor:        AppColors.gray3,
      selectedColor:          AppColors.teal3,
      labelStyle:             AppTextStyles.labelMedium,
      padding:                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      side:                   const BorderSide(color: AppColors.borderLight),
      shape:                  _shapePill,
      showCheckmark:          false,
    ),

    // ── Divider ──────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color:     AppColors.borderLight,
      thickness: 1,
      space:     1,
    ),

    // ── ListTile ─────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      titleTextStyle:  AppTextStyles.bodyLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      subtitleTextStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondaryLight,
      ),
      iconColor:         AppColors.textSecondaryLight,
      selectedColor:     AppColors.primaryLight,
      selectedTileColor: AppColors.teal2,
      shape:             _shapeMd,
    ),

    // ── SnackBar ─────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.gray12,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: Colors.white,
      ),
      actionTextColor: AppColors.teal9,
      shape:           _shapeMd,
      behavior:        SnackBarBehavior.floating,
      elevation:       6,
    ),

    // ── Dialog ───────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation:    24,
      shape:        _shapeXl,
      titleTextStyle: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondaryLight,
      ),
    ),

    // ── BottomSheet ──────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation:        16,
      modalElevation:   16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft:  Radius.circular(_radiusXl),
          topRight: Radius.circular(_radiusXl),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // ── TabBar ───────────────────────────────────────────────
    tabBarTheme: TabBarThemeData(
      labelColor:         AppColors.primaryLight,
      unselectedLabelColor: AppColors.textSecondaryLight,
      labelStyle:         AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTextStyles.labelMedium,
      indicator:          UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      indicatorSize:      TabBarIndicatorSize.label,
      dividerColor:       AppColors.borderLight,
    ),

    // ── Switch ───────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColors.onPrimaryLight;
        return AppColors.gray7;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColors.primaryLight;
        return AppColors.gray5;
      }),
    ),

    // ── CheckBox ─────────────────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColors.primaryLight;
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(AppColors.onPrimaryLight),
      side: const BorderSide(color: AppColors.borderLight, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // ── ProgressIndicator ────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color:             AppColors.primaryLight,
      linearTrackColor:  AppColors.teal2,
      circularTrackColor: AppColors.teal2,
    ),
  );

  // ═══════════════════════════════════════════════════════════
  //  DARK THEME
  // ═══════════════════════════════════════════════════════════
  static ThemeData get darkTheme => ThemeData(
    useMaterial3:              true,
    brightness:                Brightness.dark,
    fontFamily:                'Inter',

    // ── ColorScheme ──────────────────────────────────────────
    colorScheme: const ColorScheme.dark(
      // Primaire
      primary:          AppColors.primaryDark,        // #3CDADD  ★
      onPrimary:        AppColors.onPrimaryDark,      // #032728
      primaryContainer: AppColors.tealDark3,          // #002D2E
      onPrimaryContainer: AppColors.tealDark12,       // #B5F1F2

      // Secondaire
      secondary:          AppColors.secondaryDark,    // #14C99A
      onSecondary:        AppColors.onSecondaryDark,  // #032728
      secondaryContainer: AppColors.greenDark2,       // #102419
      onSecondaryContainer: AppColors.greenDark12,    // #A8F0D8

      // Tertiaire → Accent
      tertiary:          AppColors.accentDark,        // #FFB224
      onTertiary:        AppColors.onAccentDark,      // #1A1200
      tertiaryContainer: AppColors.amberDark2,        // #221A00
      onTertiaryContainer: AppColors.amberDark12,     // #FFECA8

      // Surface & Background
      surface:           AppColors.surfaceDark,       // #19191B
      onSurface:         AppColors.textPrimaryDark,   // #EEEEF0
      surfaceVariant:    AppColors.surfaceElevDark,   // #222325
      onSurfaceVariant:  AppColors.textSecondaryDark, // #B2B3BD
      background:        AppColors.backgroundDark,    // #111113
      onBackground:      AppColors.textPrimaryDark,

      // Outline
      outline:           AppColors.borderDark,        // #393A40
      outlineVariant:    AppColors.grayDark5,         // #303136

      // Erreur
      error:             AppColors.error,
      onError:           Colors.white,
      errorContainer:    Color(0xFF4D1A17),
      onErrorContainer:  AppColors.errorLight,

      // Shadow / Scrim
      shadow:            Color(0x33000000),
      scrim:             Color(0x99000000),
    ),

    scaffoldBackgroundColor: AppColors.backgroundDark,

    // ── TextTheme ────────────────────────────────────────────
    textTheme: AppTextStyles.textTheme,

    // ── AppBar ───────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor:  AppColors.surfaceDark,
      foregroundColor:  AppColors.textPrimaryDark,
      surfaceTintColor: Colors.transparent,
      elevation:        0,
      scrolledUnderElevation: 1,
      centerTitle:      false,
      titleTextStyle:   AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size:  24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: const Border(
        bottom: BorderSide(color: AppColors.borderDark, width: 1),
      ),
    ),

    // ── BottomNavigationBar ──────────────────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:      AppColors.surfaceDark,
      selectedItemColor:    AppColors.primaryDark,
      unselectedItemColor:  AppColors.textSecondaryDark,
      selectedLabelStyle:   AppTextStyles.labelSmall.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTextStyles.labelSmall,
      type:                 BottomNavigationBarType.fixed,
      elevation:            8,
    ),

    // ── NavigationBar ────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:  AppColors.surfaceDark,
      indicatorColor:   AppColors.tealDark3,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: AppColors.primaryDark);
        }
        return const IconThemeData(color: AppColors.textSecondaryDark);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTextStyles.labelSmall.copyWith(
            color:      AppColors.primaryDark,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondaryDark,
        );
      }),
      elevation:       8,
      surfaceTintColor: Colors.transparent,
    ),

    // ── Drawer ───────────────────────────────────────────────
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation:       16,
      width:           280,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight:    Radius.circular(_radiusXl),
          bottomRight: Radius.circular(_radiusXl),
        ),
      ),
    ),

    // ── Card ─────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color:            AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation:        0,
      margin:           EdgeInsets.zero,
      shape:            _shapeLg,
      clipBehavior:     Clip.antiAlias,
    ),

    // ── ElevatedButton ───────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) return AppColors.grayDark5;
          if (states.contains(MaterialState.pressed))  return AppColors.primaryDarkHover;
          return AppColors.primaryDark;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) return AppColors.textDisabledDark;
          return AppColors.onPrimaryDark;
        }),
        textStyle: MaterialStateProperty.all(AppTextStyles.labelLarge),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape:     MaterialStateProperty.all(_shapeMd),
        elevation: MaterialStateProperty.all(0),
      ),
    ),

    // ── OutlinedButton ───────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.primaryDark),
        textStyle:       MaterialStateProperty.all(AppTextStyles.labelLarge),
        side: MaterialStateProperty.all(
          const BorderSide(color: AppColors.tealDark7, width: 1.5),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape:     MaterialStateProperty.all(_shapeMd),
        elevation: MaterialStateProperty.all(0),
      ),
    ),

    // ── TextButton ───────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.primaryDark),
        textStyle:       MaterialStateProperty.all(AppTextStyles.labelMedium),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        shape: MaterialStateProperty.all(_shapeSm),
      ),
    ),

    // ── FloatingActionButton ─────────────────────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentDark,
      foregroundColor: AppColors.onAccentDark,
      elevation:       4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_radiusLg)),
      ),
    ),

    // ── TextField / InputDecoration ──────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled:          true,
      fillColor:       AppColors.grayDark3,
      contentPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMd),
        borderSide:   const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle:  AppTextStyles.bodyMedium.copyWith(color: AppColors.textPlaceholderDark),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      prefixIconColor: AppColors.textSecondaryDark,
      suffixIconColor: AppColors.textSecondaryDark,
    ),

    // ── Chip ─────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor:  AppColors.grayDark4,
      selectedColor:    AppColors.tealDark3,
      labelStyle:       AppTextStyles.labelMedium,
      padding:          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      side:             const BorderSide(color: AppColors.borderDark),
      shape:            _shapePill,
      showCheckmark:    false,
    ),

    // ── Divider ──────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color:     AppColors.borderDark,
      thickness: 1,
      space:     1,
    ),

    // ── ListTile ─────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      titleTextStyle:  AppTextStyles.bodyLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      subtitleTextStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      iconColor:         AppColors.textSecondaryDark,
      selectedColor:     AppColors.primaryDark,
      selectedTileColor: AppColors.tealDark3,
      shape:             _shapeMd,
    ),

    // ── SnackBar ─────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.grayDark4,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      actionTextColor: AppColors.primaryDark,
      shape:           _shapeMd,
      behavior:        SnackBarBehavior.floating,
      elevation:       6,
    ),

    // ── Dialog ───────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation:    24,
      shape:        _shapeXl,
      titleTextStyle: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondaryDark,
      ),
    ),

    // ── BottomSheet ──────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation:       16,
      modalElevation:  16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft:  Radius.circular(_radiusXl),
          topRight: Radius.circular(_radiusXl),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // ── TabBar ───────────────────────────────────────────────
    tabBarTheme: TabBarThemeData(
      labelColor:           AppColors.primaryDark,
      unselectedLabelColor: AppColors.textSecondaryDark,
      labelStyle:         AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTextStyles.labelMedium,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      indicatorSize:  TabBarIndicatorSize.label,
      dividerColor:   AppColors.borderDark,
    ),

    // ── Switch ───────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColors.onPrimaryDark;
        return AppColors.grayDark8;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColors.primaryDark;
        return AppColors.grayDark6;
      }),
    ),

    // ── CheckBox ─────────────────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColors.primaryDark;
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(AppColors.onPrimaryDark),
      side: const BorderSide(color: AppColors.borderDark, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // ── ProgressIndicator ────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color:              AppColors.primaryDark,
      linearTrackColor:   AppColors.tealDark3,
      circularTrackColor: AppColors.tealDark3,
    ),
  );
}