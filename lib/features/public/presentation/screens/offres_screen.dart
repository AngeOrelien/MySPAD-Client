// lib/features/public/screens/offres_screen.dart
// Page des offres et forfaits SPAD — mobile-first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/spad_ai_fab.dart';

class OffresScreen extends StatelessWidget {
  const OffresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      body: CustomScrollView(slivers: [
        // ── Sliver AppBar avec image ──────────────────────
        SliverAppBar(
          expandedHeight: 200,
          pinned:         true,
          backgroundColor: const Color(0xFF004345),
          foregroundColor: Colors.white,
          title: const Text('Services & Forfaits', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              Image.asset('assets/images/offres_header.jpg', fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF004345), Color(0xFF00C7CC)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight)))),
              Container(color: Colors.black.withOpacity(0.4)),
              const Positioned(bottom: 60, left: 20, right: 20,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Nos prestations', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  Text('Choisissez le forfait adapté à votre proche',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                ])),
            ]),
          ),
        ),

        // ── Contenu ──────────────────────────────────────
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Forfaits ──────────────────────────────────
            Text('Nos forfaits', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: scheme.onSurface)),
            const SizedBox(height: 12),
            ..._forfaits.map((f) => _ForfaitCard(forfait: f)).toList(),

            const SizedBox(height: 20),

            // ── Types de suivi ────────────────────────────
            Text('Types de suivi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: scheme.onSurface)),
            const SizedBox(height: 12),
            ..._typessuivi.map((t) => _SuiviCard(data: t)).toList(),

            const SizedBox(height: 20),

            // ── CTA Souscrire ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C7CC), Color(0xFF0C8C6B)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                const Icon(Icons.family_restroom, color: Colors.white, size: 40),
                const SizedBox(height: 10),
                const Text('Intéressé par nos services ?',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Soumettez une demande et notre équipe vous contacte sous 24h.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => context.go(RouteNames.register),
                  icon:  const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Souscrire maintenant'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF004345),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12))),
              ]),
            ),

            const SizedBox(height: 80),
          ]),
        )),
      ]),
      floatingActionButton: const SpadAIFab(),
    );
  }
}

// ── DONNÉES ──────────────────────────────────────────────────

class _Forfait {
  const _Forfait(this.nom, this.prix, this.duree, this.description, this.items, this.color, this.isPremium);
  final String nom, prix, duree, description; final List<String> items; final Color color; final bool isPremium;
}

const _forfaits = [
  _Forfait(
    'Forfait Essentiel', 'Sur devis', 'Journalier',
    'Présence quotidienne pour les soins de base',
    ['Hygiène corporelle', 'Administration des médicaments', 'Préparation des repas', 'Rapport quotidien'],
    Color(0xFF00C7CC), false,
  ),
  _Forfait(
    'Forfait Intégral', 'Sur devis', 'Journalier + garde',
    'Suivi complet avec présence permanente',
    ['Tout l\'Essentiel', 'Paramètres vitaux', 'Séances de kinésithérapie', 'Suivi glycémie & SpO2', 'Rapport détaillé', 'Alertes famille'],
    Color(0xFF0C8C6B), true,
  ),
  _Forfait(
    'Forfait Médical', 'Sur devis', 'Sur prescription',
    'Pour patients avec pathologie complexe',
    ['Tout l\'Intégral', 'Injections (Insuline, etc.)', 'Coordination médecin', 'Dossier patient numérique', 'Urgences 24h/24'],
    Color(0xFFF5A623), true,
  ),
];

class _ForfaitCard extends StatefulWidget {
  const _ForfaitCard({required this.forfait});
  final _Forfait forfait;
  @override State<_ForfaitCard> createState() => _ForfaitCardState();
}
class _ForfaitCardState extends State<_ForfaitCard> {
  bool _open = false;
  @override
  Widget build(BuildContext ctx) {
    final f = widget.forfait; final scheme = Theme.of(ctx).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:        scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: f.isPremium ? f.color.withOpacity(0.4) : scheme.outline.withOpacity(0.2), width: f.isPremium ? 1.5 : 1)),
      child: Column(children: [
        // Header
        InkWell(onTap: () => setState(() => _open = !_open), borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Container(width: 48, height: 48,
              decoration: BoxDecoration(color: f.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.medical_services_outlined, color: f.color, size: 24)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(f.nom, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
                if (f.isPremium) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: f.color.withOpacity(0.15), borderRadius: BorderRadius.circular(999)),
                  child: Text('Premium', style: TextStyle(fontSize: 10, color: f.color, fontWeight: FontWeight.w600))),
              ]),
              Text(f.description, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            ])),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: scheme.onSurfaceVariant),
          ]))),
        // Détails
        if (_open) ...[
          Divider(height: 1, color: scheme.outline.withOpacity(0.15)),
          Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...f.items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Icon(Icons.check_circle_rounded, color: f.color, size: 16),
                const SizedBox(width: 8),
                Text(item, style: const TextStyle(fontSize: 13)),
              ]))),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () => ctx.go(RouteNames.register),
              style: FilledButton.styleFrom(backgroundColor: f.color, foregroundColor: Colors.white),
              child: const Text('Demander ce forfait'))),
          ])),
        ],
      ]),
    );
  }
}

class _SuiviData { const _SuiviData(this.icon, this.titre, this.desc, this.color); final IconData icon; final String titre, desc; final Color color; }

const _typessuivi = [
  _SuiviData(Icons.home_outlined,         'Suivi à domicile',    'AVS présent au domicile du patient selon le planning défini.',  Color(0xFF00C7CC)),
  _SuiviData(Icons.local_hospital_outlined,'Suivi hospitalier',  'Accompagnement pendant les hospitalisations et consultations.', Color(0xFF0C8C6B)),
  _SuiviData(Icons.self_improvement,      'Kinésithérapie',      'Séances de rééducation motrice et exercices de mobilité.',      Color(0xFFF5A623)),
  _SuiviData(Icons.school_outlined,       'Formation personnel', 'Formation des aides familiales à domicile.',                   Color(0xFF007E81)),
];

class _SuiviCard extends StatelessWidget {
  const _SuiviCard({required this.data});
  final _SuiviData data;
  @override
  Widget build(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outline.withOpacity(0.15))),
      child: Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: data.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(data.icon, color: data.color, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data.titre, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Text(data.desc, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
        ])),
        Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
      ]),
    );
  }
}
