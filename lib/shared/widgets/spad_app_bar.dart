// lib/shared/widgets/spad_app_bar.dart
//
// ─── SPAD APP BAR — PHASE 5 ──────────────────────────────────
// AppBar réutilisable pour tous les dashboards connectés.
// Contient :
//   • Titre de la page
//   • Bouton alerte (urgence)
//   • Badge notifications
//   • Avatar utilisateur → menu profil + déconnexion
//   • Bouton paramètres → toggle dark/light + langue
//
// UTILISATION :
//   appBar: SpadAppBar(
//     title:          'Mon dashboard',
//     notifCount:     3,
//     onLogout:       () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
//     showAlertButton: true,
//   )
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/bloc/auth/auth_bloc.dart';
import '../../core/bloc/theme/theme_cubit.dart';
import '../../core/router/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/user_session.dart';

class SpadAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SpadAppBar({
    super.key,
    required this.title,
    this.notifCount      = 0,
    this.showAlertButton = false,
    this.actions         = const [],
  });

  final String         title;
  final int            notifCount;
  final bool           showAlertButton;
  final List<Widget>   actions; // actions supplémentaires

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;
    final scheme  = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(title,
        style: AppTextStyles.headlineSmall.copyWith(color: scheme.onSurface)),
      actions: [
        // ── Actions supplémentaires de la page ────────────
        ...actions,

        // ── Bouton alerte urgence ─────────────────────────
        if (showAlertButton)
          IconButton(
            icon:    const Icon(Icons.warning_amber_outlined),
            color:   AppColors.error,
            tooltip: 'Signaler une urgence',
            onPressed: () => _showAlertDialog(context),
          ),

        // ── Badge notifications ───────────────────────────
        _NotifBadge(count: notifCount),

        // ── Bouton paramètres ─────────────────────────────
        IconButton(
          icon:    const Icon(Icons.settings_outlined),
          tooltip: 'Paramètres',
          onPressed: () => _showSettingsSheet(context),
        ),

        // ── Avatar utilisateur ────────────────────────────
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => _showProfileSheet(context, session),
            child: CircleAvatar(
              radius:          18,
              backgroundColor: scheme.primaryContainer,
              child: Text(session.initials,
                style: AppTextStyles.labelMedium.copyWith(
                  color: scheme.primary)),
            ),
          ),
        ),
      ],
    );
  }

  // ── Dialogue urgence ────────────────────────────────────────
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Signaler une urgence'),
        content: const Text(
          'Envoyer une alerte d\'urgence à toute l\'équipe SPAD ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style:     FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:         Text('Alerte envoyée à l\'équipe SPAD'),
                backgroundColor: AppColors.error,
                behavior:        SnackBarBehavior.floating,
              ));
            },
            child: const Text('Envoyer l\'alerte'),
          ),
        ],
      ),
    );
  }

  // ── Sheet paramètres (dark/light mode ici) ──────────────────
  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context:          context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _SettingsSheet(
        // Passer les cubits/blocs du contexte parent
        themeCubit: context.read<ThemeCubit>(),
      ),
    );
  }

  // ── Sheet profil / déconnexion ──────────────────────────────
  void _showProfileSheet(BuildContext context, UserSession session) {
    showModalBottomSheet(
      context:          context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _ProfileSheet(
        session:    session,
        authBloc:   context.read<AuthBloc>(),
        onNavigate: context.go,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGET — Badge de notification
// ─────────────────────────────────────────────────────────────
class _NotifBadge extends StatelessWidget {
  const _NotifBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon:    const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
          onPressed: () {},
        ),
        if (count > 0)
          Positioned(
            top: 8, right: 8,
            child: Container(
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              padding:     const EdgeInsets.all(2),
              decoration:  BoxDecoration(
                color: AppColors.error, shape: BoxShape.circle),
              child: Text(
                count > 99 ? '99+' : '$count',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white, fontSize: 9),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SHEET — Paramètres (dark/light mode)
// ─────────────────────────────────────────────────────────────
class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet({required this.themeCubit});
  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      bloc:    themeCubit,
      builder: (ctx, themeMode) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outline.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Paramètres',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: scheme.onSurface)),
              const SizedBox(height: 20),

              // ── Mode d'affichage ────────────────────────
              Text('Mode d\'affichage',
                style: AppTextStyles.labelMedium.copyWith(
                  color: scheme.onSurfaceVariant)),
              const SizedBox(height: 10),
              Row(children: [
                _ThemeOption(
                  icon:      Icons.light_mode_outlined,
                  label:     'Clair',
                  selected:  themeMode == ThemeMode.light,
                  onTap:     () => themeCubit.setLight(),
                ),
                const SizedBox(width: 10),
                _ThemeOption(
                  icon:      Icons.dark_mode_outlined,
                  label:     'Sombre',
                  selected:  themeMode == ThemeMode.dark,
                  onTap:     () => themeCubit.setDark(),
                ),
                const SizedBox(width: 10),
                _ThemeOption(
                  icon:      Icons.brightness_auto_outlined,
                  label:     'Auto',
                  selected:  themeMode == ThemeMode.system,
                  onTap:     () => themeCubit.setSystem(),
                ),
              ]),
              const SizedBox(height: 20),

              // ── Langue (placeholder) ─────────────────────
              Text('Langue',
                style: AppTextStyles.labelMedium.copyWith(
                  color: scheme.onSurfaceVariant)),
              const SizedBox(height: 10),
              ListTile(
                leading:  const Icon(Icons.language_outlined),
                title:    const Text('Français'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap:    () {},
                shape:    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: scheme.outline.withOpacity(0.2)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String   label;
  final bool     selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color:        selected ? scheme.primaryContainer : scheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon,
              color: selected ? scheme.primary : scheme.onSurfaceVariant,
              size: 22),
            const SizedBox(height: 6),
            Text(label,
              style: AppTextStyles.labelSmall.copyWith(
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SHEET — Profil utilisateur
// ─────────────────────────────────────────────────────────────
class _ProfileSheet extends StatelessWidget {
  const _ProfileSheet({
    required this.session,
    required this.authBloc,
    required this.onNavigate,
  });
  final UserSession              session;
  final AuthBloc                 authBloc;
  final void Function(String)    onNavigate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(
          child: Container(width: 40, height: 4,
            decoration: BoxDecoration(
              color: scheme.outline.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2))),
        ),
        const SizedBox(height: 16),
        CircleAvatar(
          radius:          28,
          backgroundColor: scheme.primaryContainer,
          child: Text(session.initials,
            style: AppTextStyles.headlineMedium.copyWith(color: scheme.primary)),
        ),
        const SizedBox(height: 10),
        Text(session.name,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
        Text(session.email,
          style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        const Divider(),
        ListTile(
          leading:  const Icon(Icons.person_outline),
          title:    const Text('Mon profil'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap:    () {},
        ),
        ListTile(
          leading:  Icon(Icons.logout, color: scheme.error),
          title:    Text('Déconnexion',
            style: TextStyle(color: scheme.error)),
          onTap: () {
            Navigator.pop(context);
            authBloc.add(const AuthLogoutRequested());
          },
        ),
      ]),
    );
  }
}