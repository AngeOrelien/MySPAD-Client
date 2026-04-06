// lib/features/dashboard/admin/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/user_session.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/models/spad_nav_item.dart';
import '../../../shared/widgets/spad_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({
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
    final hPad    = ResponsiveUtils.horizontalPadding(context);
    final scheme  = Theme.of(context).colorScheme;
    final cols    = ResponsiveUtils.gridColumns(context);

    return SpadScaffold(
      navItems:     SpadNavItems.admin,
      currentIndex: currentIndex,
      onNavTap:     onNavTap,
      userName:     session.name,
      userRole:     'Administrateur',
      appBar: AppBar(
        title: const Text('Tableau de bord Admin'),
        actions: [
          Stack(alignment: Alignment.center, children: [
            IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
            Positioned(top: 8, right: 8,
              child: Container(
                width: 16, height: 16,
                decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                child: Center(child: Text('5',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 9))),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(radius: 18, backgroundColor: scheme.primaryContainer,
                child: Text(session.initials,
                  style: AppTextStyles.labelMedium.copyWith(color: scheme.primary))),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistiques globales
            Text('Vue d\'ensemble',
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount:   cols,
              shrinkWrap:       true,
              physics:          const NeverScrollableScrollPhysics(),
              mainAxisSpacing:  12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: const [
                _AdminStatCard('Utilisateurs',  '247', Icons.people,      AppColors.teal9),
                _AdminStatCard('AVS actifs',    '83',  Icons.badge,       AppColors.green7),
                _AdminStatCard('Patients',       '156', Icons.elderly,     AppColors.amber9),
                _AdminStatCard('Rapports/mois', '4.2k',Icons.description, AppColors.teal11),
              ],
            ),
            const SizedBox(height: 24),

            // Actions admin
            Text('Actions',
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: [
                _AdminActionChip('Nouvel utilisateur', Icons.person_add,   AppColors.teal9,  () {}),
                _AdminActionChip('Publier actualité',  Icons.article,      AppColors.green7, () {}),
                _AdminActionChip('Gérer tokens',       Icons.key,          AppColors.amber9, () {}),
                _AdminActionChip('Voir statistiques',  Icons.bar_chart,    AppColors.teal11, () => onNavTap(2)),
              ],
            ),
            const SizedBox(height: 24),

            // Dernières activités
            Text('Activité récente',
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 12),
            _ActivityList(scheme: scheme),
            const SizedBox(height: 20),

            // Déconnexion
            OutlinedButton.icon(
              onPressed:  onLogout,
              icon:       Icon(Icons.logout, color: scheme.error),
              label:      Text('Déconnexion', style: TextStyle(color: scheme.error)),
              style:      OutlinedButton.styleFrom(
                side: BorderSide(color: scheme.error.withOpacity(0.4))),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  const _AdminStatCard(this.label, this.value, this.icon, this.color);
  final String label, value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value,
              style: AppTextStyles.statValue.copyWith(color: color, fontSize: 22)),
            Text(label,
              style: AppTextStyles.statLabel.copyWith(
                color: scheme.onSurfaceVariant)),
          ]),
        ]),
      ),
    );
  }
}

Widget _AdminActionChip(String label, IconData icon, Color color, VoidCallback onTap) {
  return Builder(builder: (ctx) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.labelMedium.copyWith(color: color)),
        ]),
      ),
    );
  });
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final activities = [
      (Icons.person_add,  'Nouveau compte AVS',          'il y a 10 min',  AppColors.teal9),
      (Icons.article,     'Actualité publiée',            'il y a 1h',      AppColors.green7),
      (Icons.warning,     'Alerte signalée — Bastos',     'il y a 2h',      AppColors.error),
      (Icons.description, '48 rapports soumis aujourd\'hui', 'Aujourd\'hui',  AppColors.amber9),
    ];

    return Column(
      children: activities.map((a) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.outline.withOpacity(0.2)),
        ),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: a.$4.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(a.$1, color: a.$4, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(a.$2,
            style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface))),
          Text(a.$3,
            style: AppTextStyles.timestamp.copyWith(color: scheme.onSurfaceVariant)),
        ]),
      )).toList(),
    );
  }
}