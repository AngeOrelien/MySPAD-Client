// lib/features/dashboard/avs/avs_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/user_session.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/models/spad_nav_item.dart';
import '../../../shared/widgets/spad_scaffold.dart';

class AvsDashboardScreen extends StatelessWidget {
  const AvsDashboardScreen({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
    required this.onLogout,
  });

  final int               currentIndex;
  final ValueChanged<int> onNavTap;
  final VoidCallback      onLogout;

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;

    return SpadScaffold(
      navItems:     SpadNavItems.avs,
      currentIndex: currentIndex,
      onNavTap:     onNavTap,
      userName:     session.name,
      userRole:     'Auxiliaire de vie',
      // ── AppBar avec notifications et profil ──────────────
      appBar:       _buildAppBar(context, session),
      body:         _buildBody(context, session),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext ctx, UserSession session) {
    final scheme = Theme.of(ctx).colorScheme;

    return AppBar(
      title: Text('Bonjour, ${session.name.split(' ').first}',
        style: AppTextStyles.headlineSmall.copyWith(color: scheme.onSurface)),
      actions: [
        // ── Alerte / urgence ────────────────────────────────
        IconButton(
          icon: const Icon(Icons.warning_amber_outlined),
          color:   AppColors.error,
          tooltip: 'Signaler une urgence',
          onPressed: () => _showAlertDialog(ctx),
        ),
        // ── Notifications ────────────────────────────────────
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon:    const Icon(Icons.notifications_outlined),
              tooltip: 'Notifications',
              onPressed: () {},
            ),
            // Badge rouge avec le nombre de notifs
            Positioned(
              top:   8, right: 8,
              child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                  color: AppColors.error, shape: BoxShape.circle),
                child: Center(
                  child: Text('3',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white, fontSize: 9)),
                ),
              ),
            ),
          ],
        ),
        // ── Avatar utilisateur ───────────────────────────────
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => _showProfileMenu(ctx),
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

  Widget _buildBody(BuildContext ctx, UserSession session) {
    final hPad   = ResponsiveUtils.horizontalPadding(ctx);
    final scheme = Theme.of(ctx).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Résumé patient du jour ───────────────────────
          _SectionTitle('Mon patient aujourd\'hui'),
          const SizedBox(height: 12),
          _PatientCard(scheme: scheme),
          const SizedBox(height: 24),

          // ── Actions rapides ───────────────────────────────
          _SectionTitle('Actions rapides'),
          const SizedBox(height: 12),
          _QuickActions(onNavTap: onNavTap),
          const SizedBox(height: 24),

          // ── Tâches du jour ────────────────────────────────
          _SectionTitle('Tâches du jour'),
          const SizedBox(height: 12),
          _TaskList(scheme: scheme),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Signaler une urgence'),
        content: const Text(
          'Êtes-vous sûr de vouloir envoyer une alerte d\'urgence à l\'équipe SPAD ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:     const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                content: Text('Alerte envoyée à l\'équipe SPAD'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: const Text('Envoyer l\'alerte'),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ProfileSheet(onLogout: onLogout),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS INTERNES
// ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: AppTextStyles.titleLarge.copyWith(
        color: Theme.of(context).colorScheme.onSurface));
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.teal6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundColor: AppColors.teal3,
              child: const Icon(Icons.elderly, size: 28, color: AppColors.teal11)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mme Paulette Biya, 78 ans',
                    style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text('Suivi actif · Bastos, Yaoundé',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon:  const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onNavTap});
  final ValueChanged<int> onNavTap;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.edit_note,    'Nouveau\nrapport',    AppColors.teal9,  2),
      (Icons.medication,   'Médicaments',         AppColors.green7, 1),
      (Icons.location_on,  'Ma position',         AppColors.amber9, 3),
      (Icons.tips_and_updates, 'Suggestion', AppColors.teal11, 1),
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onNavTap(a.$4),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color:        a.$3.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:       Border.all(color: a.$3.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(a.$1, color: a.$3, size: 24),
                    const SizedBox(height: 6),
                    Text(a.$2,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelSmall.copyWith(color: a.$3)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final tasks = [
      (true,  '08:00', 'Médicaments du matin administrés',  Icons.medication),
      (true,  '09:30', 'Toilette et habillage effectués',   Icons.clean_hands),
      (false, '12:00', 'Préparer le déjeuner',              Icons.restaurant_menu),
      (false, '14:00', 'Rédiger le rapport quotidien',      Icons.edit_note),
      (false, '18:00', 'Médicaments du soir',               Icons.medication),
    ];

    return Column(
      children: tasks.map((t) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color:        t.$1 ? AppColors.teal1 : scheme.surface,
            borderRadius: BorderRadius.circular(10),
            border:       Border.all(
              color: t.$1 ? AppColors.teal6 : scheme.outline.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(t.$1 ? Icons.check_circle : Icons.radio_button_unchecked,
                color: t.$1 ? AppColors.teal9 : scheme.outline, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(t.$3,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: t.$1 ? scheme.onSurfaceVariant : scheme.onSurface,
                    decoration: t.$1 ? TextDecoration.lineThrough : null)),
              ),
              Text(t.$2,
                style: AppTextStyles.timestamp.copyWith(
                  color: scheme.onSurfaceVariant)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ProfileSheet extends StatelessWidget {
  const _ProfileSheet({required this.onLogout});
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;
    final scheme  = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius:          30,
            backgroundColor: scheme.primaryContainer,
            child: Text(session.initials,
              style: AppTextStyles.headlineMedium.copyWith(color: scheme.primary)),
          ),
          const SizedBox(height: 12),
          Text(session.name,
            style: AppTextStyles.headlineSmall.copyWith(color: scheme.onSurface)),
          Text(session.email,
            style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          const Divider(),
          ListTile(
            leading:  const Icon(Icons.person_outline),
            title:    const Text('Mon profil'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap:    () {},
          ),
          ListTile(
            leading:  const Icon(Icons.settings_outlined),
            title:    const Text('Paramètres'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap:    () {},
          ),
          ListTile(
            leading:  Icon(Icons.logout, color: scheme.error),
            title:    Text('Déconnexion',
              style: TextStyle(color: scheme.error)),
            onTap: () {
              Navigator.pop(context);
              onLogout();
            },
          ),
        ],
      ),
    );
  }
}