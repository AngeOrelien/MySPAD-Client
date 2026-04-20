// lib/shared/widgets/dashboard_widgets.dart
// DashAppBar : toggle thème + logout branché sur AuthBloc
// DashSidebar : identique, inchangé
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/auth/auth_bloc.dart';
import '../../core/bloc/theme/theme_cubit.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/user_session.dart';

// ─────────────────────────────────────────────────────────────
// SidebarItem — modèle pour un item de nav dans la sidebar
// ─────────────────────────────────────────────────────────────
class SidebarItem {
  final String   label;
  final IconData icon;
  final IconData activeIcon;
  final int?     badge;
  const SidebarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.badge,
  });
}

// ─────────────────────────────────────────────────────────────
// DashAppBar
// ─────────────────────────────────────────────────────────────
class DashAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashAppBar({
    super.key,
    required this.title,
    this.notifCount = 0,
    this.showAlertButton = false,
    this.aiButton = false,
  });

  final String title;
  final int    notifCount;
  final bool   showAlertButton;
  final bool   aiButton;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final scheme  = Theme.of(context).colorScheme;
    final isDark  = context.watch<ThemeCubit>().isDark;
    final session = UserSession.instance;

    return AppBar(
      title: Text(title),
      actions: [
        // Toggle thème (disponible dans tous les dashboards)
        IconButton(
          iconSize: 20,
          icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          tooltip: isDark ? 'Mode clair' : 'Mode sombre',
          onPressed: () => context.read<ThemeCubit>().toggle(),
        ),
        // Notifications
        if (notifCount > 0)
          Badge(
            label: Text('$notifCount'),
            backgroundColor: AppColors.amber9,
            child: IconButton(
              iconSize: 20,
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          )
        else
          IconButton(
            iconSize: 20,
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        // Avatar + menu utilisateur
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 46),
            tooltip: session.name,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                session.initials,
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            onSelected: (val) {
              if (val == 'logout') {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
                // La navigation vers home est gérée dans main.dart
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(session.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(session.email,
                      style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                ]),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'profile',
                child: Row(children: [
                  Icon(Icons.person_outline, size: 16, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 10),
                  const Text('Mon profil', style: TextStyle(fontSize: 13)),
                ]),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(children: [
                  const Icon(Icons.logout, size: 16, color: AppColors.error),
                  const SizedBox(width: 10),
                  const Text('Déconnexion',
                      style: TextStyle(fontSize: 13, color: AppColors.error)),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DashSidebar
// ─────────────────────────────────────────────────────────────
class DashSidebar extends StatelessWidget {
  const DashSidebar({
    super.key,
    required this.navItems,
    required this.currentIndex,
    required this.onTap,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  final List<SidebarItem> navItems;
  final int               currentIndex;
  final ValueChanged<int> onTap;
  final bool              isCollapsed;
  final VoidCallback?     onToggleCollapse;

  static const double _full = 220;
  static const double _mini = 64;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final w      = isCollapsed ? _mini : _full;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: w,
      color: scheme.surface,
      child: Column(children: [
        // Header
        Container(
          height: 52,
          padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 14),
          alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
          decoration: BoxDecoration(border: Border(
              bottom: BorderSide(color: scheme.outline.withOpacity(0.25)))),
          child: isCollapsed
              ? Container(width: 30, height: 30,
              decoration: BoxDecoration(
                  color: scheme.primary, borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text('S',
                  style: TextStyle(color: scheme.onPrimary,
                      fontWeight: FontWeight.w800, fontSize: 14))))
              : Row(children: [
            Container(width: 28, height: 28,
                decoration: BoxDecoration(
                    color: scheme.primary, borderRadius: BorderRadius.circular(7)),
                child: Center(child: Text('S',
                    style: TextStyle(color: scheme.onPrimary,
                        fontWeight: FontWeight.w800, fontSize: 13)))),
            const SizedBox(width: 10),
            Expanded(child: Text('SPAD Cameroun',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: scheme.onSurface),
                overflow: TextOverflow.ellipsis)),
            if (onToggleCollapse != null)
              IconButton(
                  iconSize: 18,
                  icon: Icon(isCollapsed ? Icons.menu : Icons.menu_open),
                  onPressed: onToggleCollapse,
                  color: scheme.onSurfaceVariant),
          ]),
        ),

        // Nav items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            itemCount: navItems.length,
            itemBuilder: (ctx, i) {
              final item     = navItems[i];
              final selected = i == currentIndex;
              return Tooltip(
                message: isCollapsed ? item.label : '',
                child: InkWell(
                  onTap: () => onTap(i),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 40,
                    padding: EdgeInsets.symmetric(
                        horizontal: isCollapsed ? 0 : 10),
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    decoration: BoxDecoration(
                        color: selected ? scheme.primaryContainer : Colors.transparent,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: isCollapsed
                          ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        Icon(selected ? item.activeIcon : item.icon,
                            size: 18,
                            color: selected ? scheme.primary : scheme.onSurfaceVariant),
                        if (!isCollapsed) ...[
                          const SizedBox(width: 10),
                          Expanded(child: Text(item.label,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                  color: selected ? scheme.primary : scheme.onSurface),
                              overflow: TextOverflow.ellipsis)),
                          if (item.badge != null && item.badge! > 0)
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                    color: AppColors.amber9.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(999)),
                                child: Text('${item.badge}',
                                    style: const TextStyle(
                                        fontSize: 10, fontWeight: FontWeight.w600,
                                        color: AppColors.amber9))),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Footer logout
        Padding(
          padding: const EdgeInsets.all(8),
          child: Builder(builder: (ctx) => Tooltip(
            message: isCollapsed ? 'Déconnexion' : '',
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => ctx.read<AuthBloc>().add(const AuthLogoutRequested()),
              child: Container(
                height: 38,
                padding: EdgeInsets.symmetric(
                    horizontal: isCollapsed ? 0 : 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: isCollapsed
                      ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.logout, size: 18, color: AppColors.error),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 10),
                      const Text('Déconnexion',
                          style: TextStyle(fontSize: 12, color: AppColors.error,
                              fontWeight: FontWeight.w500)),
                    ],
                  ],
                ),
              ),
            ),
          )),
        ),
      ]),
    );
  }
}
