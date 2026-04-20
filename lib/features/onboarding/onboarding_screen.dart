// lib/features/onboarding/onboarding_screen.dart
//
// ─── ONBOARDING — PREMIÈRE INSTALLATION ─────────────────────
// 3 slides + bouton "Commencer". Stocke un flag en mémoire
// (Phase 7 : shared_preferences pour ne pas répéter).
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_names.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl  = PageController();
  int   _page  = 0;

  static const _slides = [
    _Slide(
      gradient:    [Color(0xFF00C7CC), Color(0xFF004345)],
      icon:        Icons.elderly_outlined,
      title:       'Suivi à domicile',
      subtitle:    'SPAD Cameroun accompagne les personnes âgées avec des auxiliaires de vie qualifiés à Yaoundé et Douala.',
      badge:       'Soins personnalisés',
    ),
    _Slide(
      gradient:    [Color(0xFF0C8C6B), Color(0xFF032820)],
      icon:        Icons.monitor_heart_outlined,
      title:       'Santé en temps réel',
      subtitle:    'Suivez les paramètres vitaux, les rapports quotidiens et l\'état de santé de votre proche en un clic.',
      badge:       'Rapports quotidiens',
    ),
    _Slide(
      gradient:    [Color(0xFFF5A623), Color(0xFF4D3200)],
      icon:        Icons.family_restroom_outlined,
      title:       'Famille rassurée',
      subtitle:    'Recevez des alertes, consultez les comptes-rendus et restez en contact avec l\'équipe médicale.',
      badge:       'Notifications famille',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        // ── Slides ─────────────────────────────────────────
        PageView.builder(
          controller: _ctrl,
          itemCount:  _slides.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) => _SlideView(slide: _slides[i], size: size),
        ),

        // ── Overlay bottom ─────────────────────────────────
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(24, 32, 24, MediaQuery.of(context).padding.bottom + 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)]),
            ),
            child: Column(children: [
              // Dots
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_slides.length, (i) =>
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin:   const EdgeInsets.symmetric(horizontal: 4),
                  width:    i == _page ? 24 : 8,
                  height:   8,
                  decoration: BoxDecoration(
                    color:        i == _page ? Colors.white : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4)),
                ),
              )),
              const SizedBox(height: 28),

              // Bouton principal
              if (_page < _slides.length - 1)
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  TextButton(
                    onPressed: () => _finish(context),
                    child: Text('Passer', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15))),
                  FilledButton(
                    onPressed: () => _ctrl.nextPage(
                      duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF004345),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('Suivant', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ]),
                  ),
                ])
              else
                // Dernier slide → "Commencer"
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _finish(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF004345),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.rocket_launch_outlined, size: 20),
                      SizedBox(width: 10),
                      Text('Commencer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
            ]),
          ),
        ),
      ]),
    );
  }

  void _finish(BuildContext context) {
    // Phase 7 : SharedPreferences.setBool('onboarding_done', true)
    context.go(RouteNames.home);
  }
}

class _Slide {
  const _Slide({required this.gradient, required this.icon,
    required this.title, required this.subtitle, required this.badge});
  final List<Color> gradient;
  final IconData    icon;
  final String      title, subtitle, badge;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide, required this.size});
  final _Slide slide; final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width, height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: slide.gradient)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Icône centrale
              Container(
                width: 130, height: 130,
                decoration: BoxDecoration(
                  color:  Colors.white.withOpacity(0.15),
                  shape:  BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)),
                child: Icon(slide.icon, size: 64, color: Colors.white),
              ),
              const SizedBox(height: 32),

              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color:        Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                  border:       Border.all(color: Colors.white.withOpacity(0.3))),
                child: Text(slide.badge,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 20),

              // Titre
              Text(slide.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color:      Colors.white,
                  fontSize:   30,
                  fontWeight: FontWeight.w800,
                  height:     1.2)),
              const SizedBox(height: 16),

              // Sous-titre
              Text(slide.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:    Colors.white.withOpacity(0.85),
                  fontSize: 15,
                  height:   1.5)),

              const SizedBox(height: 120), // espace pour le footer
            ],
          ),
        ),
      ),
    );
  }
}
