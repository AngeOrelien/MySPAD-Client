// lib/features/auth/presentation/screens/login_screen.dart
//
// LoginForm : formulaire de connexion.
// Phase 2 : authentification simulée avec des comptes démo.
// Phase 4 : remplacer _loginDemo() par un appel HTTP au backend.
//
// COMPTES DÉMO (à supprimer en prod) :
//   avs@spad.cm          / avs1234
//   famille@spad.cm      / famille1234
//   admin@spad.cm        / admin1234
//   coordsante@spad.cm   / coord1234

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/user_session.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onLogin,
    this.isDarkBg = false,
  });

  final void Function({required String role, required String name, String email}) onLogin;
  final bool isDarkBg;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool   _showPwd   = false;
  bool   _isLoading = false;
  String? _errorMsg;

  // ── Comptes démo ───────────────────────────────────────────
  static const _demoAccounts = {
    'avs@spad.cm':         {'role': 'avs',            'name': 'Jean Ngono AVS',   'password': 'avs1234'},
    'famille@spad.cm':     {'role': 'famille',         'name': 'Marie Famille',    'password': 'famille1234'},
    'admin@spad.cm':       {'role': 'admin',           'name': 'Admin SPAD',       'password': 'admin1234'},
    'coordsante@spad.cm':  {'role': 'coordSante',      'name': 'Paul Coordinateur','password': 'coord1234'},
    'coordpers@spad.cm':   {'role': 'coordPersonnel',  'name': 'Alice Personnel',  'password': 'coord1234'},
    'medecin@spad.cm':     {'role': 'medecin',         'name': 'Dr. Kamga',        'password': 'med1234'},
  };

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMsg = null; });

    // Simule un délai réseau de 1.2s
    // Phase 4 : remplacer par http.post('/api/auth/login', ...)
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final email    = _emailCtrl.text.trim().toLowerCase();
    final password = _passwordCtrl.text;
    final account  = _demoAccounts[email];

    if (account != null && account['password'] == password) {
      // ✅ Succès : notifier AppShell
      widget.onLogin(
        role:  account['role']!,
        name:  account['name']!,
        email: email,
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMsg  = 'Email ou mot de passe incorrect.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inputFill = widget.isDarkBg
        ? Colors.white.withOpacity(0.12)
        : scheme.surfaceVariant;
    final inputText = widget.isDarkBg ? Colors.white : scheme.onSurface;
    final hintText  = widget.isDarkBg ? Colors.white54 : scheme.onSurfaceVariant;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Email ──────────────────────────────────────
            _buildField(
              controller:   _emailCtrl,
              label:        'Email',
              hint:         'avs@spad.cm',
              icon:         Icons.email_outlined,
              keyboard:     TextInputType.emailAddress,
              fillColor:    inputFill,
              textColor:    inputText,
              hintColor:    hintText,
              isDarkBg:     widget.isDarkBg,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email requis';
                if (!v.contains('@'))       return 'Email invalide';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ── Mot de passe ───────────────────────────────
            _buildField(
              controller:   _passwordCtrl,
              label:        'Mot de passe',
              hint:         '••••••••',
              icon:         Icons.lock_outline,
              fillColor:    inputFill,
              textColor:    inputText,
              hintColor:    hintText,
              isDarkBg:     widget.isDarkBg,
              obscure:      !_showPwd,
              suffixIcon: IconButton(
                icon: Icon(
                  _showPwd ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: hintText, size: 20,
                ),
                onPressed: () => setState(() => _showPwd = !_showPwd),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Mot de passe requis';
                if (v.length < 6)           return 'Minimum 6 caractères';
                return null;
              },
            ),
            const SizedBox(height: 8),

            // ── Lien mot de passe oublié ───────────────────
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text('Mot de passe oublié ?',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.teal9)),
              ),
            ),

            // ── Message d'erreur ───────────────────────────
            if (_errorMsg != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color:        AppColors.errorLight,
                  borderRadius: BorderRadius.circular(8),
                  border:       Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 16, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_errorMsg!,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.error))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            // ── Bouton connexion ───────────────────────────
            FilledButton(
              onPressed: _isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.teal9,
                foregroundColor: Colors.white,
                padding:         const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Se connecter'),
            ),
            const SizedBox(height: 16),

            // ── Comptes démo (à supprimer en prod) ────────
            _buildDemoAccounts(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoAccounts(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text('— Comptes démo —',
          style: AppTextStyles.labelSmall.copyWith(
            color: widget.isDarkBg ? Colors.white54 : scheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6, runSpacing: 6,
          alignment: WrapAlignment.center,
          children: _demoAccounts.entries.map((e) {
            final role = e.value['role']!;
            return ActionChip(
              label: Text(role, style: AppTextStyles.labelSmall),
              onPressed: () {
                _emailCtrl.text    = e.key;
                _passwordCtrl.text = e.value['password']!;
              },
              backgroundColor: AppColors.teal3,
              labelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.teal12),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String                label,
    required String                hint,
    required IconData              icon,
    required Color                 fillColor,
    required Color                 textColor,
    required Color                 hintColor,
    required bool                  isDarkBg,
    TextInputType?                 keyboard,
    bool                           obscure  = false,
    Widget?                        suffixIcon,
    FormFieldValidator<String>?    validator,
  }) {
    return TextFormField(
      controller:   controller,
      keyboardType: keyboard,
      obscureText:  obscure,
      style:        AppTextStyles.bodyMedium.copyWith(color: textColor),
      decoration: InputDecoration(
        labelText:   label,
        hintText:    hint,
        labelStyle:  AppTextStyles.bodySmall.copyWith(color: hintColor),
        hintStyle:   AppTextStyles.bodySmall.copyWith(color: hintColor),
        prefixIcon:  Icon(icon, color: hintColor, size: 20),
        suffixIcon:  suffixIcon,
        filled:      true,
        fillColor:   fillColor,
        border:      OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:   BorderSide(
            color: isDarkBg ? Colors.white24 : Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:   BorderSide(
            color: isDarkBg ? Colors.white24 : Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:   const BorderSide(color: AppColors.teal9, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:   const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
    );
  }
}