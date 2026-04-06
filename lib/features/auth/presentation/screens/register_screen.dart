// lib/features/auth/presentation/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/models/spad_nav_item.dart';
import '../../../../shared/widgets/spad_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentNavIndex = 2; // index 2 = S'inscrire

  // GlobalKey pour valider le formulaire
  // GlobalKey : identifiant unique d'un widget dans tout l'arbre
  final _formKey = GlobalKey<FormState>();

  // Controllers : lisent et contrôlent le contenu d'un TextField
  final _nomController      = TextEditingController();
  final _emailController    = TextEditingController();
  final _telController      = TextEditingController();
  final _passwordController = TextEditingController();

  // État local
  bool _showPassword  = false;
  bool _isLoading     = false;
  String _selectedRole = 'famille'; // valeur par défaut

  // Libérer les controllers quand le widget est détruit
  // → évite les fuites mémoire
  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpadScaffold(
      navItems:     SpadNavItems.visitor,
      currentIndex: _currentNavIndex,
      onNavTap:     (i) => setState(() => _currentNavIndex = i),
      appBar: AppBar(title: const Text("S'inscrire")),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final scheme   = Theme.of(context).colorScheme;
    final hPad     = ResponsiveUtils.horizontalPadding(context);
    final isMobile = ResponsiveUtils.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          // Sur desktop, le formulaire ne prend pas toute la largeur
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Text("Créer votre compte",
                style: AppTextStyles.headlineLarge.copyWith(color: scheme.onSurface)),
              const SizedBox(height: 8),
              Text("Remplissez le formulaire. Notre équipe validera votre inscription.",
                style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 32),

              // ── FORMULAIRE ──────────────────────────────
              // Form + GlobalKey → permet la validation groupée
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sélecteur de rôle
                    Text('Je suis …',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: scheme.onSurface)),
                    const SizedBox(height: 8),
                    _buildRoleSelector(context, scheme),
                    const SizedBox(height: 20),

                    // Nom complet
                    _SpadField(
                      controller: _nomController,
                      label:      'Nom complet',
                      hint:       'Jean Dupont',
                      icon:       Icons.person_outline,
                      validator:  (v) {
                        // validator : retourne null si OK, sinon message d'erreur
                        if (v == null || v.trim().isEmpty) {
                          return 'Le nom est requis';
                        }
                        if (v.trim().length < 3) {
                          return 'Minimum 3 caractères';
                        }
                        return null; // null = valide
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _SpadField(
                      controller: _emailController,
                      label:      'Adresse email',
                      hint:       'jean@exemple.com',
                      icon:       Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'L\'email est requis';
                        // Regex simple de validation email
                        if (!v.contains('@') || !v.contains('.')) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Téléphone
                    _SpadField(
                      controller:  _telController,
                      label:       'Téléphone',
                      hint:        '+237 6XX XXX XXX',
                      icon:        Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator:   (v) {
                        if (v == null || v.isEmpty) return 'Le téléphone est requis';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Mot de passe
                    TextFormField(
                      controller:   _passwordController,
                      obscureText:  !_showPassword, // masque le texte si true
                      decoration:   InputDecoration(
                        labelText:    'Mot de passe',
                        hintText:     'Minimum 8 caractères',
                        prefixIcon:   const Icon(Icons.lock_outline),
                        // Bouton œil pour afficher/masquer
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Le mot de passe est requis';
                        if (v.length < 8) return 'Minimum 8 caractères';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Bouton soumettre
                    FilledButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          // CircularProgressIndicator : spinner de chargement
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:       Colors.white,
                              ),
                            )
                          : const Text("Créer mon compte"),
                    ),
                    const SizedBox(height: 16),

                    // Lien connexion
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO Phase 3 : context.go('/login')
                        },
                        child: const Text("Déjà un compte ? Se connecter"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector(BuildContext context, ColorScheme scheme) {
    final roles = [
      ('famille',  'Famille / Patient', Icons.family_restroom),
      ('avs',      'Auxiliaire de vie',  Icons.badge),
      ('medecin',  'Médecin',            Icons.local_hospital),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: roles.map((r) {
        final selected = _selectedRole == r.$1;
        return ChoiceChip(
          // ChoiceChip : chip sélectionnable (radio-button style)
          label:    Text(r.$2),
          avatar:   Icon(r.$3, size: 16),
          selected: selected,
          onSelected: (_) => setState(() => _selectedRole = r.$1),
          selectedColor:    AppColors.teal3,
          labelStyle: AppTextStyles.labelMedium.copyWith(
            color: selected ? AppColors.teal12 : scheme.onSurface,
          ),
        );
      }).toList(),
    );
  }

  void _submitForm() async {
    // formKey.currentState!.validate() déclenche tous les validators
    // Retourne true si tous passent, false sinon
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simule un appel réseau de 2 secondes
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!mounted) return; // vérifie que le widget est encore dans l'arbre

    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demande envoyée ! Nous vous contactons sous 24h.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGET INTERNE — champ de formulaire réutilisable
// ─────────────────────────────────────────────────────────────
class _SpadField extends StatelessWidget {
  const _SpadField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:   controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText:  label,
        hintText:   hint,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}