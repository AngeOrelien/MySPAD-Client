// lib/shared/widgets/spad_widgets.dart
//
// ─── SHARED WIDGETS — PHASE 5 ────────────────────────────────
// Tous les widgets réutilisables dans un seul fichier.
// Pour en utiliser un :
//   import 'package:myspad/shared/widgets/spad_widgets.dart';
//   SpadCard(child: ...)
//   SpadButton(label: 'Valider', onPressed: ...)
//   SpadLoading()
//   SpadEmptyState(message: 'Aucun rapport trouvé')
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// ═══════════════════════════════════════════════════════════
// SPAD CARD — carte standardisée
// ═══════════════════════════════════════════════════════════
class SpadCard extends StatelessWidget {
  const SpadCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.onTap,
    this.borderRadius = 14,
  });

  final Widget      child;
  final EdgeInsets? padding;
  final Color?      color;
  final Color?      borderColor;
  final VoidCallback? onTap;
  final double      borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color:        color ?? scheme.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? scheme.outline.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SPAD BUTTON — bouton principal SPAD
// ═══════════════════════════════════════════════════════════

enum SpadButtonVariant { filled, outlined, text, danger }

class SpadButton extends StatelessWidget {
  const SpadButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant    = SpadButtonVariant.filled,
    this.isLoading  = false,
    this.isFullWidth = false,
  });

  final String          label;
  final VoidCallback?   onPressed;
  final IconData?       icon;
  final SpadButtonVariant variant;
  final bool            isLoading;
  final bool            isFullWidth;

  @override
  Widget build(BuildContext context) {
    final scheme  = Theme.of(context).colorScheme;
    // Contenu du bouton
    Widget content = isLoading
        ? const SizedBox(width: 18, height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : icon != null
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(label),
              ])
            : Text(label);

    Widget button;

    switch (variant) {
      case SpadButtonVariant.filled:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
          child: content,
        );
        break;
      case SpadButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
          child: content,
        );
        break;
      case SpadButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child:     content,
        );
        break;
      case SpadButtonVariant.danger:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
          child: content,
        );
        break;
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

// ═══════════════════════════════════════════════════════════
// SPAD LOADING — indicateur de chargement
// ═══════════════════════════════════════════════════════════
class SpadLoading extends StatelessWidget {
  const SpadLoading({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize:      MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: scheme.primary),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SPAD EMPTY STATE — état vide (liste vide, pas de données)
// ═══════════════════════════════════════════════════════════
class SpadEmptyState extends StatelessWidget {
  const SpadEmptyState({
    super.key,
    required this.message,
    this.icon         = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String     message;
  final IconData   icon;
  final String?    actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:      MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: scheme.outline),
            const SizedBox(height: 16),
            Text(message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: scheme.onSurfaceVariant)),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              SpadButton(
                label:   actionLabel!,
                onPressed: onAction,
                variant: SpadButtonVariant.outlined,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SPAD ERROR WIDGET — affichage d'erreur
// ═══════════════════════════════════════════════════════════
class SpadErrorWidget extends StatelessWidget {
  const SpadErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String       message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:      MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color:  AppColors.errorLight,
                shape:  BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline,
                size: 32, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            Text(message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurface)),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              SpadButton(
                label:    'Réessayer',
                icon:     Icons.refresh,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SPAD BADGE — badge de statut (Validé, En retard, etc.)
// ═══════════════════════════════════════════════════════════

enum SpadBadgeType { success, warning, error, info, neutral }

class SpadBadge extends StatelessWidget {
  const SpadBadge({
    super.key,
    required this.label,
    this.type = SpadBadgeType.neutral,
  });

  final String       label;
  final SpadBadgeType type;

  @override
  Widget build(BuildContext context) {
    final (bg, text) = switch (type) {
      SpadBadgeType.success => (AppColors.successLight, AppColors.success),
      SpadBadgeType.warning => (AppColors.warningLight, AppColors.warning),
      SpadBadgeType.error   => (AppColors.errorLight,   AppColors.error),
      SpadBadgeType.info    => (AppColors.infoLight,    AppColors.info),
      SpadBadgeType.neutral => (AppColors.gray3,        AppColors.gray11),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:        bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
        style: AppTextStyles.statusBadge.copyWith(color: text)),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SPAD SECTION HEADER — en-tête de section réutilisable
// ═══════════════════════════════════════════════════════════
class SpadSectionHeader extends StatelessWidget {
  const SpadSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String  title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: AppTextStyles.titleLarge.copyWith(
                  color: scheme.onSurface)),
              if (subtitle != null)
                Text(subtitle!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton.icon(
            onPressed: onAction,
            label:     Text(actionLabel!),
            icon:      const Icon(Icons.arrow_forward, size: 14),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SPAD AVATAR — avatar utilisateur avec initiales ou image
// ═══════════════════════════════════════════════════════════
class SpadAvatar extends StatelessWidget {
  const SpadAvatar({
    super.key,
    required this.initials,
    this.imageUrl,
    this.size    = 40,
    this.onTap,
  });

  final String   initials;
  final String?  imageUrl;
  final double   size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = size / 2;

    return GestureDetector(
      onTap: onTap,
      child: imageUrl != null
          ? CircleAvatar(
              radius:           radius,
              backgroundImage:  NetworkImage(imageUrl!),
            )
          : CircleAvatar(
              radius:          radius,
              backgroundColor: scheme.primaryContainer,
              child: Text(initials,
                style: AppTextStyles.labelMedium.copyWith(
                  color:     scheme.primary,
                  fontSize:  size * 0.35,
                )),
            ),
    );
  }
}