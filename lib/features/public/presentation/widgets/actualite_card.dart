// lib/features/public/presentation/widgets/actualite_card.dart
//
// Ajoute un champ imagePath : image affichée en haut de la card.
// Si l'image n'est pas trouvée → placeholder coloré avec le tag.

import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class ActualiteCard extends StatelessWidget {
  const ActualiteCard({
    super.key,
    required this.titre,
    required this.description,
    required this.date,
    required this.tag,
    required this.accentColor,
    required this.imagePath, // 'assets/images/actu_formation.jpg'
  });

  final String titre, description, date, tag, imagePath;
  final Color  accentColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 280,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image en haut de la card ─────────────────────
            // Hauteur fixe de 120px pour toutes les cards
            SizedBox(
              height: 120,
              width:  double.infinity,
              child:  Image.asset(
                imagePath,
                fit: BoxFit.cover,
                // errorBuilder : affiche un placeholder coloré si
                // l'image n'est pas encore dans assets/
                errorBuilder: (ctx, err, stack) {
                  return Container(
                    color: accentColor.withOpacity(0.15),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image_outlined,
                            size: 32, color: accentColor.withOpacity(0.5)),
                          const SizedBox(height: 4),
                          Text(tag,
                            style: TextStyle(
                              fontSize: 12,
                              color: accentColor,
                              fontWeight: FontWeight.w500,
                            )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Contenu texte ────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:        accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(tag,
                      style: AppTextStyles.labelSmall.copyWith(color: accentColor)),
                  ),
                  const SizedBox(height: 8),

                  // Titre
                  Text(titre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface)),
                  const SizedBox(height: 6),

                  // Description
                  Text(description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                        size: 12, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(date,
                        style: AppTextStyles.timestamp.copyWith(
                          color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}