// lib/core/theme/app_theme.dart
// Tailles compactes : boutons vertical 10px, texte -1pt partout
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static const double r4  = 4;
  static const double r8  = 8;
  static const double r10 = 10;
  static const double r12 = 12;
  static const double r14 = 14;
  static const double r20 = 20;
  static const double r24 = 24;

  // ═══════════════════════════════════════════════════════════
  // LIGHT
  // ═══════════════════════════════════════════════════════════
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness:   Brightness.light,
    fontFamily:   'Inter',

    colorScheme: const ColorScheme.light(
      primary:             AppColors.teal9,
      onPrimary:           Colors.white,
      primaryContainer:    AppColors.teal3,
      onPrimaryContainer:  AppColors.teal12,
      secondary:           AppColors.green7,
      onSecondary:         Colors.white,
      secondaryContainer:  AppColors.green1,
      onSecondaryContainer: AppColors.green9,
      tertiary:            AppColors.amber9,
      onTertiary:          Color(0xFF4D3200),
      tertiaryContainer:   AppColors.amber1,
      onTertiaryContainer: AppColors.amber12,
      surface:             Colors.white,
      onSurface:           AppColors.gray12,
      surfaceVariant:      AppColors.gray2,
      onSurfaceVariant:    AppColors.gray11,
      outline:             AppColors.gray6,
      outlineVariant:      AppColors.gray4,
      error:               AppColors.error,
      onError:             Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.gray1,
    textTheme: AppTextStyles.textTheme,

    appBarTheme: const AppBarTheme(
      backgroundColor:      Colors.white,
      foregroundColor:      AppColors.gray12,
      surfaceTintColor:     Colors.transparent,
      elevation:            0,
      scrolledUnderElevation: 0.5,
      centerTitle:          false,
      systemOverlayStyle:   SystemUiOverlayStyle.dark,
      // titre compact
      titleTextStyle: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: AppColors.gray12, fontFamily: 'Inter',
      ),
      toolbarHeight: 52,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:  Colors.white,
      indicatorColor:   AppColors.teal3,
      surfaceTintColor: Colors.transparent,
      elevation:        8,
      height:           60, // moins haut
      labelTextStyle: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.selected)) {
          return AppTextStyles.labelSmall.copyWith(
              color: AppColors.teal9, fontWeight: FontWeight.w600);
        }
        return AppTextStyles.labelSmall.copyWith(color: AppColors.gray10);
      }),
      iconTheme: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.teal9, size: 20);
        }
        return const IconThemeData(color: AppColors.gray9, size: 20);
      }),
    ),

    cardTheme: CardThemeData(
      color:            Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation:        0,
      margin:           EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r12),
        side: const BorderSide(color: AppColors.gray4),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled:          true,
      fillColor:       AppColors.gray2,
      isDense:         true,  // ← compact
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border:         OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: AppColors.gray5)),
      enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: AppColors.gray5)),
      focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: AppColors.teal9, width: 2)),
      errorBorder:    OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: AppColors.error)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: AppColors.error, width: 2)),
      hintStyle:  const TextStyle(color: AppColors.gray9,  fontSize: 13),
      labelStyle: const TextStyle(color: AppColors.gray10, fontSize: 13),
      prefixIconColor: AppColors.gray9,
      suffixIconColor: AppColors.gray9,
    ),

    // Boutons compacts : vertical 10px
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((s) =>
        s.contains(WidgetState.disabled) ? AppColors.gray4 : AppColors.teal9),
        foregroundColor: WidgetStateProperty.resolveWith((s) =>
        s.contains(WidgetState.disabled) ? AppColors.gray9 : Colors.white),
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(r10))),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(r10))),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        elevation: WidgetStateProperty.all(0),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.teal9),
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.teal7, width: 1.5)),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(r10))),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor:  AppColors.gray3,
      selectedColor:    AppColors.teal3,
      labelStyle: const TextStyle(fontSize: 11, fontFamily: 'Inter'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: const BorderSide(color: AppColors.gray5),
    ),

    dividerTheme: const DividerThemeData(
        color: AppColors.gray4, thickness: 1, space: 1),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.teal9,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r14)),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor:  Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r20)),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor:  Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 16,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(r20))),
      clipBehavior: Clip.antiAlias,
    ),

    listTileTheme: ListTileThemeData(
      dense: true,
      contentPadding:    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r10)),
      selectedTileColor: AppColors.teal1,
      selectedColor:     AppColors.teal9,
    ),
  );

  // ═══════════════════════════════════════════════════════════
  // DARK
  // ═══════════════════════════════════════════════════════════
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness:   Brightness.dark,
    fontFamily:   'Inter',

    colorScheme: const ColorScheme.dark(
      primary:             AppColors.tealDark9,
      onPrimary:           Color(0xFF032728),
      primaryContainer:    AppColors.tealDark3,
      onPrimaryContainer:  AppColors.tealDark12,
      secondary:           Color(0xFF14C99A),
      onSecondary:         Color(0xFF032728),
      secondaryContainer:  Color(0xFF0E3324),
      onSecondaryContainer: Color(0xFFA8F0D8),
      tertiary:            Color(0xFFFFB224),
      onTertiary:          Color(0xFF1A1200),
      surface:             Color(0xFF0D1B1B),
      onSurface:           Color(0xFFEEEEF0),
      surfaceVariant:      Color(0xFF0F2424),
      onSurfaceVariant:    Color(0xFFB2B3BD),
      outline:             Color(0xFF2A3F3F),
      outlineVariant:      Color(0xFF1A2E2E),
      error:               Color(0xFFFF6B6B),
      onError:             Color(0xFF300000),
    ),

    scaffoldBackgroundColor: const Color(0xFF081313),
    textTheme: AppTextStyles.textTheme,

    appBarTheme: const AppBarTheme(
      backgroundColor:      Color(0xFF0D1B1B),
      foregroundColor:      Color(0xFFEEEEF0),
      surfaceTintColor:     Colors.transparent,
      elevation:            0,
      scrolledUnderElevation: 0.5,
      systemOverlayStyle:   SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: Color(0xFFEEEEF0), fontFamily: 'Inter',
      ),
      toolbarHeight: 52,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor:  const Color(0xFF0D1B1B),
      indicatorColor:   AppColors.tealDark3,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      height: 60,
      labelTextStyle: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.selected)) {
          return AppTextStyles.labelSmall.copyWith(
              color: AppColors.tealDark9, fontWeight: FontWeight.w600);
        }
        return AppTextStyles.labelSmall.copyWith(
            color: const Color(0xFF8A9A9A));
      }),
      iconTheme: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.tealDark9, size: 20);
        }
        return const IconThemeData(color: Color(0xFF8A9A9A), size: 20);
      }),
    ),

    cardTheme: CardThemeData(
      color:            const Color(0xFF0D1B1B),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r12),
        side: const BorderSide(color: Color(0xFF1A2E2E)),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled:          true,
      fillColor:       const Color(0xFF0F2424),
      isDense:         true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border:         OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: Color(0xFF2A3F3F))),
      enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: Color(0xFF2A3F3F))),
      focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: AppColors.tealDark9, width: 2)),
      errorBorder:    OutlineInputBorder(borderRadius: BorderRadius.circular(r10),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B))),
      hintStyle:  const TextStyle(color: Color(0xFF6C8888), fontSize: 13),
      labelStyle: const TextStyle(color: Color(0xFF8AACAC), fontSize: 13),
      prefixIconColor: const Color(0xFF6C8888),
      suffixIconColor: const Color(0xFF6C8888),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.tealDark9),
        foregroundColor: WidgetStateProperty.all(const Color(0xFF032728)),
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(r10))),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.tealDark9),
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.tealDark7, width: 1.5)),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(r10))),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.tealDark9,
      foregroundColor: const Color(0xFF032728),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r14)),
    ),

    dividerTheme: const DividerThemeData(
        color: Color(0xFF1A2E2E), thickness: 1, space: 1),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor:  Color(0xFF0D1B1B),
      surfaceTintColor: Colors.transparent,
      elevation: 16,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(r20))),
      clipBehavior: Clip.antiAlias,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor:  const Color(0xFF0D1B1B),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r20)),
    ),

    listTileTheme: ListTileThemeData(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r10)),
      selectedTileColor: AppColors.tealDark3,
      selectedColor:     AppColors.tealDark9,
    ),

    chipTheme: ChipThemeData(
      labelStyle: const TextStyle(fontSize: 11, fontFamily: 'Inter'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
  );
}
