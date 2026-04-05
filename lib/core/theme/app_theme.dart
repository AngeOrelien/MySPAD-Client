import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // Getter statis -> AppTheme.lightTheme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true, // couleur de fond
    brightness: Brightness.light,

    // couleur du texte
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.onPrimaryLight,
      surface: AppColors.surfaceLight,
      // ignore: deprecated_member_use
      background: AppColors.backgroundLight,
      error: AppColors.error,
    ),

    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: AppTextStyle.textTheme,

    // le sous theme de chaque widget
    // appBar :
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    // button :
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      surface: AppColors.surfaceDark,
      background: AppColors.backgroundDark,
    ),

    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: AppTextStyle.textTheme,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
