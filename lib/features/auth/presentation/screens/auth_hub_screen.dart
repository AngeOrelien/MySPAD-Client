// lib/features/auth/presentation/screens/auth_hub_screen.dart
//
// ─── AUTH HUB ────────────────────────────────────────────────
// Page "Connexion" dans la nav visiteur.
// Deux onglets : Se connecter | S'inscrire
// Image de fond configurable.
//
// Pour ajouter ton image :
//   1. Place l'image dans assets/images/auth_bg.jpg
//   2. Déclare dans pubspec.yaml :
//        assets:
//          - assets/images/auth_bg.jpg
//   3. L'image s'affiche automatiquement.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/models/spad_nav_item.dart';
import '../../../../shared/widgets/spad_scaffold.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthHubScreen extends StatefulWidget {
  const AuthHubScreen({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
    required this.onLogin,
  });

  final int currentIndex;
  final ValueChanged<int> onNavTap;
  // Callback vers AppShell quand l'auth réussit
  final void Function({
    required String role,
    required String name,
    String email,
  })
  onLogin;

  @override
  State<AuthHubScreen> createState() => _AuthHubScreenState();
}

class _AuthHubScreenState extends State<AuthHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    // Sur desktop/tablette : layout 2 colonnes (image | formulaire)
    // Sur mobile : pleine page avec image en fond
    if (!isMobile) {
      return _buildDesktopLayout(context);
    }
    return _buildMobileLayout(context);
  }

  // ── LAYOUT MOBILE ──────────────────────────────────────────
  // Dans AuthHubScreen, remplacer _buildMobileLayout par :

  Widget _buildMobileLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SpadScaffold(
      navItems: SpadNavItems.visitor,
      currentIndex: widget.currentIndex,
      onNavTap: widget.onNavTap,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bannière supérieure (sans texte de formulaire)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColors.tealDark9.withOpacity(0.2),
                          AppColors.surfaceDark,
                        ]
                      : [AppColors.teal3, AppColors.surfaceLight],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Logo ou icône SPAD
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.teal9,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'SPAD',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Bienvenue', style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Connectez-vous ou créez votre compte',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            // Formulaire (avec marges)
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildAuthContent(
                context,
                isDark: false,
              ), // fond clair toujours
            ),
          ],
        ),
      ),
    );
  }

  // ── LAYOUT DESKTOP ─────────────────────────────────────────
  Widget _buildDesktopLayout(BuildContext context) {
    return SpadScaffold(
      navItems: SpadNavItems.visitor,
      currentIndex: widget.currentIndex,
      onNavTap: widget.onNavTap,
      body: Row(
        children: [
          // Colonne gauche : image + branding (50%)
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.teal12.withOpacity(0.7),
                        AppColors.teal12.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.teal9,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'S',
                            style: AppTextStyles.displaySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'SPAD Cameroun',
                        style: AppTextStyles.heroTitle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Accompagnement à domicile\npour vos proches âgés.',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Colonne droite : formulaire (50%)
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: _buildAuthContent(context, isDark: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── IMAGE DE FOND ───────────────────────────────────────────
  Widget _buildBackground() {
    return Image.asset(
      'assets/images/auth_bg.jpg', // ← remplace par ton image
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.teal12, AppColors.teal9.withOpacity(0.8)],
          ),
        ),
      ),
    );
  }

  // ── CONTENU DU FORMULAIRE ───────────────────────────────────
  Widget _buildAuthContent(BuildContext context, {required bool isDark}) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = isDark ? Colors.white : scheme.onSurface;
    final subColor = isDark ? Colors.white70 : scheme.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Titre
        Text(
          'Bienvenue',
          style: AppTextStyles.headlineLarge.copyWith(color: textColor),
        ),
        const SizedBox(height: 6),
        Text(
          'Connectez-vous ou créez votre compte',
          style: AppTextStyles.bodyMedium.copyWith(color: subColor),
        ),
        const SizedBox(height: 24),

        // Onglets Login / Register
        Container(
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : scheme.surface).withOpacity(
              isDark ? 0.15 : 1.0,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: AppColors.teal9,
              borderRadius: BorderRadius.circular(999),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: isDark ? Colors.white70 : scheme.onSurface,
            labelStyle: AppTextStyles.labelMedium,
            tabs: const [
              Tab(text: 'Se connecter'),
              Tab(text: 'S\'inscrire'),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Contenu des onglets
        // SizedBox contraint la hauteur du TabBarView
        SizedBox(
          height: 480,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Onglet 1 : Connexion
              LoginForm(onLogin: widget.onLogin, isDarkBg: isDark),
              // Onglet 2 : Inscription
              RegisterForm(isDarkBg: isDark),
            ],
          ),
        ),
      ],
    );
  }
}
