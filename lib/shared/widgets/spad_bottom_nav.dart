// lib/shared/widgets/spad_bottom_nav.dart
//
// ─── BOTTOM NAVIGATION BAR ───────────────────────────────────
// Affichée UNIQUEMENT sur mobile (< 600dp).
// Reçoit la liste d'items du rôle courant et l'index actif.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/spad_nav_item.dart';
import '../../core/theme/app_colors.dart';

class SpadBottomNav extends StatelessWidget {
  const SpadBottomNav({
    super.key,
    required this.items,         // items du rôle connecté
    required this.currentIndex,  // index de la page active
    required this.onTap,         // callback quand on tape un item
  });

  final List<SpadNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap; // ValueChanged<int> = void Function(int)

  @override
  Widget build(BuildContext context) {
    // Theme.of(context) lit le thème actif (light ou dark)
    // On utilise les couleurs du thème plutôt que AppColors directement
    final scheme = Theme.of(context).colorScheme;

    return NavigationBar(
      // L'index sélectionné vient du parent (SpadScaffold)
      selectedIndex: currentIndex,

      // Callback : remonte l'index tapé au parent
      onDestinationSelected: onTap,

      // AnimationDuration : transition entre items
      animationDuration: const Duration(milliseconds: 300),

      // Construit un NavigationDestination pour chaque item
      destinations: items.map((item) {
        return NavigationDestination(
          // Icône inactive
          icon: _buildIcon(item, false, scheme),
          // Icône active (sélectionnée)
          selectedIcon: _buildIcon(item, true, scheme),
          label: item.label,
        );
      }).toList(), // .map() retourne un Iterable → .toList() pour List
    );
  }

  Widget _buildIcon(SpadNavItem item, bool selected, ColorScheme scheme) {
    // Si l'item a un badge (notifications), on l'entoure d'un Badge
    if (item.badge != null && item.badge! > 0) {
      return Badge(
        // Badge Material 3 : affiche le chiffre en superposition
        label: Text('${item.badge}'),
        backgroundColor: AppColors.accentLight,
        textColor: AppColors.onAccentLight,
        child: Icon(selected ? item.activeIcon : item.icon),
      );
    }
    return Icon(selected ? item.activeIcon : item.icon);
  }
}