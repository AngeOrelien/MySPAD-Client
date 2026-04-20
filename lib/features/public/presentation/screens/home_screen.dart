// lib/features/public/presentation/screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/bloc/theme/theme_cubit.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/spad_ai_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _heroCtrl = PageController();
  Timer? _timer;
  int    _heroIdx = 0;

  static const _heroSlides = [
    _HeroData('Le bien-être\nde vos proches',   'Auxiliaires de vie qualifiés, 7j/7',           'assets/images/hero_1.jpg', Color(0xFF004345)),
    _HeroData('Suivi médical\nquotidien',        'Paramètres vitaux, médicaments, rapports',     'assets/images/hero_2.jpg', Color(0xFF032820)),
    _HeroData('Yaoundé\n& Douala',              'Plus de 150 patients suivis depuis 2020',      'assets/images/hero_3.jpg', Color(0xFF1A0800)),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final next = (_heroIdx + 1) % _heroSlides.length;
      _heroCtrl.animateToPage(next,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }

  @override void dispose() { _timer?.cancel(); _heroCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final scheme   = Theme.of(context).colorScheme;
    final isDark   = context.watch<ThemeCubit>().isDark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        // Logo
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset('assets/images/logo_spad.png',
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                    color: scheme.primary, borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text('S',
                    style: TextStyle(color: scheme.onPrimary,
                        fontWeight: FontWeight.w800, fontSize: 13))),
              )),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('SPAD Cameroun',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                  color: scheme.onSurface)),
          Text('Soins à domicile',
              style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
        ]),
        actions: [
          // ── Toggle thème ──────────────────────────────
          IconButton(
            iconSize: 20,
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            tooltip: isDark ? 'Mode clair' : 'Mode sombre',
            onPressed: () => context.read<ThemeCubit>().toggle(),
          ),
          // ── Connexion : icône sur mobile, label sur desktop ──
          isMobile
              ? IconButton(
            iconSize: 20,
            icon: const Icon(Icons.login_rounded),
            tooltip: 'Connexion',
            onPressed: () => context.go(RouteNames.login),
          )
              : Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () => context.go(RouteNames.login),
              style: TextButton.styleFrom(
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: Size.zero,
              ),
              child: const Text('Connexion',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHero(context),
          _buildQuickActions(context),
          _buildStats(context),
          _buildActualites(context),
          _buildServices(context),
          _buildFooter(context),
          const SizedBox(height: 80),
        ]),
      ),
      floatingActionButton: const SpadAIFab(),
    );
  }

  // ── HERO ─────────────────────────────────────────────────────
  Widget _buildHero(BuildContext ctx) {
    final isMobile = MediaQuery.of(ctx).size.width < 600;
    return SizedBox(
      height: isMobile ? 220 : 340,
      child: Stack(children: [
        PageView.builder(
          controller:    _heroCtrl,
          itemCount:     _heroSlides.length,
          onPageChanged: (i) => setState(() => _heroIdx = i),
          itemBuilder:   (_, i) => _HeroCard(data: _heroSlides[i]),
        ),
        Positioned(bottom: 10, left: 0, right: 0,
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_heroSlides.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _heroIdx ? 16 : 5, height: 5,
                decoration: BoxDecoration(
                    color: i == _heroIdx ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(3)),
              )),
            )),
      ]),
    );
  }

  // ── ACTIONS RAPIDES ──────────────────────────────────────────
  Widget _buildQuickActions(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    final actions = [
      (Icons.login_rounded,   'Se\nconnecter', RouteNames.login),
      (Icons.family_restroom, 'Souscrire',     RouteNames.register),
      (Icons.work_outline,    'Nos offres',    RouteNames.offres),
      (Icons.phone_outlined,  'Contact',       ''),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(children: actions.map((a) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () { if (a.$3.isNotEmpty) ctx.go(a.$3); },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color:        scheme.surface,
              borderRadius: BorderRadius.circular(10),
              border:       Border.all(color: scheme.outline.withOpacity(0.2)),
            ),
            child: Column(children: [
              Container(width: 38, height: 38,
                  decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(9)),
                  child: Icon(a.$1, color: scheme.primary, size: 19)),
              const SizedBox(height: 5),
              Text(a.$2, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
                      color: scheme.onSurface, height: 1.2)),
            ]),
          ),
        ),
      ))).toList()),
    );
  }

  // ── STATS ─────────────────────────────────────────────────────
  Widget _buildStats(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    final stats = [
      ('150+', 'Patients\nsuivis',  const Color(0xFF007EB0)),
      ('80+',  'AVS\nqualifiés',   const Color(0xFF08664F)),
      ('5 ans','Expérience',       const Color(0xFFC28018)),
      ('2',    'Villes',           const Color(0xFF007E81)),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('SPAD en chiffres',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
        const SizedBox(height: 10),
        Row(children: stats.map((s) => Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
                color:        s.$3.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border:       Border.all(color: s.$3.withOpacity(0.25))),
            child: FittedBox(fit: BoxFit.scaleDown, child: Column(children: [
              Text(s.$1, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: s.$3)),
              const SizedBox(height: 2),
              Text(s.$2, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9, color: scheme.onSurfaceVariant, height: 1.2)),
            ])),
          ),
        ))).toList()),
      ]),
    );
  }

  // ── ACTUALITÉS ────────────────────────────────────────────────
  Widget _buildActualites(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    final actus = [
      _ActuData('Formation AVS — Juillet 2025',  'Session ouverte aux nouvelles recrues.',         '28 juin 2025', 'Formation',  const Color(0xFF007EB0), 'assets/images/actu_1.jpg'),
      _ActuData('Partenariat Hôpital Central',   'Accord de collaboration pour le suivi médical.', '15 juin 2025', 'Partenariat',const Color(0xFF08664F), 'assets/images/actu_2.jpg'),
      _ActuData('Application mobile SPAD',       'Suivi en temps réel sur Android et iOS.',        '1 juin 2025',  'Tech',       const Color(0xFFC28018), 'assets/images/actu_3.jpg'),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Actualités SPAD',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
            TextButton(onPressed: () {}, child: const Text('Voir tout', style: TextStyle(fontSize: 12))),
          ]),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: actus.length,
            itemBuilder: (_, i) => Padding(
              padding: EdgeInsets.only(right: i < actus.length - 1 ? 10 : 0),
              child: _ActuCard(data: actus[i]),
            ),
          ),
        ),
      ]),
    );
  }

  // ── SERVICES ─────────────────────────────────────────────────
  Widget _buildServices(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    final services = [
      (Icons.favorite_rounded,    'Suivi santé',    'Vitaux, médocs, glycémie',    const Color(0xFF007EB0)),
      (Icons.restaurant_rounded,  'Nutrition',      'Repas adaptés & hydratation', const Color(0xFF08664F)),
      (Icons.directions_walk,     'Kinésithérapie', 'Séances & mobilité',          const Color(0xFFC28018)),
      (Icons.clean_hands_rounded, 'Hygiène',        'Soins corporels quotidiens',  const Color(0xFF007E81)),
      (Icons.medication_rounded,  'Médicaments',    'Pilulier intelligent',         const Color(0xFF007EB0)),
      (Icons.description_rounded, 'Rapports',       'Compte-rendu famille/médecin',const Color(0xFF08664F)),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Nos services', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
        const SizedBox(height: 10),
        ...services.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: scheme.surface, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outline.withOpacity(0.15))),
          child: Row(children: [
            Container(width: 40, height: 40,
                decoration: BoxDecoration(
                    color: s.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(s.$1, color: s.$4, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(s.$3, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
            ])),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: scheme.onSurfaceVariant),
          ]),
        )),
      ]),
    );
  }

  // ── FOOTER ────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext ctx) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF007EB0), Color(0xFF004345)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('SPAD Cameroun',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text('NkoIndongo, Immeuble Bayiga Center',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
        Text('Tél : 680 42 25 51 / 690 97 99 32',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: OutlinedButton(
              onPressed: () => ctx.go(RouteNames.login),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(vertical: 8)),
              child: const Text('Connexion', style: TextStyle(fontSize: 12)))),
          const SizedBox(width: 10),
          Expanded(child: FilledButton(
              onPressed: () => ctx.go(RouteNames.register),
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF004345),
                  padding: const EdgeInsets.symmetric(vertical: 8)),
              child: const Text('Souscrire', style: TextStyle(fontSize: 12)))),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS INTERNES
// ─────────────────────────────────────────────────────────────
class _HeroData { const _HeroData(this.t, this.s, this.img, this.bg);
final String t, s, img; final Color bg; }

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.data});
  final _HeroData data;
  @override
  Widget build(BuildContext ctx) => Stack(fit: StackFit.expand, children: [
    Image.asset(data.img, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: data.bg)),
    Container(decoration: BoxDecoration(gradient: LinearGradient(
        colors: [data.bg.withOpacity(0.85), Colors.transparent],
        begin: Alignment.bottomCenter, end: Alignment.topCenter))),
    Positioned(bottom: 28, left: 18, right: 18, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(data.t, style: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, height: 1.2)),
      const SizedBox(height: 3),
      Text(data.s, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
    ])),
  ]);
}

class _ActuData { const _ActuData(this.t, this.d, this.date, this.tag, this.c, this.img);
final String t, d, date, tag, img; final Color c; }

class _ActuCard extends StatelessWidget {
  const _ActuCard({required this.data});
  final _ActuData data;
  @override
  Widget build(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    return SizedBox(width: 210, child: Card(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 85, child: Stack(fit: StackFit.expand, children: [
        Image.asset(data.img, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: data.c.withOpacity(0.15),
                child: Center(child: Icon(Icons.image_outlined,
                    color: data.c.withOpacity(0.4), size: 28)))),
        Positioned(top: 7, left: 7, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(color: data.c, borderRadius: BorderRadius.circular(999)),
            child: Text(data.tag, style: const TextStyle(
                color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)))),
      ])),
      Padding(padding: const EdgeInsets.all(9),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data.t, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurface)),
            const SizedBox(height: 3),
            Text(data.date, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
          ])),
    ])));
  }
}
