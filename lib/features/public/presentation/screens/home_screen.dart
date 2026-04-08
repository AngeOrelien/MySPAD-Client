// lib/features/public/screens/home_screen.dart
//
// DIFFÉRENCES importantes vs version précédente :
// 1. Plus de SpadScaffold ici — c'est _VisitorShell dans
//    app_router.dart qui fournit le BottomNav
// 2. Le body de cette page = Scaffold simple (ou juste un widget)
// 3. context.go() pour naviguer → GoRouter gère tout
// 4. Bouton "Connexion" clairement visible dans l'AppBar
// ─────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hero auto-scroll
  late final PageController _heroCtrl;
  Timer? _heroTimer;
  int    _heroIndex = 0;

  static const _slides = [
    _Slide('Le bien-être de\nvos proches', 'Auxiliaires de vie qualifiés, suivi médical rigoureux.', 'assets/images/hero_1.jpg'),
    _Slide('Accompagnement\nà domicile',   'Hygiène, nutrition, activités et suivi médicamenteux.',  'assets/images/hero_2.jpg'),
    _Slide('Disponibles à\nYaoundé & Douala', 'Plus de 150 patients suivis, 7j/7.',                  'assets/images/hero_3.jpg'),
  ];

  @override
  void initState() {
    super.initState();
    _heroCtrl = PageController();
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_heroCtrl.hasClients) return;
      final next = (_heroIndex + 1) % _slides.length;
      _heroCtrl.animateToPage(next,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
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
    // Ce widget ne gère PAS la BottomNav — c'est _VisitorShell
    // On retourne juste le contenu de la page
    return Scaffold(
      // ── AppBar avec boutons connexion/inscription ──────────
      appBar: _buildAppBar(context),
      body:   _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext ctx) {
    final scheme   = Theme.of(ctx).colorScheme;
    final isNarrow = MediaQuery.of(ctx).size.width < 600;

    return AppBar(
      elevation: 0,
      // Logo
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo_spad.png', width: 32, height: 32,
            errorBuilder: (_, __, ___) => Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: scheme.primary, borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text('S', style: TextStyle(
                color: scheme.onPrimary, fontWeight: FontWeight.w700, fontSize: 16))),
            ),
          ),
          const SizedBox(width: 10),
          const Text('SPAD Cameroun', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
      actions: [
        if (isNarrow)
          // Mobile : icône seule
          IconButton(
            icon:      const Icon(Icons.login),
            tooltip:   'Connexion',
            // context.go() : naviguer sans historique
            onPressed: () => ctx.go(RouteNames.login),
          )
        else ...[
          // Desktop : boutons texte
          TextButton(onPressed: () {}, child: const Text('À propos')),
          TextButton(onPressed: () {}, child: const Text('Services')),
          const SizedBox(width: 4),
          OutlinedButton(
            onPressed: () => ctx.go(RouteNames.login),
            child:     const Text('Connexion'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => ctx.go(RouteNames.register),
            child:     const Text('S\'inscrire (famille)'),
          ),
          const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildBody(BuildContext ctx) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHero(ctx),
          _buildStats(ctx),
          _buildActualites(ctx),
          _buildServices(ctx),
          _buildFooter(ctx),
        ],
      ),
    );
  }

  // ── HERO ─────────────────────────────────────────────────────
  Widget _buildHero(BuildContext ctx) {
    final isMobile = MediaQuery.of(ctx).size.width < 600;
    return SizedBox(
      height: isMobile ? 360 : 500,
      child: Stack(
        children: [
          PageView.builder(
            controller:    _heroCtrl,
            itemCount:     _slides.length,
            onPageChanged: (i) => setState(() => _heroIndex = i),
            itemBuilder:   (_, i) => _SlideWidget(slide: _slides[i]),
          ),
          // Dots
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                return AnimatedContainer(
                  duration:   const Duration(milliseconds: 300),
                  margin:     const EdgeInsets.symmetric(horizontal: 4),
                  width:      i == _heroIndex ? 24 : 8,
                  height:     8,
                  decoration: BoxDecoration(
                    color:        i == _heroIndex ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4)),
                );
              }),
            ),
          ),
          // ── CTA centré ───────────────────────────────────────
          Positioned(
            bottom: 56, left: 24, right: 24,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: () => ctx.go(RouteNames.login),
                  icon:  const Icon(Icons.login, size: 18),
                  label: const Text('Se connecter'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00C7CC),
                    foregroundColor: Colors.white),
                ),
                OutlinedButton.icon(
                  onPressed: () => ctx.go(RouteNames.register),
                  icon:  const Icon(Icons.family_restroom, size: 18),
                  label: const Text('Souscrire (famille)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── STATS ─────────────────────────────────────────────────────
  Widget _buildStats(BuildContext ctx) {
    final stats = [('150+','Patients'), ('80+','AVS qualifiés'), ('5 ans','Expérience'), ('2','Villes')];
    return Container(
      color:   Theme.of(ctx).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child:   LayoutBuilder(builder: (_, c) {
        final cols = c.maxWidth < 600 ? 2 : 4;
        return GridView.count(
          crossAxisCount:   cols,
          shrinkWrap:       true,
          physics:          const NeverScrollableScrollPhysics(),
          mainAxisSpacing:  12,
          crossAxisSpacing: 12,
          childAspectRatio: c.maxWidth < 400 ? 1.4 : 1.8,
          children: stats.map((s) => _StatTile(value: s.$1, label: s.$2)).toList(),
        );
      }),
    );
  }

  // ── ACTUALITÉS ────────────────────────────────────────────────
  Widget _buildActualites(BuildContext ctx) {
    final actus = [
      _Actu('Formation AVS — Juillet 2025', 'Session de formation ouverte aux nouvelles recrues.', '28 juin 2025', 'Formation', const Color(0xFF00C7CC)),
      _Actu('Partenariat Hôpital Central', 'Accord de collaboration pour le suivi médical à domicile.', '15 juin 2025', 'Partenariat', const Color(0xFF0C8C6B)),
      _Actu('Lancement de l\'app mobile', 'Suivi en temps réel désormais disponible sur mobile.', '1 juin 2025', 'Tech', const Color(0xFFF5A623)),
      _Actu('Recrutement AVS', 'Nous recrutons à Yaoundé et Douala.', '20 mai 2025', 'Recrutement', const Color(0xFF007E81)),
    ];
    return Container(
      color:   const Color(0xFFF9F9FB),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Actualités SPAD', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              TextButton.icon(onPressed: () {}, label: const Text('Voir tout'),
                icon: const Icon(Icons.arrow_forward, size: 16)),
            ]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:         const EdgeInsets.symmetric(horizontal: 24),
              itemCount:       actus.length,
              itemBuilder:     (_, i) => Padding(
                padding: EdgeInsets.only(right: i < actus.length - 1 ? 14 : 0),
                child:   _ActuCard(actu: actus[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SERVICES ─────────────────────────────────────────────────
  Widget _buildServices(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    final services = [
      (Icons.favorite,        'Suivi santé',       'Médicaments, tensions, glycémie au quotidien.'),
      (Icons.restaurant_menu, 'Nutrition',          'Repas adaptés aux prescriptions médicales.'),
      (Icons.directions_walk, 'Activité physique', 'Sorties et maintien de la mobilité.'),
      (Icons.clean_hands,     'Hygiène',           'Aide à la toilette et soins personnels.'),
      (Icons.medication,      'Médicaments',        'Pilulier intelligent + administration.'),
      (Icons.description,     'Rapports',          'Compte-rendu quotidien famille/médecin.'),
    ];
    return Container(
      color:   scheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nos services', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (_, c) {
            final cols = c.maxWidth < 600 ? 1 : c.maxWidth < 900 ? 2 : 3;
            return GridView.count(
              crossAxisCount:   cols,
              shrinkWrap:       true,
              physics:          const NeverScrollableScrollPhysics(),
              mainAxisSpacing:  12,
              crossAxisSpacing: 12,
              childAspectRatio: cols == 1 ? 5.0 : 2.8,
              children: services.map((s) => _ServiceTile(icon: s.$1, titre: s.$2, desc: s.$3)).toList(),
            );
          }),
        ],
      ),
    );
  }

  // ── FOOTER ────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext ctx) {
    return Container(
      color:   const Color(0xFF004345),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('SPAD Cameroun',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Société de Prestation d\'Aide à Domicile — Yaoundé & Douala',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
        const SizedBox(height: 20),
        Row(children: [
          FilledButton.icon(
            onPressed: () => ctx.go(RouteNames.login),
            icon:  const Icon(Icons.login, size: 16),
            label: const Text('Se connecter'),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00C7CC),
              foregroundColor: Colors.white),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () => ctx.go(RouteNames.register),
            style:     OutlinedButton.styleFrom(foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54)),
            child: const Text('Souscrire'),
          ),
        ]),
        const SizedBox(height: 20),
        Text('© 2025 SPAD Cameroun',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MODÈLES + WIDGETS INTERNES
// ─────────────────────────────────────────────────────────────

class _Slide {
  const _Slide(this.title, this.subtitle, this.imagePath);
  final String title, subtitle, imagePath;
}

class _SlideWidget extends StatelessWidget {
  const _SlideWidget({required this.slide});
  final _Slide slide;
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Image.asset(slide.imagePath, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004345), Color(0xFF00C7CC)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.65), Colors.transparent],
            begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(28, 0, 120, 80),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(slide.title,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700, height: 1.2)),
          const SizedBox(height: 10),
          Text(slide.subtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 15)),
        ]),
      ),
    ]);
  }
}

class _Actu {
  const _Actu(this.titre, this.desc, this.date, this.tag, this.color);
  final String titre, desc, date, tag; final Color color;
}

class _ActuCard extends StatelessWidget {
  const _ActuCard({required this.actu});
  final _Actu actu;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 260,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outline.withOpacity(0.15))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image placeholder
          Container(
            height: 90, decoration: BoxDecoration(
              color: actu.color.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
            child: Center(child: Icon(Icons.image_outlined, color: actu.color.withOpacity(0.4), size: 32)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: actu.color.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
                child: Text(actu.tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: actu.color)),
              ),
              const SizedBox(height: 6),
              Text(actu.titre, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(actu.date, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});
  final String value, label;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:        const Color(0xFFEEFCFC),
          borderRadius: BorderRadius.circular(12),
          border:       Border.all(color: const Color(0xFF73E6E8))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: scheme.primary)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
        ]),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.icon, required this.titre, required this.desc});
  final IconData icon; final String titre, desc;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface, borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outline.withOpacity(0.2))),
      child: Row(children: [
        Container(
          width: 40, height: 40, decoration: BoxDecoration(
            color: scheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 20, color: scheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titre, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text(desc, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
        ])),
      ]),
    );
  }
}
