// lib/features/public/presentation/widgets/service_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.icon,
    required this.titre,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String   titre;
  final String   description;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding:    const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(
          color: scheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône dans un conteneur coloré
          Container(
            width:  44,
            height: 44,
            decoration: BoxDecoration(
              color:        color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titre,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}