// lib/features/dashboard/avs/tabs/avs_patient_tab.dart
import 'package:flutter/material.dart';

class AvsPatientTab extends StatelessWidget {
  const AvsPatientTab({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Card patient ──────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF004345), Color(0xFF006A6C)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            Row(children: [
              CircleAvatar(radius: 32, backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person, color: Colors.white, size: 32)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Mme Paulette Biya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                Text('78 ans — F', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                const SizedBox(height: 4),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(999)),
                  child: const Text('Suivi actif', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
              ])),
            ]),
            const SizedBox(height: 14),
            Row(children: [
              _InfoPill(Icons.location_on_outlined, 'Bastos, Yaoundé'),
              const SizedBox(width: 8),
              _InfoPill(Icons.calendar_today_outlined, 'Depuis janv. 2025'),
            ]),
          ]),
        ),
        const SizedBox(height: 16),

        // ── Informations médicales ────────────────────────────
        _Section('Informations médicales'),
        _InfoCard(scheme, [
          _Info('Groupe sanguin', 'A+'),
          _Info('Allergie',       'Pénicilline'),
          _Info('Médecin',       'Dr. Kamga — 699 001 122'),
          _Info('Diagnostic',   'HTA, Diabète type 2, Arthrose'),
        ]),
        const SizedBox(height: 16),

        // ── Médicaments en cours ──────────────────────────────
        _Section('Médicaments en cours'),
        Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          _MedLine('Trofocard 243mg',  '1-0-0'),
          _MedLine('Solifenacine 5mg', '1-0-1'),
          _MedLine('Tanakan',          '1-0-1'),
          _MedLine('Tahor 10mg',       '0-0-1'),
          _MedLine('Diamox 250mg',     '½-0-0'),
          _MedLine('Nugrel',           '1-0-0 (réserve entamée)'),
        ]))),
        const SizedBox(height: 16),

        // ── Historique des constantes ─────────────────────────
        _Section('Derniers paramètres vitaux'),
        Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          _VitalRow2('07/04', '128/70', '130/69', '60', '36.8', '97', '1.05'),
          _VitalRow2('06/04', '125/75', '127/72', '62', '36.6', '98', '1.10'),
          _VitalRow2('05/04', '132/78', '129/73', '58', '37.1', '96', '1.21'),
        ]))),
      ]),
    );
  }
}

Widget _Section(String t) => Padding(padding: const EdgeInsets.only(bottom: 10),
  child: Text(t, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)));

Widget _InfoCard(ColorScheme s, List<_Info> infos) => Card(child: Padding(padding: const EdgeInsets.all(14),
  child: Column(children: infos.map((i) => Padding(padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      SizedBox(width: 120, child: Text(i.label, style: TextStyle(fontSize: 13, color: s.onSurfaceVariant))),
      Expanded(child: Text(i.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
    ]))).toList())));

class _Info { const _Info(this.label, this.value); final String label, value; }

class _InfoPill extends StatelessWidget {
  const _InfoPill(this.icon, this.text);
  final IconData icon; final String text;
  @override
  Widget build(BuildContext ctx) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(999)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: Colors.white),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
    ]));
}

Widget _MedLine(String nom, String posologie) => Padding(padding: const EdgeInsets.only(bottom: 8),
  child: Row(children: [
    Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 10),
      decoration: const BoxDecoration(color: Color(0xFF00C7CC), shape: BoxShape.circle)),
    Expanded(child: Text(nom, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFFD1FBFB), borderRadius: BorderRadius.circular(6)),
      child: Text(posologie, style: const TextStyle(fontSize: 11, color: Color(0xFF004345), fontFamily: 'monospace'))),
  ]));

class _VitalRow2 extends StatelessWidget {
  const _VitalRow2(this.date, this.tad, this.tag, this.p, this.t, this.spo2, this.gly);
  final String date, tad, tag, p, t, spo2, gly;
  @override
  Widget build(BuildContext ctx) {
    final s = Theme.of(ctx).colorScheme;
    return Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: s.surfaceVariant, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(color: s.primaryContainer, borderRadius: BorderRadius.circular(4)),
          child: Text(date, style: TextStyle(fontSize: 11, color: s.primary, fontWeight: FontWeight.w600))),
        const SizedBox(width: 8),
        Expanded(child: Wrap(spacing: 8, children: [
          _VM('TA D', tad), _VM('TA G', tag), _VM('P', p), _VM('T', t), _VM('SpO2', spo2), _VM('Gly', gly),
        ])),
      ]));
  }
}

class _VM extends StatelessWidget {
  const _VM(this.l, this.v);
  final String l, v;
  @override
  Widget build(BuildContext ctx) => Text('$l:$v', style: const TextStyle(fontSize: 11));
}
