// lib/features/auth/presentation/screens/login_screen.dart
// Mobile : fond dégradé, formulaire occupant tout l'écran avec padding intérieur
// Desktop : colonne image gauche | formulaire droite
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/bloc/auth/auth_bloc.dart';
import '../../../../core/bloc/theme/theme_cubit.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form     = GlobalKey<FormState>();
  final _email    = TextEditingController();
  final _password = TextEditingController();
  bool  _showPwd  = false;

  @override void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    context.read<AuthBloc>().add(
        AuthLoginRequested(email: _email.text.trim(), password: _password.text));
  }

  @override
  Widget build(BuildContext context) {
    final isWide   = MediaQuery.of(context).size.width >= 700;
    final isDark   = context.watch<ThemeCubit>().isDark;
    final scheme   = Theme.of(context).colorScheme;

    return Scaffold(
      body: isWide ? _buildWide(context, isDark) : _buildMobile(context, scheme, isDark),
    );
  }

  // ── MOBILE : plein écran, fond dégradé + formulaire ────────
  Widget _buildMobile(BuildContext context, ColorScheme scheme, bool isDark) {
    return SafeArea(
      child: Column(children: [
        // ── Bandeau supérieur (logo + titre) ──────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF002021), const Color(0xFF0D1B1B)]
                  : [const Color(0xFF004345), AppColors.teal9],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Bouton retour
            GestureDetector(
              onTap: () => context.go(RouteNames.home),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.arrow_back_ios_rounded, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text('Accueil', style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 16),
            _LogoWidget(),
            const SizedBox(height: 12),
            const Text('Connexion',
                style: TextStyle(color: Colors.white, fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Accédez à votre espace personnel',
                style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
          ]),
        ),

        // ── Formulaire (fond normal) ───────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: _buildForm(context, scheme),
          ),
        ),
      ]),
    );
  }

  // ── DESKTOP : image gauche | formulaire droite ─────────────
  Widget _buildWide(BuildContext context, bool isDark) {
    final scheme = Theme.of(context).colorScheme;
    return Row(children: [
      // Panneau gauche — image + branding
      Expanded(
        child: Stack(fit: StackFit.expand, children: [
          Image.asset('assets/images/auth_bg.jpg', fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF003638), Color(0xFF007EB0)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight)),
              )),
          Container(color: Colors.black.withOpacity(0.45)),
          Padding(
            padding: const EdgeInsets.all(48),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _LogoWidget(),
                  const SizedBox(height: 24),
                  const Text('SPAD Cameroun',
                      style: TextStyle(color: Colors.white, fontSize: 32,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text('Accompagnement à domicile\npour vos proches âgés.',
                      style: TextStyle(color: Colors.white.withOpacity(0.82), fontSize: 16, height: 1.5)),
                  const SizedBox(height: 32),
                  _featureRow(Icons.description_rounded,    'Rapports de garde en temps réel'),
                  const SizedBox(height: 12),
                  _featureRow(Icons.location_on_rounded,    'Localisation GPS des AVS'),
                  const SizedBox(height: 12),
                  _featureRow(Icons.family_restroom_rounded,'Accès famille sécurisé'),
                ]),
          ),
        ]),
      ),

      // Panneau droit — formulaire
      Expanded(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildForm(context, scheme),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _featureRow(IconData icon, String text) => Row(children: [
    Container(width: 30, height: 30,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 15)),
    const SizedBox(width: 10),
    Text(text, style: const TextStyle(
        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
  ]);

  // ── FORMULAIRE commun mobile + desktop ──────────────────────
  Widget _buildForm(BuildContext context, ColorScheme scheme) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.message), backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating));
        }
        // La navigation post-login est gérée dans main.dart (BlocListener global)
      },
      builder: (ctx, state) {
        final loading = state is AuthLoading;
        return Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

            Text('Connexion',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                    color: scheme.onSurface)),
            const SizedBox(height: 4),
            Text('Identifiants fournis par SPAD Cameroun',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 20),

            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email_outlined, size: 18)),
              validator: (v) => (v == null || !v.contains('@')) ? 'Email invalide' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _password,
              obscureText: !_showPwd,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: const Icon(Icons.lock_outline, size: 18),
                suffixIcon: IconButton(
                    iconSize: 18,
                    icon: Icon(_showPwd
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(() => _showPwd = !_showPwd)),
              ),
              validator: (v) => (v == null || v.length < 4) ? 'Min. 4 caractères' : null,
            ),
            const SizedBox(height: 18),

            FilledButton(
              onPressed: loading ? null : _submit,
              child: loading
                  ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Se connecter'),
            ),
            const SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Famille ? ', style: TextStyle(fontSize: 12,
                  color: scheme.onSurfaceVariant)),
              TextButton(
                  onPressed: () => context.go(RouteNames.register),
                  child: const Text('Souscrire', style: TextStyle(fontSize: 12))),
            ]),
            TextButton.icon(
              onPressed: () => context.go(RouteNames.home),
              icon: const Icon(Icons.arrow_back, size: 14),
              label: const Text('Retour à l\'accueil', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
            ),

            const Divider(height: 22),
            Text('Comptes démo', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 4,
                children: [
                  ('avs',    'avs@spad.cm',    'avs1234'),
                  ('famille','famille@spad.cm','fam1234'),
                  ('admin',  'admin@spad.cm',  'admin1234'),
                ].map((d) => ActionChip(
                  label: Text(d.$1, style: const TextStyle(fontSize: 10)),
                  onPressed: () { _email.text = d.$2; _password.text = d.$3; },
                )).toList()),
          ]),
        );
      },
    );
  }
}

class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) => Image.asset('assets/images/logo_spad.png',
      width: 52, height: 52,
      errorBuilder: (_, __, ___) => Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
              color: AppColors.teal9,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5)),
          child: const Center(child: Text('S',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)))));
}
