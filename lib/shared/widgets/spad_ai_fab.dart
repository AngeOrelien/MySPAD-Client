// lib/shared/widgets/spad_ai_fab.dart
//
// ─── CHATBOT IA SPAD — FAB RÉUTILISABLE ─────────────────────
// Utilisé dans :
//   • HomeScreen    → Stack Positioned bottom:80, right:16
//   • OffresScreen  → idem
//   • AvsShell appBar → IconButton dans actions
//   • FamilleShell  → idem
//   • AdminShell    → idem
//
// Sur les pages visiteur : FAB flottant (bas droit)
// Sur les dashboards    : bouton dans l'AppBar
// ─────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';

class SpadAIFab extends StatelessWidget {
  const SpadAIFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag:   'spad-ai-fab',
      tooltip:   'Assistant SPAD IA',
      onPressed: () => SpadAISheet.show(context),
      child:     const Icon(Icons.smart_toy_outlined, size: 24),
    );
  }
}

/// Bouton compact pour l'AppBar des dashboards
class SpadAIAppBarButton extends StatelessWidget {
  const SpadAIAppBarButton({super.key});
  @override
  Widget build(BuildContext ctx) => IconButton(
    icon:      const Icon(Icons.smart_toy_outlined),
    tooltip:   'Assistant IA SPAD',
    onPressed: () => SpadAISheet.show(ctx),
  );
}

// ─────────────────────────────────────────────────────────────
// BOTTOM SHEET — Interface de chat IA
// ─────────────────────────────────────────────────────────────
class SpadAISheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context:              context,
      isScrollControlled:   true,
      useSafeArea:          true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand:         false,
        initialChildSize: 0.75,
        minChildSize:   0.4,
        maxChildSize:   0.95,
        builder:        (_, ctrl) => _ChatSheet(scrollController: ctrl),
      ),
    );
  }
}

class _ChatSheet extends StatefulWidget {
  const _ChatSheet({required this.scrollController});
  final ScrollController scrollController;
  @override
  State<_ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends State<_ChatSheet> {
  final _inputCtrl  = TextEditingController();
  final _listCtrl   = ScrollController();
  final List<_Msg>  _msgs = [
    _Msg('Bonjour ! Je suis l\'assistant IA de SPAD Cameroun.\nComment puis-je vous aider ?', false),
  ];
  bool _typing = false;

  static const _replies = {
    'rapport':      'Pour rédiger un rapport, allez dans l\'onglet "Rapports" et appuyez sur "Nouveau rapport". Remplissez les paramètres vitaux, médicaments, repas et activités.',
    'médicament':   'Les médicaments sont administrés selon la prescription du médecin. Notez la posologie matin/midi/soir dans le rapport de la journée.',
    'tension':      'La tension artérielle normale est entre 120/80 et 130/85 mmHg. Signalez toute valeur anormale à l\'équipe médicale.',
    'patient':      'Les informations de votre patient se trouvent dans l\'onglet "Mon patient". Vous y verrez son historique de santé.',
    'urgence':      'En cas d\'urgence, appuyez sur le bouton d\'alerte rouge dans l\'AppBar. L\'équipe SPAD sera notifiée immédiatement.',
    'rapport avs':  'Un rapport AVS comprend : paramètres vitaux, médicaments, repas, soins, activités, divers clinique et conclusion.',
    'spad':         'SPAD (Suivi des Personnes Agées à Domicile) est une association camerounaise basée à Yaoundé et Douala. Contact : 680 42 25 51.',
  };

  @override
  void dispose() { _inputCtrl.dispose(); _listCtrl.dispose(); super.dispose(); }

  void _send() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() { _msgs.add(_Msg(text, true)); _typing = true; });
    _inputCtrl.clear();
    _scrollDown();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _msgs.add(_Msg(_getReply(text), false));
      });
      _scrollDown();
    });
  }

  String _getReply(String q) {
    final lower = q.toLowerCase();
    for (final e in _replies.entries) {
      if (lower.contains(e.key)) return e.value;
    }
    return 'Je comprends votre question. Pour une assistance personnalisée, contactez l\'équipe SPAD au +237 680 42 25 51 ou par email à spadcameroun@yahoo.fr';
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_listCtrl.hasClients) {
        _listCtrl.animateTo(_listCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(children: [
      // ── Header ─────────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: scheme.outline.withOpacity(0.2)))),
        child: Column(children: [
          Container(width: 36, height: 4,
            decoration: BoxDecoration(
              color: scheme.outline.withOpacity(0.4), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.smart_toy_outlined, color: scheme.primary, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Assistant IA SPAD',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: scheme.onSurface)),
              Row(children: [
                Container(width: 7, height: 7,
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text('En ligne', style: TextStyle(fontSize: 12, color: Colors.green.shade600)),
              ]),
            ])),
          ]),
        ]),
      ),

      // ── Messages ───────────────────────────────────────
      Expanded(child: ListView.builder(
        controller: _listCtrl,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        itemCount: _msgs.length + (_typing ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == _msgs.length) return _TypingBubble(scheme: scheme);
          return _BubbleTile(msg: _msgs[i], scheme: scheme);
        },
      )),

      // ── Input ──────────────────────────────────────────
      Container(
        padding: EdgeInsets.only(
          left: 12, right: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 12, top: 8),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: scheme.outline.withOpacity(0.15)))),
        child: Row(children: [
          Expanded(child: TextField(
            controller: _inputCtrl,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _send(),
            decoration: InputDecoration(
              hintText: 'Posez une question…',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              filled: true, fillColor: scheme.surfaceVariant,
            ),
          )),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _send,
            style: FilledButton.styleFrom(
              shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
            child: const Icon(Icons.send_rounded, size: 18),
          ),
        ]),
      ),
    ]);
  }
}

class _Msg { const _Msg(this.text, this.isUser); final String text; final bool isUser; }

class _BubbleTile extends StatelessWidget {
  const _BubbleTile({required this.msg, required this.scheme});
  final _Msg msg; final ColorScheme scheme;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: msg.isUser ? scheme.primary : scheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft:     const Radius.circular(16),
            topRight:    const Radius.circular(16),
            bottomLeft:  Radius.circular(msg.isUser ? 16 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 16),
          ),
        ),
        child: Text(msg.text,
          style: TextStyle(
            fontSize: 14,
            color: msg.isUser ? scheme.onPrimary : scheme.onSurface,
            height: 1.4)),
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble({required this.scheme});
  final ColorScheme scheme;
  @override State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext ctx) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.scheme.surfaceVariant, borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
        AnimatedBuilder(animation: _c, builder: (_, __) => Container(
          width: 7, height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: widget.scheme.onSurfaceVariant.withOpacity(0.3 + 0.5 * ((i == 1 ? _c.value : i == 0 ? (_c.value * 0.8) : (_c.value * 0.6)))),
            shape: BoxShape.circle),
        )),
      )),
    ),
  );
}
