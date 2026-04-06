// lib/features/public/presentation/screens/home_screen.dart
//
// ─── HOME SCREEN — PAGE D'ACCUEIL PUBLIQUE ───────────────────
// Première page que voit l'utilisateur après le splash.
// Structure :
//   1. Header (AppBar web-style avec boutons Login/Register)
//   2. Hero Section (présentation SPAD + CTA)
//   3. Section Stats (chiffres clés)
//   4. Section Actualités (cards horizontales)
//   5. Section Services (ce que propose SPAD)
//   6. Footer info
//
// Cette page s'adapte : sur mobile elle empile tout verticalement,
// sur desktop la hero section affiche 2 colonnes côte à côte.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/models/spad_nav_item.dart';
import '../../../../shared/widgets/spad_scaffold.dart';
import '../widgets/actualite_card.dart';
import '../widgets/service_card.dart';

// Modèle local d'actualité (sera remplacé par le vrai modèle en Phase 6)
class _Actualite {
  const _Actualite({
    required this.titre,
    required this.description,
    required this.date,
    required this.tag,
    required this.color,
  });
  final String titre;
  final String description;
  final String date;
  final String tag;
  final Color color;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Index de la page active dans la BottomNav
  int _currentNavIndex = 0;

  // Données mock — remplacées par un BLoC en Phase 6
  final List<_Actualite> _actualites = const [
    _Actualite(
      titre:       'Formation AVS — Session Juillet 2025',
      description: 'SPAD Cameroun organise une nouvelle session de formation pour les auxiliaires de vie. Inscriptions ouvertes.',
      date:        '28 juin 2025',
      tag:         'Formation',
      color:       AppColors.teal9,
    ),
    _Actualite(
      titre:       'Partenariat avec l\'Hôpital Central',
      description: 'Un accord de collaboration a été signé pour renforcer le suivi médical des patients à domicile.',
      date:        '15 juin 2025',
      tag:         'Partenariat',
      color:       AppColors.green7,
    ),
    _Actualite(
      titre:       'Lancement de l\'application mobile',
      description: 'SPAD Cameroun lance son application mobile pour faciliter le suivi en temps réel des patients.',
      date:        '1 juin 2025',
      tag:         'Technologie',
      color:       AppColors.amber9,
    ),
    _Actualite(
      titre:       'Recrutement AVS — Yaoundé & Douala',
      description: 'Nous recrutons des auxiliaires de vie sociale expérimentés. Postulez avant le 31 juillet.',
      date:        '20 mai 2025',
      tag:         'Recrutement',
      color:       AppColors.teal11,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SpadScaffold(
      // SpadScaffold gère la nav — on passe juste les infos
      navItems:     SpadNavItems.visitor,
      currentIndex: _currentNavIndex,
      onNavTap:     (index) => setState(() => _currentNavIndex = index),

      // AppBar adaptative : sur mobile avec hamburger, sur web sans
      appBar: _buildAppBar(context),

      // Corps de la page
      body: _buildBody(context),
    );
  }

  // ─────────────────────────────────────────────────────────
  // APP BAR — style site web sur desktop, standard sur mobile
  // ─────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final scheme  = Theme.of(context).colorScheme;
    final isMobile = ResponsiveUtils.isMobile(context);

    return AppBar(
      // Pas d'élévation — on gère la séparation avec une bordure
      elevation: 0,

      // Logo + nom
      title: Row(
        children: [
          // Logo circulaire
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color:        scheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('S',
                style: AppTextStyles.titleLarge.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('SPAD Cameroun',
            style: AppTextStyles.titleLarge.copyWith(
              color: scheme.onSurface,
            ),
          ),
        ],
      ),

      // Actions : boutons connexion/inscription (desktop) ou icônes (mobile)
      actions: isMobile
          ? _buildMobileActions(context, scheme)
          : _buildDesktopActions(context, scheme),
    );
  }

  List<Widget> _buildMobileActions(BuildContext ctx, ColorScheme scheme) {
    return [
      IconButton(
        icon:    Icon(Icons.login, color: scheme.primary),
        tooltip: 'Se connecter',
        onPressed: () {
          // TODO Phase 3 : context.go('/login')
        },
      ),
      const SizedBox(width: 4),
    ];
  }

  List<Widget> _buildDesktopActions(BuildContext ctx, ColorScheme scheme) {
    return [
      // Lien "À propos"
      TextButton(
        onPressed: () {},
        child: Text('À propos',
          style: AppTextStyles.labelMedium.copyWith(color: scheme.onSurface)),
      ),
      TextButton(
        onPressed: () {},
        child: Text('Services',
          style: AppTextStyles.labelMedium.copyWith(color: scheme.onSurface)),
      ),
      TextButton(
        onPressed: () {},
        child: Text('Contact',
          style: AppTextStyles.labelMedium.copyWith(color: scheme.onSurface)),
      ),
      const SizedBox(width: 8),
      // Bouton connexion
      OutlinedButton(
        onPressed: () {
          // TODO Phase 3 : context.go('/login')
        },
        child: const Text('Connexion'),
      ),
      const SizedBox(width: 8),
      // Bouton inscription
      FilledButton(
        onPressed: () {
          // TODO Phase 3 : context.go('/register')
        },
        child: const Text("S'inscrire"),
      ),
      const SizedBox(width: 16),
    ];
  }

  // ─────────────────────────────────────────────────────────
  // BODY — scroll vertical avec toutes les sections
  // ─────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    // SingleChildScrollView : rend la page scrollable verticalement
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSection(context),
          _buildStatsSection(context),
          _buildActualitesSection(context),
          _buildServicesSection(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // SECTION 1 — HERO
  // Mobile  : colonne (texte puis visuel)
  // Desktop : ligne (texte gauche | visuel droite)
  // ─────────────────────────────────────────────────────────
  Widget _buildHeroSection(BuildContext context) {
    final scheme    = Theme.of(context).colorScheme;
    final isMobile  = ResponsiveUtils.isMobile(context);
    final hPad      = ResponsiveUtils.horizontalPadding(context);

    return Container(
      // Fond dégradé teal très subtil
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [
            AppColors.teal1,
            AppColors.teal2,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical:   isMobile ? 40 : 80,
        ),
        child: isMobile
            ? _buildHeroMobile(context, scheme)
            : _buildHeroDesktop(context, scheme),
      ),
    );
  }

  Widget _buildHeroMobile(BuildContext ctx, ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroText(ctx, scheme),
        const SizedBox(height: 40),
        _buildHeroVisual(ctx, scheme),
      ],
    );
  }

  Widget _buildHeroDesktop(BuildContext ctx, ColorScheme scheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Texte : prend 55% de la largeur
        Expanded(flex: 55, child: _buildHeroText(ctx, scheme)),
        const SizedBox(width: 60),
        // Visuel : prend 45% de la largeur
        Expanded(flex: 45, child: _buildHeroVisual(ctx, scheme)),
      ],
    );
  }

  Widget _buildHeroText(BuildContext ctx, ColorScheme scheme) {
    final isMobile = ResponsiveUtils.isMobile(ctx);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag "Soins à domicile"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:        AppColors.teal3,
            borderRadius: BorderRadius.circular(999),
            border:       Border.all(color: AppColors.teal7, width: 1),
          ),
          child: Text(
            'Soins à domicile · Yaoundé & Douala',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.teal12,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Titre principal
        Text(
          'Le bien-être de vos proches, notre priorité',
          style: (isMobile
              ? AppTextStyles.displaySmall
              : AppTextStyles.heroTitle
          ).copyWith(color: AppColors.teal12),
        ),
        const SizedBox(height: 16),

        // Sous-titre
        Text(
          'SPAD Cameroun accompagne les personnes âgées et les familles '
          'avec des auxiliaires de vie formés, des suivis médicaux '
          'rigoureux et une application de suivi en temps réel.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.teal11,
          ),
        ),
        const SizedBox(height: 32),

        // Boutons CTA
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () {}, // TODO : navigation
              icon:  const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Découvrir nos services'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {}, // TODO : navigation
              icon:  const Icon(Icons.phone, size: 18),
              label: const Text('Nous contacter'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroVisual(BuildContext ctx, ColorScheme scheme) {
    // Illustration schématique — remplacée par une vraie image en prod
    // Image.asset('assets/images/hero_spad.png')
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color:        AppColors.teal3,
          borderRadius: BorderRadius.circular(20),
          border:       Border.all(color: AppColors.teal6, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.elderly, size: 72, color: AppColors.teal9),
            const SizedBox(height: 12),
            Text(
              'Accompagnement\nà domicile',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.teal12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Personnel médical qualifié',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.teal11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // SECTION 2 — STATS (chiffres clés SPAD)
  // ─────────────────────────────────────────────────────────
  Widget _buildStatsSection(BuildContext context) {
    final hPad = ResponsiveUtils.horizontalPadding(context);
    final stats = [
      ('150+', 'Patients suivis',       Icons.elderly),
      ('80+',  'AVS qualifiés',         Icons.badge),
      ('5 ans', 'D\'expérience',        Icons.history),
      ('2',    'Villes couvertes',      Icons.location_city),
    ];

    return Container(
      color:   Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 48),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          // Grille adaptative : 2 colonnes mobile, 4 colonnes desktop
          final cols = constraints.maxWidth < 600 ? 2 : 4;
          return GridView.count(
            crossAxisCount: cols,
            shrinkWrap:     true, // important dans SingleChildScrollView
            physics: const NeverScrollableScrollPhysics(), // désactive le scroll interne
            mainAxisSpacing:  24,
            crossAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: stats.map((s) => _StatCard(
              value: s.$1, label: s.$2, icon: s.$3,
            )).toList(),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // SECTION 3 — ACTUALITÉS
  // ─────────────────────────────────────────────────────────
  Widget _buildActualitesSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hPad   = ResponsiveUtils.horizontalPadding(context);

    return Container(
      color:   AppColors.gray2,
      padding: EdgeInsets.symmetric(vertical: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Actualités SPAD',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Les dernières nouvelles de l\'association',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  label: const Text('Voir tout'),
                  icon:  const Icon(Icons.arrow_forward, size: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Scroll horizontal de cards actualités
          SizedBox(
            height: 220,
            child: ListView.builder(
              // Scroll horizontal
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: hPad),
              itemCount: _actualites.length,
              itemBuilder: (ctx, i) {
                final actu = _actualites[i];
                return Padding(
                  padding: EdgeInsets.only(
                    right: i < _actualites.length - 1 ? 16 : 0,
                  ),
                  child: ActualiteCard(
                    titre:       actu.titre,
                    description: actu.description,
                    date:        actu.date,
                    tag:         actu.tag,
                    accentColor: actu.color,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // SECTION 4 — SERVICES
  // ─────────────────────────────────────────────────────────
  Widget _buildServicesSection(BuildContext context) {
    final hPad   = ResponsiveUtils.horizontalPadding(context);
    final scheme = Theme.of(context).colorScheme;
    final services = [
      (Icons.favorite,        'Suivi santé',        'Surveillance quotidienne de l\'état de santé : médicaments, tensions, glycémie.',          AppColors.teal9),
      (Icons.restaurant_menu, 'Nutrition',           'Préparation de repas adaptés aux prescriptions médicales et aux préférences.',            AppColors.green7),
      (Icons.directions_walk, 'Activité physique',  'Accompagnement pour les sorties, exercices doux et maintien de la mobilité.',              AppColors.amber9),
      (Icons.clean_hands,     'Hygiène',            'Aide à la toilette, à l\'habillage et aux soins d\'hygiène personnelle.',                   AppColors.teal9),
      (Icons.medication,      'Médicaments',        'Administration des médicaments selon ordonnance et suivi du pilulier intelligent.',          AppColors.green7),
      (Icons.report,          'Rapports',           'Compte-rendu quotidien transmis à la famille et au médecin référent.',                     AppColors.amber9),
    ];

    return Container(
      color:   scheme.surface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nos services',
            style: AppTextStyles.headlineLarge.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text('Un accompagnement complet pour votre proche',
            style: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          LayoutBuilder(
            builder: (ctx, constraints) {
              final cols = constraints.maxWidth < 600 ? 1 :
                           constraints.maxWidth < 900 ? 2 : 3;
              return GridView.count(
                crossAxisCount:  cols,
                shrinkWrap:      true,
                physics:         const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: cols == 1 ? 3.5 : 2.2,
                children: services.map((s) => ServiceCard(
                  icon:        s.$1,
                  titre:       s.$2,
                  description: s.$3,
                  color:       s.$4,
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // FOOTER
  // ─────────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color:   AppColors.teal12,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context),
        vertical:   40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color:        AppColors.teal9,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('S',
                  style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
              ),
              const SizedBox(width: 12),
              Text('SPAD Cameroun',
                style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Société de Prestation d\'Aide à Domicile\nYaoundé & Douala, Cameroun',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.tealDark12),
          ),
          const SizedBox(height: 24),
          Text('© 2025 SPAD Cameroun — Tous droits réservés',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.tealDark11),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGET INTERNE — carte de statistique
// ─────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.icon});
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding:    const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.teal2,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: AppColors.teal6, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: scheme.primary),
          const SizedBox(height: 8),
          Text(value,
            style: AppTextStyles.statValue.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 4),
          Text(label,
            textAlign: TextAlign.center,
            style: AppTextStyles.statLabel.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}