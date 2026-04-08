// lib/features/auth/screens/register_screen.dart
// FAMILLES UNIQUEMENT — Souscrire aux services SPAD
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/bloc/auth/auth_bloc.dart';
import '../../../../core/router/route_names.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form     = GlobalKey<FormState>();
  final _nom      = TextEditingController();
  final _email    = TextEditingController();
  final _tel      = TextEditingController();
  final _pwd      = TextEditingController();
  final _confirm  = TextEditingController();
  final _patNom   = TextEditingController();
  final _patAge   = TextEditingController();
  bool  _showPwd  = false;

  @override
  void dispose() {
    for (final c in [_nom,_email,_tel,_pwd,_confirm,_patNom,_patAge]) c.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthRegisterRequested(
      nom: _nom.text.trim(), email: _email.text.trim(),
      telephone: _tel.text.trim(), password: _pwd.text));
  }

  @override
  Widget build(BuildContext ctx) {
    final narrow = MediaQuery.of(ctx).size.width < 700;
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(child: Image.asset('assets/images/auth_bg.jpg', fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF032820), Color(0xFF0C8C6B)],
              begin: Alignment.topLeft, end: Alignment.bottomRight))))),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.55))),
        SafeArea(child: narrow ? _mobile(ctx) : _desktop(ctx)),
      ]),
    );
  }

  Widget _mobile(BuildContext ctx) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      const SizedBox(height: 20),
      _Logo(),
      const SizedBox(height: 24),
      _buildCard(ctx),
    ]));

  Widget _desktop(BuildContext ctx) => Row(children: [
    Expanded(child: Padding(padding: const EdgeInsets.all(64),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Logo(),
        const SizedBox(height: 20),
        const Text('Souscrire aux services SPAD',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Text('Confiez le suivi de votre proche âgé\nà nos auxiliaires qualifiés.',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
        const SizedBox(height: 20),
        ...['Suivi médical quotidien','Rapports famille','Pilulier connecté','Géolocalisation AVS']
            .map((t) => Padding(padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                const Icon(Icons.check_circle, color: Color(0xFF00C7CC), size: 16),
                const SizedBox(width: 8),
                Text(t, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
              ]))),
      ]))),
    Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460),
      child: Padding(padding: const EdgeInsets.all(48), child: _buildCard(ctx)))),
  ]);

  Widget _buildCard(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.97), borderRadius: BorderRadius.circular(20)),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (c, s) {
          if (s is AuthRegisterSuccess) {
            showDialog(context: c, barrierDismissible: false, builder: (_) => AlertDialog(
              title: const Text('Demande envoyée !'),
              content: const Text('Votre demande de souscription a été envoyée.\n\n'
                  'L\'équipe SPAD vous contactera sous 24h pour valider votre dossier.'),
              actions: [FilledButton(
                onPressed: () { Navigator.pop(c); c.go(RouteNames.home); },
                child: const Text('Retour à l\'accueil'))],
            ));
          }
          if (s is AuthError) {
            ScaffoldMessenger.of(c).showSnackBar(SnackBar(
              content: Text(s.message), backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating));
          }
        },
        builder: (c, s) {
          final loading = s is AuthLoading;
          return Form(key: _form, child: SingleChildScrollView(child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge famille
              Align(alignment: Alignment.centerLeft, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFF0FAF6),
                  borderRadius: BorderRadius.circular(999)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.family_restroom, size: 14, color: Color(0xFF0C8C6B)),
                  SizedBox(width: 4),
                  Text('Espace famille', style: TextStyle(fontSize: 11, color: Color(0xFF0C8C6B), fontWeight: FontWeight.w600)),
                ]),
              )),
              const SizedBox(height: 10),
              Text('Souscrire aux services SPAD',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurface)),
              const SizedBox(height: 18),

              _label('Vos coordonnées', scheme),
              const SizedBox(height: 8),
              _field(_nom, 'Nom complet', Icons.person_outline, (v) => (v==null||v.length<3)?'Min 3 car.':null),
              const SizedBox(height: 10),
              _field(_email, 'Email', Icons.email_outlined, (v) => (v==null||!v.contains('@'))?'Invalide':null,
                keyboard: TextInputType.emailAddress),
              const SizedBox(height: 10),
              _field(_tel, 'Téléphone (+237...)', Icons.phone_outlined, (v) => (v==null||v.isEmpty)?'Requis':null,
                keyboard: TextInputType.phone),
              const SizedBox(height: 16),

              _label('Le proche à accompagner', scheme),
              const SizedBox(height: 8),
              _field(_patNom, 'Nom du patient', Icons.elderly_outlined, (v) => (v==null||v.isEmpty)?'Requis':null),
              const SizedBox(height: 10),
              _field(_patAge, 'Âge (ex: 78)', Icons.cake_outlined, (v) => (v==null||v.isEmpty)?'Requis':null,
                keyboard: TextInputType.number),
              const SizedBox(height: 16),

              _label('Mot de passe', scheme),
              const SizedBox(height: 8),
              TextFormField(
                controller: _pwd, obscureText: !_showPwd,
                decoration: InputDecoration(labelText: 'Mot de passe (min 8 car.)',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_showPwd ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _showPwd = !_showPwd))),
                validator: (v) => (v==null||v.length<8)?'Min 8 car.':null),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirm, obscureText: !_showPwd,
                decoration: const InputDecoration(labelText: 'Confirmer le mot de passe',
                  prefixIcon: Icon(Icons.lock_outline)),
                validator: (v) => v != _pwd.text ? 'Ne correspondent pas' : null),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: loading ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0C8C6B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
                child: loading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Envoyer ma demande'),
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Déjà un compte ? ', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                TextButton(onPressed: () => ctx.go(RouteNames.login), child: const Text('Se connecter')),
              ]),
              TextButton.icon(
                onPressed: () => ctx.go(RouteNames.home),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Retour à l\'accueil'),
                style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
              ),
            ],
          )));
        },
      ),
    );
  }

  Widget _label(String t, ColorScheme s) => Row(children: [
    Container(width: 3, height: 14, decoration: BoxDecoration(
      color: const Color(0xFF00C7CC), borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: s.onSurface)),
  ]);

  Widget _field(TextEditingController ctrl, String label, IconData icon,
    FormFieldValidator<String>? validator, {TextInputType? keyboard}) {
    return TextFormField(controller: ctrl, keyboardType: keyboard,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: validator);
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) => Image.asset('assets/images/logo_spad.png', width: 72, height: 72,
    errorBuilder: (_, __, ___) => Container(
      width: 72, height: 72,
      decoration: BoxDecoration(color: const Color(0xFF00C7CC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)),
      child: const Center(child: Text('S', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800))),
    ));
}
