// lib/features/public/presentation/screens/offres_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/models/spad_nav_item.dart';
import '../../../../shared/widgets/spad_scaffold.dart';

class _Offre {
  const _Offre({
    required this.titre,
    required this.lieu,
    required this.type,
    required this.description,
    required this.exigences,
    required this.dateLimit,
  });
  final String titre;
  final String lieu;
  final String type;
  final String description;
  final List<String> exigences;
  final String dateLimit;
}

class OffresScreen extends StatefulWidget {
  const OffresScreen({super.key});
  @override
  State<OffresScreen> createState() => _OffresScreenState();
}

class _OffresScreenState extends State<OffresScreen> {
  int _currentNavIndex = 1; // index 1 = Offres dans la BottomNav visiteur

  final List<_Offre> _offres = const [
    _Offre(
      titre:       'Auxiliaire de Vie Sociale (AVS)',
      lieu:        'Yaoundé, Bastos',
      type:        'Temps plein',
      description: 'Accompagnement quotidien d\'une personne âgée dans ses activités de la vie quotidienne : hygiène, repas, sorties, suivi médical.',
      exigences:   ['Diplôme en soins infirmiers ou aide-soignant', 'Expérience min. 1 an', 'Permis de conduire souhaité', 'Sens de l\'empathie et patience'],
      dateLimit:   '31 juillet 2025',
    ),
    _Offre(
      titre:       'Aide à Domicile — Soins spécialisés',
      lieu:        'Douala, Akwa',
      type:        'Mi-temps',
      description: 'Prise en charge d\'un patient avec pathologie chronique. Suivi médicamenteux, kinésithérapie douce, rapport quotidien.',
      exigences:   ['Formation en gériatrie appréciée', 'Maîtrise du français et anglais', 'Disponible week-end'],
      dateLimit:   '15 août 2025',
    ),
    _Offre(
      titre:       'Coordinateur Santé',
      lieu:        'Yaoundé, Centre ville',
      type:        'Temps plein',
      description: 'Coordination des équipes AVS, gestion des plannings et des affectations. Interface entre les familles, les AVS et les médecins.',
      exigences:   ['Bac+3 en santé publique ou management', 'Exp. management d\'équipe 2 ans', 'Maîtrise des outils informatiques'],
      dateLimit:   '30 juillet 2025',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final hPad   = ResponsiveUtils.horizontalPadding(context);
    final scheme = Theme.of(context).colorScheme;

    return SpadScaffold(
      navItems:     SpadNavItems.visitor,
      currentIndex: _currentNavIndex,
      onNavTap:     (i) => setState(() => _currentNavIndex = i),
      appBar: AppBar(
        title: const Text('Offres d\'emploi'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              label: Text('${_offres.length} postes ouverts'),
              backgroundColor: AppColors.teal3,
              labelStyle: AppTextStyles.labelSmall.copyWith(
                color: AppColors.teal12,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Text('Rejoignez l\'équipe SPAD',
              style: AppTextStyles.headlineLarge.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 8),
            Text('Participez à notre mission d\'accompagnement des personnes âgées au Cameroun.',
              style: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 32),

            // Liste des offres
            ..._offres.map((offre) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _OffreCard(offre: offre),
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
        padding: const EdgeInsets.all(20),
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
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.titre,
                        style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14,
                            color: scheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(o.lieu,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: scheme.onSurfaceVariant)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.green1,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(o.type,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.green9)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Date limite
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Limite', style: AppTextStyles.timestamp.copyWith(
                      color: scheme.onSurfaceVariant)),
                    Text(o.dateLimit, style: AppTextStyles.labelSmall.copyWith(
                      color: scheme.onSurface)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text(o.description,
              maxLines: _expanded ? null : 2,
              overflow: _expanded ? null : TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant)),

            // Exigences (visibles si expanded)
            if (_expanded) ...[
              const SizedBox(height: 12),
              Text('Profil recherché',
                style: AppTextStyles.labelMedium.copyWith(color: scheme.onSurface)),
              const SizedBox(height: 8),
              ...o.exigences.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  Icon(Icons.check_circle_outline, size: 16, color: AppColors.green7),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant))),
                ]),
              )),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  // TODO : navigation vers formulaire candidature
                },
                icon:  const Icon(Icons.send, size: 16),
                label: const Text('Postuler maintenant'),
              ),
            ],

            const SizedBox(height: 8),
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