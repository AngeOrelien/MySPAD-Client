// lib/core/bloc/theme/theme_cubit.dart
// ─── THEME CUBIT ──────────────────────────────────────────────
// Cubit = Bloc simplifié. Ici pour light/dark/system.
// Utilisation : context.read<ThemeCubit>().toggle()
// ─────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggle() => emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  void setLight()  => emit(ThemeMode.light);
  void setDark()   => emit(ThemeMode.dark);
  void setSystem() => emit(ThemeMode.system);

  bool get isDark => state == ThemeMode.dark;
}
