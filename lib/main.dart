// lib/main.dart
// ─── POINT D'ENTRÉE FINAL ────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/router/route_names.dart';
import 'core/theme/app_theme.dart';
import 'core/bloc/auth/auth_bloc.dart';
import 'core/bloc/theme/theme_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SpadApp());
}

class SpadApp extends StatelessWidget {
  const SpadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthBloc : lancé immédiatement avec AuthCheckRequested
        // pour vérifier si l'utilisateur est déjà connecté
        BlocProvider(
          create: (_) => AuthBloc()..add(const AuthCheckRequested()),
        ),
        // ThemeCubit : gère light/dark/system
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      // child: BlocBuilder<ThemeCubit, ThemeMode>(
      //   builder: (context, themeMode) {
      //     return BlocListener<AuthBloc, AuthState>(
      //       // BlocListener : réagit aux changements d'état SANS rebuild
      //       // C'est ici qu'on fait la navigation après login/logout
      //       listener: (ctx, state) {
      //         if (state is AuthAuthenticated) {
      //           // Connecté → aller au dashboard du rôle
      //           AppRouter.router.go(RouteNames.homeForRole(state.role));
      //         }
      //         if (state is AuthUnauthenticated) {
      //           // Déconnecté → retour à l'accueil
      //           AppRouter.router.go(RouteNames.home);
      //         }
      //       },
      //       child: MaterialApp.router(
      //         title:                      'SPAD Cameroun',
      //         theme:                      AppTheme.lightTheme,
      //         darkTheme:                  AppTheme.darkTheme,
      //         themeMode:                  themeMode,
      //         debugShowCheckedModeBanner: false,
      //         // MaterialApp.router = version GoRouter de MaterialApp
      //         routerConfig:               AppRouter.router,
      //       ),
      //     );
      //   },
      // ),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'SPAD Cameroun',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
