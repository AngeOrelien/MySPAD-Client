// lib/shared/widgets/spad_ai_assistant.dart
//
// ─── ASSISTANT IA SPAD ───────────────────────────────────────
// Remplace l'ancien bouton dark/light mode.
// Un FAB qui ouvre un BottomSheet avec :
//   • Un bouton toggle light/dark en haut
//   • Une interface de chat IA (connectée à l'API en Phase 6)
//
// POUR CONNECTER À UNE IA :
//   Remplacer _sendMessage() par un appel à votre backend
//   Node.js qui appelle l'API Claude/OpenAI
// ─────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SpadAIAssistant extends StatelessWidget {
  const SpadAIAssistant({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode    themeMode;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag:   'spad-ai',
      tooltip:   'Assistant SPAD',
      onPressed: () => _openAssistant(context),
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.white,
      child: const Icon(Icons.smart_toy_outlined, size: 24),
    );
  }

  void _openAssistant(BuildContext context) {
    showModalBottomSheet(
      context:          context,
      isScrollControlled: true,   // permet de contrôler la hauteur
      useSafeArea:      true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AssistantSheet(
        themeMode:     themeMode,
        onToggleTheme: onToggleTheme,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SHEET CONTENU — interface de l'assistant
// ─────────────────────────────────────────────────────────────
class _AssistantSheet extends StatefulWidget {
  const _AssistantSheet({
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode    themeMode;
  final VoidCallback onToggleTheme;

  @override
  State<_AssistantSheet> createState() => _AssistantSheetState();
}

class _AssistantSheetState extends State<_AssistantSheet> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController      _scrollController = ScrollController();
  final List<_Message>        _messages = [
    _Message(
      text:    'Bonjour ! Je suis l\'assistant SPAD Cameroun. Comment puis-je vous aider ?',
      isUser:  false,
    ),
  ];
  bool _isTyping = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _isTyping = true;
      _inputController.clear();
    });

    _scrollToBottom();

    // Simule une réponse après 1.5s
    // → Phase 6 : remplacer par appel HTTP au backend Node.js
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(_Message(
          text:   _getMockResponse(text),
          isUser: false,
        ));
      });
      _scrollToBottom();
    });
  }

  String _getMockResponse(String question) {
    final q = question.toLowerCase();
    if (q.contains('rapport'))   return 'Pour rédiger un rapport, allez dans la section "Rapports" de votre tableau de bord et cliquez sur "Nouveau rapport".';
    if (q.contains('patient'))   return 'Les informations de votre patient se trouvent dans la section "Mon patient" de votre tableau de bord.';
    if (q.contains('localisa'))  return 'Votre position GPS est partagée automatiquement pendant vos heures de service. Vous pouvez la vérifier dans "Ma position".';
    if (q.contains('médica'))    return 'Les médicaments doivent être administrés selon le planning du pilulier. Vérifiez la section "Patient" pour les horaires.';
    if (q.contains('spad'))      return 'SPAD Cameroun est une société de prestation d\'aide à domicile opérant à Yaoundé et Douala depuis 2020.';
    return 'Je comprends votre question. Notre équipe peut vous aider au +237 6XX XXX XXX ou par email à contact@spad-cameroun.cm';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve:    Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme   = Theme.of(context).colorScheme;
    // DraggableScrollableSheet donne 75% de l'écran
    final sheetH   = MediaQuery.of(context).size.height * 0.75;
    final isDark   = widget.themeMode == ThemeMode.dark;

    return SizedBox(
      height: sheetH,
      child: Column(
        children: [
          // ── Handle + header ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color:        scheme.outline.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Avatar assistant
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color:        scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.smart_toy_outlined,
                        size: 20, color: scheme.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assistant SPAD',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: scheme.onSurface)),
                          Text('Toujours disponible',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.green7)),
                        ],
                      ),
                    ),
                    // Bouton toggle dark/light MODE
                    Tooltip(
                      message: isDark ? 'Passer en mode clair' : 'Passer en mode sombre',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: widget.onToggleTheme,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                size:  20,
                                color: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isDark ? 'Clair' : 'Sombre',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 16),

          // ── Messages ─────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller:  _scrollController,
              padding:     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount:   _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i == _messages.length) {
                  // Indicateur "en train de taper..."
                  return _TypingIndicator(scheme: scheme);
                }
                return _MessageBubble(
                  message: _messages[i],
                  scheme:  scheme,
                );
              },
            ),
          ),

          // ── Zone de saisie ────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              left:   12,
              right:  12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              top:    8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:    _inputController,
                    decoration: InputDecoration(
                      hintText:    'Posez une question...',
                      hintStyle:   AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurfaceVariant),
                      filled:      true,
                      fillColor:   scheme.surfaceVariant,
                      border:      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:   BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted:     (_) => _sendMessage(),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _sendMessage,
                  style: FilledButton.styleFrom(
                    shape:   const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.send, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS INTERNES
// ─────────────────────────────────────────────────────────────

class _Message {
  const _Message({required this.text, required this.isUser});
  final String text;
  final bool   isUser;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.scheme});
  final _Message    message;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:  const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? scheme.primary : scheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft:     const Radius.circular(14),
            topRight:    const Radius.circular(14),
            bottomLeft:  Radius.circular(isUser ? 14 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 14),
          ),
        ),
        child: Text(
          message.text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isUser ? scheme.onPrimary : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:  const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color:        scheme.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => _Dot(index: i, scheme: scheme)),
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.index, required this.scheme});
  final int index;
  final ColorScheme scheme;
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    // Décalage pour l'effet vague
    _anim = Tween(begin: 0.0, end: -4.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve:  Interval(widget.index * 0.2, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder:   (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width:  6, height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color:  widget.scheme.onSurfaceVariant.withOpacity(0.6),
            shape:  BoxShape.circle,
          ),
        ),
      ),
    );
  }
}