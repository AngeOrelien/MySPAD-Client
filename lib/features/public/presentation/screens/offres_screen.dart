// lib/features/public/screens/offres_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import '../../../core/router/route_names.dart';
import '../../../../core/router/route_names.dart';

class OffresScreen extends StatelessWidget {
  const OffresScreen({super.key});

  static const _offres = [
    _Offre('Auxiliaire de Vie Sociale (AVS)', 'Yaoundé, Bastos', 'Temps plein',
      'Accompagnement quotidien d\'une personne âgée : hygiène, repas, sorties, suivi médical.', '31 juil. 2025'),
    _Offre('Aide à domicile — Soins spécialisés', 'Douala, Akwa', 'Mi-temps',
      'Prise en charge d\'un patient avec pathologie chronique. Suivi médicamenteux.', '15 août 2025'),
    _Offre('Coordinateur Santé', 'Yaoundé, Centre', 'Temps plein',
      'Coordination des équipes AVS et gestion des plannings.', '30 juil. 2025'),
  ];

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offres d\'emploi'), actions: [
        TextButton.icon(
          onPressed: () => ctx.go(RouteNames.login),
          icon: const Icon(Icons.login, size: 16),
          label: const Text('Connexion')),
      ]),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _offres.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (ctx, i) {
          if (i == 0) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Rejoignez l\'équipe SPAD',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Participez à notre mission à Yaoundé & Douala.',
              style: TextStyle(fontSize: 14, color: Theme.of(ctx).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
          ]);
          return _OffreCard(offre: _offres[i - 1]);
        },
      ),
    );
  }
}

class _Offre {
  const _Offre(this.titre, this.lieu, this.type, this.desc, this.limite);
  final String titre, lieu, type, desc, limite;
}

class _OffreCard extends StatefulWidget {
  const _OffreCard({required this.offre});
  final _Offre offre;
  @override
  State<_OffreCard> createState() => _OffreCardState();
}

class _OffreCardState extends State<_OffreCard> {
  bool _open = false;
  @override
  Widget build(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    final o = widget.offre;
    return Card(elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outline.withOpacity(0.2))),
      child: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFD1FBFB), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.work, color: Color(0xFF007E81), size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(o.titre, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 12, color: scheme.onSurfaceVariant),
                const SizedBox(width: 3),
                Text(o.lieu, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFD0F0E4), borderRadius: BorderRadius.circular(999)),
                  child: Text(o.type, style: const TextStyle(fontSize: 10, color: Color(0xFF032820), fontWeight: FontWeight.w600))),
              ]),
            ])),
          ]),
          if (_open) ...[
            const SizedBox(height: 12),
            Text(o.desc, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => ctx.go(RouteNames.register),
              icon: const Icon(Icons.send, size: 14),
              label: const Text('Postuler'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF00C7CC), foregroundColor: Colors.white)),
          ],
          TextButton(
            onPressed: () => setState(() => _open = !_open),
            child: Text(_open ? 'Voir moins' : 'Voir plus')),
        ],
      )),
    );
  }
}
