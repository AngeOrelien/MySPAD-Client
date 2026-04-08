// lib/features/splash/splash_screen.dart
//
// ─── POURQUOI LA SPLASH NE S'AFFICHAIT PAS ───────────────────
// Problème : le redirect GoRouter s'exécutait AVANT que la
// splash ait le temps de s'afficher, et la redirigeait vers '/'
// avant même qu'on la voie.
//
// Fix : dans app_router.dart, la règle 1 dit :
//   if (location == '/splash') return null; // ne jamais rediriger
// Donc GoRouter laisse la splash s'afficher.
// C'est la splash elle-même qui navigue via context.go()
// après son timer de 2.5s.
// ─────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/bloc/auth/auth_bloc.dart';
import '../../core/router/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _ctrl;
  late Animation<double>   _fade;
  late Animation<double>   _scale;

  @override
  void initState() {
    super.initState();

    // Animation d'entrée : fade + scale en 800ms
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade  = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _scale = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();

    // Après 2.5s → naviguer selon l'état d'auth
    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        // Déjà connecté (token en mémoire) → dashboard
        context.go(RouteNames.homeForRole(authState.role));
      } else {
        // Visiteur → accueil public
        context.go(RouteNames.home);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004345), // AppColors.teal12
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo ─────────────────────────────────────
                _buildLogo(),
                const SizedBox(height: 28),

                // ── Nom ───────────────────────────────────────
                const Text(
                  'SPAD Cameroun',
                  style: TextStyle(
                    color:       Colors.white,
                    fontSize:    28,
                    fontWeight:  FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Soins à domicile · Yaoundé & Douala',
                  style: TextStyle(
                    color:    Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 64),

                // ── Indicateur de chargement ──────────────────
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    color:           const Color(0xFF00C7CC),
                    borderRadius:    BorderRadius.circular(4),
                    minHeight:       3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    // ── Pour mettre ton vrai logo : ───────────────────────────
    // 1. Place logo_spad.png dans assets/images/
    // 2. Déclare dans pubspec.yaml : assets: [assets/images/]
    // 3. Le errorBuilder ci-dessous gère l'absence du fichier
    return Image.asset(
      'assets/images/logo_spad.png',
      width: 100, height: 100,
      errorBuilder: (_, __, ___) => Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          color:        const Color(0xFF00C7CC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        ),
        child: const Center(
          child: Text('S',
            style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}
