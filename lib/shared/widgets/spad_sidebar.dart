// lib/shared/widgets/spad_sidebar.dart
//
// ─── SIDEBAR RESPONSIVE ──────────────────────────────────────
// Affichée sur tablette (fixe) et desktop (avec collapse).
// Sur tablette  → toujours visible, largeur 260dp
// Sur desktop   → visible par défaut, bouton hamburger pour fermer
//
// Structure visuelle :
//   ┌─────────────────┐
//   │  Logo SPAD      │  ← header
//   │  Nom utilisateur│
//   ├─────────────────┤
//   │  [icône] Item 1 │  ← items de navigation
//   │  [icône] Item 2 │
//   │  [icône] Item 3 │
//   ├─────────────────┤
//   │  [icône] Déconn.│  ← footer
//   └─────────────────┘
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/spad_nav_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive_utils.dart';

class SpadSidebar extends StatelessWidget {
  const SpadSidebar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.isCollapsed = false,   // desktop : sidebar réduite (icônes seulement)
    this.onToggleCollapse,      // callback bouton hamburger desktop
    this.userName,              // nom de l'utilisateur connecté
    this.userRole,              // rôle affiché sous le nom
  });

  final List<SpadNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse; // VoidCallback = void Function()
  final String? userName;
  final String? userRole;

  // Largeur selon l'état collapse
  static const double _expandedWidth  = 260;
  static const double _collapsedWidth = 72;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width  = isCollapsed ? _collapsedWidth : _expandedWidth;

    // AnimatedContainer : anime la transition de largeur au collapse
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve:    Curves.easeInOut,
      width:    width,
      // Couleur surface du thème actif
      color:    scheme.surface,
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────
          _buildHeader(context, scheme),

          // ── Items de navigation ─────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildNavItem(context, items[index], index, scheme);
              },
            ),
          ),

          // ── Divider + bouton déconnexion ────────────────
          _buildFooter(context, scheme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme scheme) {
    return Container(
      height:  72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // Bordure basse séparant le header des items
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: scheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo SPAD — cercle teal avec initiales
          Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              color:        scheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'S',
                style: AppTextStyles.titleLarge.copyWith(
                  color:      scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Nom + rôle (masqués si collapsed)
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPAD Cameroun',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: scheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (userName != null)
                    Text(
                      userName!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],

          // Bouton hamburger (desktop seulement)
          if (onToggleCollapse != null)
            IconButton(
              icon:    Icon(isCollapsed ? Icons.menu : Icons.menu_open),
              onPressed: onToggleCollapse,
              color:   scheme.onSurfaceVariant,
              tooltip: isCollapsed ? 'Ouvrir menu' : 'Fermer menu',
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    SpadNavItem item,
    int index,
    ColorScheme scheme,
  ) {
    final isSelected = index == currentIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          // InkWell : effet ripple au tap
          borderRadius: BorderRadius.circular(10),
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height:  44,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 0 : 12,
            ),
            decoration: BoxDecoration(
              // Fond coloré si sélectionné
              color: isSelected
                  ? scheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center  // centrer l'icône si collapsed
                  : MainAxisAlignment.start,
              children: [
                // Icône active ou inactive
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size:  20,
                  color: isSelected
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
                ),

                // Label (masqué si collapsed)
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? scheme.primary
                            : scheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Badge notification
                  if (item.badge != null && item.badge! > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:        AppColors.accentLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${item.badge}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onAccentLight,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: scheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color:        Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // TODO Phase 4 : déclencher AuthBloc.logout()
          },
          child: Container(
            height:  44,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 0 : 12,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.logout,
                  size:  20,
                  color: scheme.error,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Text(
                    'Déconnexion',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: scheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}