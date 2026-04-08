// lib/features/auth/screens/login_screen.dart
// Scaffold SEUL — pas de BottomNav, pas de Sidebar, pas de FAB chatbot
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/bloc/auth/auth_bloc.dart';
import '../../../../core/router/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form     = GlobalKey<FormState>();
  final _email    = TextEditingController();
  final _password = TextEditingController();
  bool  _showPwd  = false;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    // Dispatcher l'event → AuthBloc → main.dart BlocListener navigue
    context.read<AuthBloc>().add(
      AuthLoginRequested(email: _email.text.trim(), password: _password.text));
  }

  @override
  Widget build(BuildContext ctx) {
    final narrow = MediaQuery.of(ctx).size.width < 700;
    return Scaffold(
      body: Stack(children: [
        // Image de fond
        Positioned.fill(child: Image.asset('assets/images/auth_bg.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF004345), Color(0xFF00C7CC)],
                begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
        )),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.55))),
        SafeArea(child: narrow ? _mobile(ctx) : _desktop(ctx)),
      ]),
    );
  }

  Widget _mobile(BuildContext ctx) => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(children: [
      const SizedBox(height: 32),
      _Logo(),
      const SizedBox(height: 32),
      _Card(form: _form, email: _email, password: _password,
        showPwd: _showPwd, onTogglePwd: () => setState(() => _showPwd = !_showPwd),
        onSubmit: _submit),
    ]),
  );

  Widget _desktop(BuildContext ctx) => Row(children: [
    Expanded(child: Padding(
      padding: const EdgeInsets.all(64),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Logo(),
        const SizedBox(height: 24),
        const Text('SPAD Cameroun',
          style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Text('Accompagnement à domicile\npour vos proches âgés.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
      ]),
    )),
    Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460),
      child: Padding(padding: const EdgeInsets.all(48),
        child: _Card(form: _form, email: _email, password: _password,
          showPwd: _showPwd, onTogglePwd: () => setState(() => _showPwd = !_showPwd),
          onSubmit: _submit),
      ),
    )),
  ]);
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) => Image.asset('assets/images/logo_spad.png',
    width: 80, height: 80,
    errorBuilder: (_, __, ___) => Container(
      width: 80, height: 80,
      decoration: BoxDecoration(color: const Color(0xFF00C7CC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)),
      child: const Center(child: Text('S',
        style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800))),
    ));
}

class _Card extends StatelessWidget {
  const _Card({required this.form, required this.email, required this.password,
    required this.showPwd, required this.onTogglePwd, required this.onSubmit});
  final GlobalKey<FormState>   form;
  final TextEditingController  email, password;
  final bool                   showPwd;
  final VoidCallback           onTogglePwd, onSubmit;

  static const _demos = [
    ('avs',    'avs@spad.cm',    'avs1234'),
    ('famille','famille@spad.cm','fam1234'),
    ('admin',  'admin@spad.cm',  'admin1234'),
  ];

  @override
  Widget build(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.97), borderRadius: BorderRadius.circular(20)),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (c, s) {
          if (s is AuthError) {
            ScaffoldMessenger.of(c).showSnackBar(SnackBar(
              content: Text(s.message), backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating));
          }
          // Navigation vers dashboard gérée dans main.dart BlocListener
        },
        builder: (c, s) {
          final loading = s is AuthLoading;
          return Form(key: form, child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Connexion', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: scheme.onSurface)),
              const SizedBox(height: 6),
              Text('Accédez à votre espace personnel',
                style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 24),

              TextFormField(
                controller: email, keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                validator: (v) => (v == null || !v.contains('@')) ? 'Email invalide' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: password, obscureText: !showPwd,
                decoration: InputDecoration(
                  labelText: 'Mot de passe', prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(showPwd ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: onTogglePwd),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'Min. 6 caractères' : null,
              ),
              const SizedBox(height: 20),

              FilledButton(
                onPressed: loading ? null : onSubmit,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: loading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Se connecter'),
              ),
              const SizedBox(height: 12),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Famille ? ', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                TextButton(onPressed: () => ctx.go(RouteNames.register), child: const Text('Souscrire')),
              ]),
              TextButton.icon(
                onPressed: () => ctx.go(RouteNames.home),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Retour à l\'accueil'),
                style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
              ),

              const Divider(height: 24),
              Text('Comptes démo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 4,
                children: _demos.map((d) => ActionChip(
                  label: Text(d.$1, style: const TextStyle(fontSize: 11)),
                  onPressed: () { email.text = d.$2; password.text = d.$3; },
                )).toList(),
              ),
            ],
          ));
        },
      ),
    );
  }
}
