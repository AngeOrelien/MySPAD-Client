// lib/shared/widgets/dashboard_widgets.dart
//
// ─── POURQUOI CE FICHIER EXISTE ──────────────────────────────
// Dart : une classe nommée _NomClasse (avec underscore) est PRIVÉE
// au fichier où elle est définie. Elle ne peut pas être importée.
//
// ERREUR QUI CAUSAIT LE PROBLÈME :
//   famille_shell.dart importait avs_shell.dart et essayait
//   d'utiliser _NotifBadge, _SettingsSheet, _ProfileSheet.
//   Ces classes commençant par _ → invisibles depuis l'extérieur.
//
// SOLUTION : mettre ces widgets dans un fichier PARTAGÉ avec
// des noms PUBLICS (sans underscore). Tous les shells l'importent.
//
// IMPORT DANS CHAQUE SHELL :
//   import '../../../shared/widgets/dashboard_widgets.dart';
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/auth/auth_bloc.dart';
import '../../core/bloc/theme/theme_cubit.dart';
import '../../core/utils/user_session.dart';

// ═══════════════════════════════════════════════════════════
// BADGE DE NOTIFICATION
// ═══════════════════════════════════════════════════════════
class DashNotifBadge extends StatelessWidget {
  const DashNotifBadge({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon:      const Icon(Icons.notifications_outlined),
          tooltip:   'Notifications',
          onPressed: () {},
        ),
        if (count > 0)
          Positioned(
            top: 8, right: 8,
            child: Container(
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              padding:     const EdgeInsets.all(2),
              decoration:  const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Text(
                count > 99 ? '99+' : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color:      Colors.white,
                  fontSize:   9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SHEET PARAMÈTRES — toggle light/dark/system
// ═══════════════════════════════════════════════════════════
class DashSettingsSheet extends StatelessWidget {
  const DashSettingsSheet({super.key, required this.themeCubit});
  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      bloc:    themeCubit,
      builder: (_, mode) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize:        MainAxisSize.min,
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color:        Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Paramètres',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mode d\'affichage',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            // 3 boutons de thème côte à côte
            Row(children: [
              ThemeModeButton(
                icon:     Icons.light_mode_outlined,
                label:    'Clair',
                selected: mode == ThemeMode.light,
                onTap:    () => themeCubit.setLight(),
              ),
              const SizedBox(width: 8),
              ThemeModeButton(
                icon:     Icons.dark_mode_outlined,
                label:    'Sombre',
                selected: mode == ThemeMode.dark,
                onTap:    () => themeCubit.setDark(),
              ),
              const SizedBox(width: 8),
              ThemeModeButton(
                icon:     Icons.brightness_auto,
                label:    'Auto',
                selected: mode == ThemeMode.system,
                onTap:    () => themeCubit.setSystem(),
              ),
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// BOUTON DE THÈME (clair / sombre / auto)
// ═══════════════════════════════════════════════════════════
class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData     icon;
  final String       label;
  final bool         selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? scheme.primaryContainer : scheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 20,
              color: selected ? scheme.primary : scheme.onSurfaceVariant),
            const SizedBox(height: 4),
            Text(label,
              style: TextStyle(
                fontSize:   11,
                color:      selected ? scheme.primary : scheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SHEET PROFIL UTILISATEUR
// ═══════════════════════════════════════════════════════════
class DashProfileSheet extends StatelessWidget {
  const DashProfileSheet({
    super.key,
    required this.session,
    required this.onLogout,
  });
  final UserSession  session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 16),
        // Avatar
        CircleAvatar(
          radius:          28,
          backgroundColor: scheme.primaryContainer,
          child: Text(session.initials,
            style: TextStyle(
              color:      scheme.primary,
              fontSize:   20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(session.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Text(session.email,
          style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        const Divider(),
        // Profil
        ListTile(
          leading:  const Icon(Icons.person_outline),
          title:    const Text('Mon profil'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap:    () {},
        ),
        // Déconnexion
        ListTile(
          leading:  Icon(Icons.logout, color: scheme.error),
          title:    Text('Déconnexion',
            style: TextStyle(color: scheme.error)),
          onTap: () {
            Navigator.pop(context);
            onLogout();
          },
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SIDEBAR GÉNÉRIQUE RÉUTILISABLE
// ═══════════════════════════════════════════════════════════
/// Sidebar partagée par tous les dashboards.
/// Passer [navItems] = liste de [SidebarItem].
class DashSidebar extends StatelessWidget {
  const DashSidebar({
    super.key,
    required this.navItems,
    required this.currentIndex,
    required this.onTap,
    this.width = 220,
  });

  final List<SidebarItem> navItems;
  final int               currentIndex;
  final ValueChanged<int> onTap;
  final double            width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      color: scheme.surface,
      child: Column(children: [
        // Items de navigation
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: List.generate(navItems.length, (i) {
              final item     = navItems[i];
              final selected = i == currentIndex;
              return ListTile(
                leading: Icon(
                  selected ? item.activeIcon : item.icon,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                  size:  20,
                ),
                title: Text(item.label,
                  style: TextStyle(
                    color:      selected ? scheme.primary : scheme.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    fontSize:   14,
                  ),
                ),
                selected:          selected,
                selectedTileColor: scheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
                onTap: () => onTap(i),
              );
            }),
          ),
        ),
        const Divider(height: 1),
        // Bouton déconnexion en bas
        ListTile(
          leading:  Icon(Icons.logout, color: scheme.error, size: 20),
          title:    Text('Déconnexion',
            style: TextStyle(color: scheme.error, fontSize: 14)),
          onTap: () =>
              context.read<AuthBloc>().add(const AuthLogoutRequested()),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

/// Modèle d'item pour DashSidebar
class SidebarItem {
  const SidebarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
  final String   label;
  final IconData icon;
  final IconData activeIcon;
}

// ═══════════════════════════════════════════════════════════
// APP BAR PARTAGÉE — avec notifs, paramètres, avatar
// ═══════════════════════════════════════════════════════════
/// AppBar réutilisable pour tous les dashboards connectés.
class DashAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashAppBar({
    super.key,
    required this.title,
    this.notifCount      = 0,
    this.showAlertButton = false,
    this.actions         = const [],
  });

  final String       title;
  final int          notifCount;
  final bool         showAlertButton;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;
    final scheme  = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      actions: [
        // Actions spécifiques à la page
        ...actions,

        // Bouton alerte urgence (optionnel)
        if (showAlertButton)
          IconButton(
            icon:     const Icon(Icons.warning_amber_outlined),
            color:    Colors.red,
            tooltip:  'Signaler une urgence',
            onPressed: () => _showAlert(context),
          ),

        // Badge notifications
        DashNotifBadge(count: notifCount),

        // Bouton paramètres (dark/light mode)
        IconButton(
          icon:     const Icon(Icons.settings_outlined),
          tooltip:  'Paramètres',
          onPressed: () => _showSettings(context),
        ),

        // Avatar utilisateur → menu profil
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => _showProfile(context, session),
            child: CircleAvatar(
              radius:          18,
              backgroundColor: scheme.primaryContainer,
              child: Text(session.initials,
                style: TextStyle(
                  color:      scheme.primary,
                  fontSize:   13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAlert(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Signaler une urgence'),
        content: const Text('Envoyer une alerte à toute l\'équipe SPAD ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:     const Text('Annuler'),
          ),
          FilledButton(
            style:     FilledButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                content:         Text('Alerte envoyée !'),
                backgroundColor: Colors.red,
                behavior:        SnackBarBehavior.floating,
              ));
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DashSettingsSheet(
        themeCubit: ctx.read<ThemeCubit>()),
    );
  }

  void _showProfile(BuildContext ctx, UserSession session) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DashProfileSheet(
        session:  session,
        onLogout: () =>
            ctx.read<AuthBloc>().add(const AuthLogoutRequested()),
      ),
    );
  }
}