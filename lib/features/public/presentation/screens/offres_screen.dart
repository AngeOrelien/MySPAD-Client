// lib/features/public/presentation/screens/offres_screen.dart
// FIX : reçoit currentIndex et onNavTap de AppShell

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/models/spad_nav_item.dart';
import '../../../../shared/widgets/spad_scaffold.dart';

class _Offre {
  const _Offre({
    required this.titre, required this.lieu, required this.type,
    required this.description, required this.exigences, required this.dateLimit,
  });
  final String titre, lieu, type, description, dateLimit;
  final List<String> exigences;
}

class OffresScreen extends StatelessWidget {
  const OffresScreen({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  final int               currentIndex;
  final ValueChanged<int> onNavTap;

  static const _offres = [
    _Offre(
      titre:       'Auxiliaire de Vie Sociale (AVS)',
      lieu:        'Yaoundé, Bastos',
      type:        'Temps plein',
      description: 'Accompagnement quotidien d\'une personne âgée : hygiène, repas, sorties, suivi médical.',
      exigences:   ['Diplôme soins infirmiers ou aide-soignant', 'Expérience min. 1 an', 'Permis de conduire souhaité'],
      dateLimit:   '31 juillet 2025',
    ),
    _Offre(
      titre:       'Aide à Domicile — Soins spécialisés',
      lieu:        'Douala, Akwa',
      type:        'Mi-temps',
      description: 'Prise en charge d\'un patient avec pathologie chronique. Suivi médicamenteux, kinésithérapie douce.',
      exigences:   ['Formation en gériatrie appréciée', 'Bilingue français/anglais', 'Disponible week-end'],
      dateLimit:   '15 août 2025',
    ),
    _Offre(
      titre:       'Coordinateur Santé',
      lieu:        'Yaoundé, Centre ville',
      type:        'Temps plein',
      description: 'Coordination des équipes AVS, gestion des plannings et affectations.',
      exigences:   ['Bac+3 santé publique ou management', 'Expérience management 2 ans', 'Maîtrise outils informatiques'],
      dateLimit:   '30 juillet 2025',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final hPad   = ResponsiveUtils.horizontalPadding(context);
    final scheme = Theme.of(context).colorScheme;

    return SpadScaffold(
      navItems:     SpadNavItems.visitor,
      currentIndex: currentIndex,   // ← du parent
      onNavTap:     onNavTap,       // ← vers le parent
      appBar: AppBar(
        title: const Text('Offres d\'emploi'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              label: Text('${_offres.length} postes'),
              backgroundColor: AppColors.teal3,
              labelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.teal12),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rejoignez l\'équipe SPAD',
              style: AppTextStyles.headlineLarge.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 8),
            Text('Participez à notre mission d\'accompagnement des personnes âgées.',
              style: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            ..._offres.map((o) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _OffreCard(offre: o),
            )),
          ],
        ),
      ),
    );
  }
}

class _OffreCard extends StatefulWidget {
  const _OffreCard({required this.offre});
  final _Offre offre;
  @override
  State<_OffreCard> createState() => _OffreCardState();
}

class _OffreCardState extends State<_OffreCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final o = widget.offre;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color:        AppColors.teal3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.work, color: AppColors.teal11, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.titre,
                        style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.location_on_outlined, size: 13, color: scheme.onSurfaceVariant),
                            const SizedBox(width: 2),
                            Text(o.lieu, style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
                          ]),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.green1, borderRadius: BorderRadius.circular(999)),
                            child: Text(o.type,
                              style: AppTextStyles.labelSmall.copyWith(color: AppColors.green9)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(o.description,
              maxLines: _expanded ? null : 2,
              overflow: _expanded ? null : TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant)),

            if (_expanded) ...[
              const SizedBox(height: 10),
              Text('Profil recherché',
                style: AppTextStyles.labelMedium.copyWith(color: scheme.onSurface)),
              const SizedBox(height: 6),
              ...o.exigences.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  Icon(Icons.check_circle_outline, size: 15, color: AppColors.green7),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e,
                    style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant))),
                ]),
              )),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () {},
                icon:  const Icon(Icons.send, size: 16),
                label: const Text('Postuler maintenant'),
              ),
            ],

            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Voir moins' : 'Voir plus'),
            ),
          ],
        ),
      ),
    );
  }
}