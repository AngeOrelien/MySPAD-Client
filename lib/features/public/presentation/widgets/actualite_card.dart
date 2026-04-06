// lib/features/public/presentation/widgets/actualite_card.dart

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
  });

  final String titre;
  final String description;
  final String date;
  final String tag;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 280, // largeur fixe pour le scroll horizontal
      child: Card(
        // elevation 0 → la couleur de fond suffit à différencier
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de couleur en haut = accent visuel du tag
            Container(
              height:      5,
              decoration:  BoxDecoration(
                color:        accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft:  Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
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
                      style: AppTextStyles.labelSmall.copyWith(color: accentColor),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Titre
                  Text(titre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Description
                  Text(description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                        size: 12, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(date,
                        style: AppTextStyles.timestamp.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
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