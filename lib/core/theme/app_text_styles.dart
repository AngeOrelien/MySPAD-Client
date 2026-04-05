import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  // TextStyle : les proprites essentielles
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryLightText,
    letterSpacing: -0.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5, // espacement entre les lignes
  );

  static TextTheme get textTheme => const TextTheme(
    displayLarge: heading1,
    bodyMedium: body,
  );

}