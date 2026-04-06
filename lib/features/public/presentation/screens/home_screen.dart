// lib/features/public/presentation/screens/home_screen.dart
//
// ─── HOME SCREEN — AMÉLIORATIONS ────────────────────────────
// CHANGEMENTS :
//  1. currentIndex + onNavTap reçus du parent (AppShell)
//     → corrige la navigation
//  2. Hero section : PageView auto-scroll avec images
//     → mettre tes images dans assets/images/hero_1.jpg etc.
//  3. _StatCard : FittedBox → plus d'overflow
//  4. ActualiteCard avec image placeholder en haut
// ─────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/models/spad_nav_item.dart';
import '../../../../shared/widgets/spad_scaffold.dart';
import '../widgets/actualite_card.dart';
import '../widgets/service_card.dart';

// ─────────────────────────────────────────────────────────────
// MODÈLES DE DONNÉES LOCAUX
// ─────────────────────────────────────────────────────────────

class _HeroSlide {
  const _HeroSlide({
    required this.title,
    required this.subtitle,
    required this.imagePath,  // ex: 'assets/images/hero_1.jpg'
    required this.ctaLabel,
  });
  final String title;
  final String subtitle;
  final String imagePath;
  final String ctaLabel;
}

class _Actualite {
  const _Actualite({
    required this.titre,
    required this.description,
    required this.date,
    required this.tag,
    required this.color,
    required this.imagePath, // ex: 'assets/images/actu_1.jpg'
  });
  final String titre, description, date, tag, imagePath;
  final Color color;
}

// ─────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.currentIndex, // reçu de AppShell
    required this.onNavTap,     // callback vers AppShell
  });

  final int               currentIndex;
  final ValueChanged<int> onNavTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ── Hero PageView auto-scroll ──────────────────────────────
  late PageController _heroCtrl;
  Timer?              _heroTimer;
  int                 _heroIndex = 0;

  static const _heroSlides = [
    _HeroSlide(
      title:     'Le bien-être de vos\nproches, notre priorité',
      subtitle:  'Auxiliaires de vie qualifiés, suivi médical rigoureux et application mobile.',
      imagePath: 'assets/images/hero_1.jpg',
      ctaLabel:  'Découvrir nos services',
    ),
    _HeroSlide(
      title:     'Un accompagnement\npersonnalisé à domicile',
      subtitle:  'Hygiène, nutrition, activités et suivi médicamenteux adaptés à chaque patient.',
      imagePath: 'assets/images/hero_2.jpg',
      ctaLabel:  'Voir nos offres',
    ),
    _HeroSlide(
      title:     'Disponibles à\nYaoundé & Douala',
      subtitle:  'Plus de 150 patients suivis. Notre équipe est à votre service 7j/7.',
      imagePath: 'assets/images/hero_3.jpg',
      ctaLabel:  'Nous contacter',
    ),
  ];

  static const _actualites = [
    _Actualite(
      titre:       'Formation AVS — Session Juillet 2025',
      description: 'SPAD Cameroun organise une nouvelle session de formation pour les auxiliaires de vie.',
      date:        '28 juin 2025',
      tag:         'Formation',
      color:       AppColors.teal9,
      imagePath:   'assets/images/actu_formation.jpg',
    ),
    _Actualite(
      titre:       'Partenariat avec l\'Hôpital Central',
      description: 'Accord de collaboration pour renforcer le suivi médical des patients à domicile.',
      date:        '15 juin 2025',
      tag:         'Partenariat',
      color:       AppColors.green7,
      imagePath:   'assets/images/actu_partenariat.jpg',
    ),
    _Actualite(
      titre:       'Lancement de l\'application mobile',
      description: 'SPAD Cameroun lance son application mobile pour le suivi en temps réel.',
      date:        '1 juin 2025',
      tag:         'Technologie',
      color:       AppColors.amber9,
      imagePath:   'assets/images/actu_app.jpg',
    ),
    _Actualite(
      titre:       'Recrutement AVS — Yaoundé & Douala',
      description: 'Nous recrutons des auxiliaires de vie sociale expérimentés.',
      date:        '20 mai 2025',
      tag:         'Recrutement',
      color:       AppColors.teal11,
      imagePath:   'assets/images/actu_recrutement.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _heroCtrl = PageController();
    // Auto-avance toutes les 4 secondes
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_heroCtrl.hasClients) return;
      final next = (_heroIndex + 1) % _heroSlides.length;
      _heroCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 700),
        curve:    Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpadScaffold(
      // ← currentIndex et onNavTap viennent du parent AppShell
      navItems:     SpadNavItems.visitor,
      currentIndex: widget.currentIndex,
      onNavTap:     widget.onNavTap,
      appBar:       _buildAppBar(context),
      body:         _buildBody(context),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final scheme   = Theme.of(context).colorScheme;
    final isMobile = ResponsiveUtils.isMobile(context);

    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Logo SPAD ────────────────────────────────────
          // Pour utiliser ton vrai logo :
          //   Image.asset('assets/images/logo_spad.png', width: 32, height: 32)
          // Placeholder actuel :
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color:        scheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('S',
                style: AppTextStyles.titleLarge.copyWith(
                  color: scheme.onPrimary, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Text('SPAD Cameroun',
            style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface)),
        ],
      ),
      actions: isMobile
          ? [
              IconButton(
                icon:     Icon(Icons.login_outlined, color: scheme.primary),
                tooltip:  'Connexion',
                // Tape l'item 2 = Connexion
                onPressed: () => widget.onNavTap(2),
              ),
            ]
          : [
              TextButton(onPressed: () {}, child: const Text('À propos')),
              TextButton(onPressed: () {}, child: const Text('Services')),
              TextButton(onPressed: () {}, child: const Text('Contact')),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => widget.onNavTap(2),
                child:     const Text('Connexion'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => widget.onNavTap(2),
                child:     const Text("S'inscrire"),
              ),
              const SizedBox(width: 16),
            ],
    );
  }

  // ── Body ───────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
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
  // SECTION HERO — PageView avec auto-scroll
  // ─────────────────────────────────────────────────────────
  Widget _buildHeroSection(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    // Hauteur adaptative
    final heroHeight = isMobile ? 380.0 : 520.0;

    return SizedBox(
      height: heroHeight,
      child: Stack(
        children: [
          // ── PageView images ────────────────────────────────
          PageView.builder(
            controller:  _heroCtrl,
            itemCount:   _heroSlides.length,
            onPageChanged: (i) => setState(() => _heroIndex = i),
            itemBuilder: (ctx, i) {
              final slide = _heroSlides[i];
              return _HeroSlideWidget(
                slide:     slide,
                isMobile:  isMobile,
                onCta:     () => widget.onNavTap(1), // → Offres
              );
            },
          ),

          // ── Indicateurs de page (dots) ─────────────────────
          Positioned(
            bottom: 20,
            left:   0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_heroSlides.length, (i) {
                final active = i == _heroIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin:   const EdgeInsets.symmetric(horizontal: 4),
                  width:    active ? 24.0 : 8.0,
                  height:   8,
                  decoration: BoxDecoration(
                    color:        active
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          // ── Flèches navigation (desktop uniquement) ────────
          if (!isMobile) ...[
            Positioned(
              left: 16, top: 0, bottom: 0,
              child: Center(
                child: _NavArrow(
                  icon: Icons.chevron_left,
                  onTap: () {
                    final prev = (_heroIndex - 1 + _heroSlides.length) % _heroSlides.length;
                    _heroCtrl.animateToPage(prev,
                      duration: const Duration(milliseconds: 500),
                      curve:    Curves.easeInOut);
                  },
                ),
              ),
            ),
            Positioned(
              right: 16, top: 0, bottom: 0,
              child: Center(
                child: _NavArrow(
                  icon: Icons.chevron_right,
                  onTap: () {
                    final next = (_heroIndex + 1) % _heroSlides.length;
                    _heroCtrl.animateToPage(next,
                      duration: const Duration(milliseconds: 500),
                      curve:    Curves.easeInOut);
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // SECTION STATS — FIX OVERFLOW avec FittedBox
  // ─────────────────────────────────────────────────────────
  Widget _buildStatsSection(BuildContext context) {
    final hPad = ResponsiveUtils.horizontalPadding(context);
    final stats = [
      ('150+', 'Patients suivis', Icons.elderly),
      ('80+',  'AVS qualifiés',   Icons.badge),
      ('5 ans','D\'expérience',   Icons.history),
      ('2',    'Villes',          Icons.location_city),
    ];

    return Container(
      color:   Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 40),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final cols = constraints.maxWidth < 600 ? 2 : 4;
          return GridView.count(
            crossAxisCount:   cols,
            shrinkWrap:       true,
            physics:          const NeverScrollableScrollPhysics(),
            mainAxisSpacing:  16,
            crossAxisSpacing: 16,
            // FIX : childAspectRatio agrandi pour éviter l'overflow
            childAspectRatio: constraints.maxWidth < 400 ? 1.3 : 1.6,
            children: stats.map((s) =>
              _StatCard(value: s.$1, label: s.$2, icon: s.$3)
            ).toList(),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // SECTION ACTUALITÉS
  // ─────────────────────────────────────────────────────────
  Widget _buildActualitesSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hPad   = ResponsiveUtils.horizontalPadding(context);

    return Container(
      color:   AppColors.gray2,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        color: scheme.onSurface)),
                    const SizedBox(height: 4),
                    Text('Les dernières nouvelles de l\'association',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurfaceVariant)),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  label:     const Text('Voir tout'),
                  icon:      const Icon(Icons.arrow_forward, size: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Scroll horizontal des cards
          SizedBox(
            height: 300, // hauteur augmentée pour l'image
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:         EdgeInsets.symmetric(horizontal: hPad),
              itemCount:       _actualites.length,
              itemBuilder:     (ctx, i) {
                final a = _actualites[i];
                return Padding(
                  padding: EdgeInsets.only(
                    right: i < _actualites.length - 1 ? 16 : 0),
                  child: ActualiteCard(
                    titre:       a.titre,
                    description: a.description,
                    date:        a.date,
                    tag:         a.tag,
                    accentColor: a.color,
                    imagePath:   a.imagePath,
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
  // SECTION SERVICES
  // ─────────────────────────────────────────────────────────
  Widget _buildServicesSection(BuildContext context) {
    final hPad   = ResponsiveUtils.horizontalPadding(context);
    final scheme = Theme.of(context).colorScheme;
    final services = [
      (Icons.favorite,        'Suivi santé',       'Surveillance quotidienne : médicaments, tensions, glycémie.',       AppColors.teal9),
      (Icons.restaurant_menu, 'Nutrition',          'Préparation de repas adaptés aux prescriptions médicales.',        AppColors.green7),
      (Icons.directions_walk, 'Activité physique', 'Accompagnement pour les sorties et maintien de la mobilité.',       AppColors.amber9),
      (Icons.clean_hands,     'Hygiène',            'Aide à la toilette, à l\'habillage et aux soins d\'hygiène.',      AppColors.teal9),
      (Icons.medication,      'Médicaments',        'Administration selon ordonnance et suivi du pilulier intelligent.', AppColors.green7),
      (Icons.report,          'Rapports',           'Compte-rendu quotidien transmis à la famille et au médecin.',      AppColors.amber9),
    ];

    return Container(
      color:   scheme.surface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nos services',
            style: AppTextStyles.headlineLarge.copyWith(color: scheme.onSurface)),
          const SizedBox(height: 8),
          Text('Un accompagnement complet pour votre proche',
            style: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (ctx, constraints) {
              final cols = constraints.maxWidth < 600 ? 1
                         : constraints.maxWidth < 900 ? 2 : 3;
              return GridView.count(
                crossAxisCount:   cols,
                shrinkWrap:       true,
                physics:          const NeverScrollableScrollPhysics(),
                mainAxisSpacing:  14,
                crossAxisSpacing: 14,
                childAspectRatio: cols == 1 ? 4.0 : 2.4,
                children: services.map((s) => ServiceCard(
                  icon: s.$1, titre: s.$2, description: s.$3, color: s.$4,
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
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700))),
              ),
              const SizedBox(width: 12),
              Text('SPAD Cameroun',
                style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Société de Prestation d\'Aide à Domicile\nYaoundé & Douala, Cameroun',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.tealDark12),
          ),
          const SizedBox(height: 24),
          Text('© 2025 SPAD Cameroun — Tous droits réservés',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.tealDark11)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGET — Slide individuel de la section Hero
// ─────────────────────────────────────────────────────────────
class _HeroSlideWidget extends StatelessWidget {
  const _HeroSlideWidget({
    required this.slide,
    required this.isMobile,
    required this.onCta,
  });

  final _HeroSlide slide;
  final bool       isMobile;
  final VoidCallback onCta;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Image de fond ─────────────────────────────────
        // Image.asset avec errorBuilder : si l'image n'existe pas encore
        // → affiche un fond coloré en attendant
        Image.asset(
          slide.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) {
            // Placeholder coloré jusqu'à ce que tu ajoutes les images
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                  colors: [AppColors.teal12, AppColors.teal9],
                ),
              ),
              child: Center(
                child: Icon(Icons.image_outlined, size: 64,
                  color: Colors.white.withOpacity(0.3)),
              ),
            );
          },
        ),

        // ── Overlay sombre pour lisibilité du texte ────────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin:  Alignment.centerRight,
              end:    Alignment.centerLeft,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // ── Contenu textuel ────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 80,
            vertical:   isMobile ? 40 : 60,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pill tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color:        AppColors.teal9.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('SPAD Cameroun · Soins à domicile',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
              ),
              const SizedBox(height: 16),

              // Titre
              Text(
                slide.title,
                style: (isMobile
                    ? AppTextStyles.headlineLarge
                    : AppTextStyles.heroTitle
                ).copyWith(color: Colors.white),
              ),
              const SizedBox(height: 12),

              // Sous-titre
              SizedBox(
                width: isMobile ? double.infinity : 480,
                child: Text(
                  slide.subtitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.85)),
                ),
              ),
              const SizedBox(height: 24),

              // CTA
              FilledButton.icon(
                onPressed: onCta,
                icon:  const Icon(Icons.arrow_forward, size: 18),
                label: Text(slide.ctaLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accentLight,
                  foregroundColor: AppColors.onAccentLight,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 28,
                    vertical:   isMobile ? 12 : 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGET — Flèche de navigation hero
// ─────────────────────────────────────────────────────────────
class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.icon, required this.onTap});
  final IconData     icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  44, height: 44,
        decoration: BoxDecoration(
          color:        Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGET — Carte statistique (FIX OVERFLOW avec FittedBox)
// ─────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.icon});
  final String   value;
  final String   label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding:    const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:        AppColors.teal2,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: AppColors.teal6),
      ),
      // FittedBox : réduit proportionnellement si ça ne rentre pas
      // → résout l'erreur "RenderFlex overflowed by X pixels"
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize:      MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: scheme.primary),
            const SizedBox(height: 6),
            Text(value,
              style: AppTextStyles.statValue.copyWith(color: scheme.primary)),
            const SizedBox(height: 2),
            Text(label,
              textAlign: TextAlign.center,
              style: AppTextStyles.statLabel.copyWith(
                color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}