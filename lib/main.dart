// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
        BlocProvider(
          create: (_) => AuthBloc()..add(const AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'SPAD Cameroun',
            theme:      AppTheme.lightTheme,
            darkTheme:  AppTheme.darkTheme,
            themeMode:  themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            // BlocListener global : réagit aux changements d'auth
            // depuis n'importe quelle page de l'app.
            builder: (context, child) {
              return BlocListener<AuthBloc, AuthState>(
                listener: (ctx, state) {
                  // ─── POST-LOGOUT : retour immédiat à l'accueil ───
                  if (state is AuthUnauthenticated) {
                    // go() réinitialise la pile de navigation
                    AppRouter.router.go(RouteNames.home);
                  }
                  // ─── POST-LOGIN : aller au dashboard du rôle ────
                  if (state is AuthAuthenticated) {
                    AppRouter.router.go(RouteNames.homeForRole(state.role));
                  }
                },
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
