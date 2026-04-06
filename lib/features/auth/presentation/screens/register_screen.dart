// lib/features/auth/presentation/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, this.isDarkBg = false});
  final bool isDarkBg;
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey      = GlobalKey<FormState>();
  final _nomCtrl      = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _telCtrl      = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool   _showPwd   = false;
  bool   _isLoading = false;
  bool   _success   = false;
  String _role      = 'famille';

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    setState(() { _isLoading = false; _success = true; });
  }

  @override
  Widget build(BuildContext context) {
    final scheme   = Theme.of(context).colorScheme;
    final fillColor = widget.isDarkBg
        ? Colors.white.withOpacity(0.12)
        : scheme.surfaceVariant;
    final textColor = widget.isDarkBg ? Colors.white : scheme.onSurface;
    final hintColor = widget.isDarkBg ? Colors.white54 : scheme.onSurfaceVariant;

    if (_success) return _buildSuccessView(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // // Rôle
            // _RoleSelector(
            //   selected:  _role,
            //   isDarkBg:  widget.isDarkBg,
            //   onChanged: (r) => setState(() => _role = r),
            // ),

            _Field(controller: _nomCtrl, label: 'Nom complet', hint: 'Jean Dupont',
              icon: Icons.person_outline, fillColor: fillColor, textColor: textColor,
              hintColor: hintColor, isDarkBg: widget.isDarkBg,
              validator: (v) => (v == null || v.trim().length < 3)
                  ? 'Minimum 3 caractères' : null),
            const SizedBox(height: 12),

            _Field(controller: _emailCtrl, label: 'Email', hint: 'jean@exemple.com',
              icon: Icons.email_outlined, fillColor: fillColor, textColor: textColor,
              hintColor: hintColor, isDarkBg: widget.isDarkBg,
              keyboard: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Email invalide' : null),
            const SizedBox(height: 12),

            _Field(controller: _telCtrl, label: 'Téléphone', hint: '+237 6XX XXX XXX',
              icon: Icons.phone_outlined, fillColor: fillColor, textColor: textColor,
              hintColor: hintColor, isDarkBg: widget.isDarkBg,
              keyboard: TextInputType.phone,
              validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null),
            const SizedBox(height: 12),

            _Field(controller: _passwordCtrl, label: 'Mot de passe', hint: '••••••••',
              icon: Icons.lock_outline, fillColor: fillColor, textColor: textColor,
              hintColor: hintColor, isDarkBg: widget.isDarkBg,
              obscure: !_showPwd,
              suffixIcon: IconButton(
                icon: Icon(_showPwd ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: hintColor, size: 20),
                onPressed: () => setState(() => _showPwd = !_showPwd),
              ),
              validator: (v) => (v == null || v.length < 8)
                  ? 'Minimum 8 caractères' : null),
            const SizedBox(height: 20),

            FilledButton(
              onPressed: _isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.green7,
                foregroundColor: Colors.white,
                padding:         const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Créer mon compte'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: AppColors.green1, shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_outline,
            size: 40, color: AppColors.green7),
        ),
        const SizedBox(height: 20),
        Text('Demande envoyée !',
          style: AppTextStyles.headlineMedium.copyWith(
            color: widget.isDarkBg ? Colors.white
                : Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 10),
        Text('Notre équipe vérifiera votre compte et vous contactera sous 24h.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: widget.isDarkBg ? Colors.white70
                : Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

// class _RoleSelector extends StatelessWidget {
//   const _RoleSelector({
//     required this.selected,
//     required this.onChanged,
//     required this.isDarkBg,
//   });
//   final String                 selected;
//   final ValueChanged<String>   onChanged;
//   final bool                   isDarkBg;

//   @override
//   Widget build(BuildContext context) {
//     final roles = [
//       ('famille', 'Famille',    Icons.family_restroom),
//       // ('avs',     'AVS',        Icons.badge),
//       // ('medecin', 'Médecin',    Icons.local_hospital),
//     ];
//     return Wrap(
//       spacing: 6, runSpacing: 6,
//       children: roles.map((r) {
//         final isSelected = selected == r.$1;
//         return ChoiceChip(
//           label:    Text(r.$2),
//           avatar:   Icon(r.$3, size: 16),
//           selected: isSelected,
//           onSelected: (_) => onChanged(r.$1),
//           selectedColor: AppColors.teal3,
//           labelStyle: AppTextStyles.labelMedium.copyWith(
//             color: isSelected ? AppColors.teal12
//                 : isDarkBg ? Colors.white
//                 : Theme.of(context).colorScheme.onSurface),
//         );
//       }).toList(),
//     );
//   }
// }

class _Field extends StatelessWidget {
  const _Field({
    required this.controller, required this.label, required this.hint,
    required this.icon, required this.fillColor, required this.textColor,
    required this.hintColor, required this.isDarkBg,
    this.keyboard, this.obscure = false, this.suffixIcon, this.validator,
  });

  final TextEditingController        controller;
  final String                       label, hint;
  final IconData                     icon;
  final Color                        fillColor, textColor, hintColor;
  final bool                         isDarkBg, obscure;
  final TextInputType?               keyboard;
  final Widget?                      suffixIcon;
  final FormFieldValidator<String>?  validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:   controller,
      keyboardType: keyboard,
      obscureText:  obscure,
      style:        AppTextStyles.bodyMedium.copyWith(color: textColor),
      decoration: InputDecoration(
        labelText:     label,
        hintText:      hint,
        labelStyle:    AppTextStyles.bodySmall.copyWith(color: hintColor),
        hintStyle:     AppTextStyles.bodySmall.copyWith(color: hintColor),
        prefixIcon:    Icon(icon, color: hintColor, size: 20),
        suffixIcon:    suffixIcon,
        filled:        true,
        fillColor:     fillColor,
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDarkBg ? Colors.white24 : Colors.transparent)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDarkBg ? Colors.white24 : Colors.transparent)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.teal9, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
    );
  }
}