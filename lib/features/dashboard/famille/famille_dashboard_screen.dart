// lib/features/dashboard/famille/famille_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/user_session.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/models/spad_nav_item.dart';
import '../../../shared/widgets/spad_scaffold.dart';

class FamilleDashboardScreen extends StatelessWidget {
  const FamilleDashboardScreen({
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

    return SpadScaffold(
      navItems:     SpadNavItems.famille,
      currentIndex: currentIndex,
      onNavTap:     onNavTap,
      userName:     session.name,
      appBar: AppBar(
        title: Text('Espace famille',
          style: AppTextStyles.headlineSmall.copyWith(color: scheme.onSurface)),
        actions: [
          // Alerte
          IconButton(
            icon:    const Icon(Icons.crisis_alert_outlined),
            color:   AppColors.error,
            tooltip: 'Envoyer une alerte',
            onPressed: () {},
          ),
          // Notifications avec badge
          Stack(alignment: Alignment.center, children: [
            IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
            Positioned(top: 8, right: 8,
              child: Container(
                width: 16, height: 16,
                decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                child: Center(child: Text('2',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 9))),
              ),
            ),
          ]),
          // Avatar
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context, isScrollControlled: false,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (_) => _ProfileSheet(session: session, onLogout: onLogout),
              ),
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
            // Statut patient
            _card(scheme, child: Row(children: [
              CircleAvatar(radius: 28, backgroundColor: AppColors.teal3,
                child: const Icon(Icons.elderly, size: 28, color: AppColors.teal11)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Mme Paulette, 78 ans',
                  style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(
                    color: AppColors.success, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('État stable · Suivi actif',
                    style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
                ]),
              ])),
            ])),
            const SizedBox(height: 16),

            // Signes vitaux
            Text('Signes vitaux du jour',
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 10),
            Row(children: [
              _VitalCard('Tension', '12/8', Icons.favorite, AppColors.teal9, scheme),
              const SizedBox(width: 10),
              _VitalCard('Glycémie', '1.05 g/L', Icons.water_drop, AppColors.green7, scheme),
              const SizedBox(width: 10),
              _VitalCard('Temp.', '37.2°C', Icons.thermostat, AppColors.amber9, scheme),
            ]),
            const SizedBox(height: 24),

            // Dernier rapport
            Text('Dernier rapport AVS',
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 10),
            _card(scheme, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Rapport du 28 juin 2025',
                  style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.teal3, borderRadius: BorderRadius.circular(999)),
                  child: Text('Validé', style: AppTextStyles.labelSmall.copyWith(color: AppColors.teal12)),
                ),
              ]),
              const SizedBox(height: 8),
              Text('Patiente en bonne forme. Repas pris correctement. Médicaments administrés selon prescription.',
                style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => onNavTap(2),
                icon:  const Icon(Icons.description_outlined, size: 16),
                label: const Text('Voir tous les rapports'),
              ),
            ])),
          ],
        ),
      ),
    );
  }

  Widget _card(ColorScheme scheme, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: scheme.outline.withOpacity(0.2)),
      ),
      child: child,
    );
  }
}

class _VitalCard extends StatelessWidget {
  const _VitalCard(this.label, this.value, this.icon, this.color, this.scheme);
  final String label, value;
  final IconData icon;
  final Color color;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.statValue.copyWith(color: color, fontSize: 16)),
            Text(label, style: AppTextStyles.statLabel.copyWith(color: scheme.onSurfaceVariant)),
          ]),
        ),
      ),
    );
  }
}

class _ProfileSheet extends StatelessWidget {
  const _ProfileSheet({required this.session, required this.onLogout});
  final UserSession  session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(radius: 28, backgroundColor: scheme.primaryContainer,
          child: Text(session.initials,
            style: AppTextStyles.headlineMedium.copyWith(color: scheme.primary))),
        const SizedBox(height: 10),
        Text(session.name, style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        const Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: scheme.error),
          title: Text('Déconnexion', style: TextStyle(color: scheme.error)),
          onTap: () { Navigator.pop(context); onLogout(); },
        ),
      ]),
    );
  }
}