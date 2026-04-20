// lib/features/dashboard/avs/tabs/avs_rapport_tab.dart
// Formulaire de rapport AVS — basé sur la fiche officielle SPAD
import 'package:flutter/material.dart';

class AvsRapportsTab extends StatelessWidget {
  const AvsRapportsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      body: Column(children: [
        // ── Header avec bouton nouveau rapport ────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: scheme.surface,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Rapports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              Text('Historique de vos rapports', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            ]),
            FilledButton.icon(
              onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RapportFormScreen())),
              icon:  const Icon(Icons.add, size: 18),
              label: const Text('Nouveau'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10))),
          ]),
        ),
        const Divider(height: 1),

        // ── Liste des rapports ─────────────────────────────────
        Expanded(child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _rapports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) => _RapportCard(data: _rapports[i]),
        )),
      ]),
    );
  }
}

class _RapportData { const _RapportData(this.date, this.patient, this.conclusion, this.status, this.avs); final String date, patient, conclusion, status, avs; }
const _rapports = [
  _RapportData('07/04/2026', 'Mme Paulette Biya', 'La journée s\'est bien passée, la maman se porte bien.', 'Validé', 'NTSAMA Simone'),
  _RapportData('06/04/2026', 'Mme Paulette Biya', 'Paramètres vitaux stables. Séance de kiné effectuée.', 'Validé', 'NTSAMA Simone'),
  _RapportData('05/04/2026', 'Mme Paulette Biya', 'Patient légèrement fatigué. Repos recommandé.', 'En attente', 'NTSAMA Simone'),
];

class _RapportCard extends StatelessWidget {
  const _RapportCard({required this.data});
  final _RapportData data;
  @override
  Widget build(BuildContext ctx) {
    final scheme    = Theme.of(ctx).colorScheme;
    final isValid   = data.status == 'Validé';
    final statusCol = isValid ? const Color(0xFF0C8C6B) : const Color(0xFFF5A623);
    return Card(child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 40, height: 40,
            decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.description_rounded, color: scheme.primary, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Rapport du ${data.date}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text(data.patient, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: statusCol.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
            child: Text(data.status, style: TextStyle(fontSize: 11, color: statusCol, fontWeight: FontWeight.w600))),
        ]),
        const SizedBox(height: 10),
        Text(data.conclusion, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Row(children: [
          Icon(Icons.person_outline, size: 14, color: scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text('AVS : ${data.avs}', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('Voir détails', style: TextStyle(fontSize: 12))),
        ]),
      ]),
    ));
  }
}

// ═══════════════════════════════════════════════════════════
// FORMULAIRE DE RAPPORT COMPLET
// ═══════════════════════════════════════════════════════════
class RapportFormScreen extends StatefulWidget {
  const RapportFormScreen({super.key});
  @override State<RapportFormScreen> createState() => _RapportFormState();
}

class _RapportFormState extends State<RapportFormScreen> {
  final _form  = GlobalKey<FormState>();
  int   _step  = 0;

  // ── Données du formulaire ─────────────────────────────────
  // 1. Paramètres vitaux
  final _taDroitSys  = TextEditingController(text: '128');
  final _taDroitDia  = TextEditingController(text: '70');
  final _taGaucheSys = TextEditingController(text: '130');
  final _taGaucheDia = TextEditingController(text: '69');
  final _pouls       = TextEditingController(text: '60');
  final _temp        = TextEditingController(text: '36.8');
  final _glycemie    = TextEditingController(text: '1.05');
  final _spo2        = TextEditingController(text: '97');

  // 2. Médicaments
  final List<_Medicament> _medicaments = [
    _Medicament('Trofocard 243mg', '1', '0', '0'),
    _Medicament('Tanakan', '1', '0', '1'),
    _Medicament('Tahor 10mg', '0', '0', '1'),
  ];

  // 3. Repas
  final _petitDej   = TextEditingController(text: 'Salade de choux, tomate, concombre + papaye');
  final _dejeuner   = TextEditingController(text: 'Poulet sauce moutarde + riz au curry');
  final _diner      = TextEditingController(text: 'Poulet sauce moutarde + riz au curry + papaye');
  final _hydratation= TextEditingController(text: '1.7L');

  // 4. Soins
  final Map<String, bool> _soins = {
    'Hygiène corporelle': true,
    'Hygiène buccale': true,
    'Hygiène environnementale': true,
    'Réfection du lit': true,
    'Fermeture fenêtres': false,
  };

  // 5. Activités
  final List<String> _activites = [
    'Étirements au lever',
    'Marche à l\'intérieur',
    'Petits massages',
    'Séance de kiné',
  ];
  final _nouvelleActivite = TextEditingController();

  // 6. Divers + Conclusion
  final _divers      = TextEditingController(text: 'Pas de constipation ce jour.');
  final _visites     = TextEditingController(text: 'Aucune visite');
  final _conclusion  = TextEditingController(text: 'La journée s\'est bien passée, la maman se porte bien ce soir.');

  static const _stepTitles = [
    'Paramètres vitaux',
    'Médicaments',
    'Repas & Hydratation',
    'Soins effectués',
    'Activités menées',
    'Conclusion',
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        title: const Text('Nouveau rapport', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Soumettre', style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
      body: Column(children: [
        // ── Stepper horizontal ──────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: scheme.surface,
          child: SingleChildScrollView(scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: List.generate(_stepTitles.length, (i) {
              final active = i == _step;
              final done   = i < _step;
              return GestureDetector(
                onTap: () => setState(() => _step = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? scheme.primary : done ? scheme.primaryContainer : scheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(999)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (done) Icon(Icons.check, size: 14, color: scheme.primary)
                    else Text('${i+1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                      color: active ? scheme.onPrimary : scheme.onSurfaceVariant)),
                    if (active || done) ...[
                      const SizedBox(width: 6),
                      Text(_stepTitles[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: active ? scheme.onPrimary : scheme.primary)),
                    ],
                  ])),
              );
            })),
          ),
        ),
        const Divider(height: 1),

        // ── Contenu du step ─────────────────────────────────
        Expanded(child: Form(key: _form, child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _buildStep(_step, scheme),
        ))),

        // ── Boutons de navigation ────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(color: scheme.surface,
            border: Border(top: BorderSide(color: scheme.outline.withOpacity(0.2)))),
          child: Row(children: [
            if (_step > 0) Expanded(child: OutlinedButton.icon(
              onPressed: () => setState(() => _step--),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Précédent'))),
            if (_step > 0) const SizedBox(width: 12),
            Expanded(child: FilledButton.icon(
              onPressed: () {
                if (_step < _stepTitles.length - 1) setState(() => _step++);
                else _submit();
              },
              icon: Icon(_step < _stepTitles.length - 1 ? Icons.arrow_forward_rounded : Icons.send_rounded, size: 16),
              label: Text(_step < _stepTitles.length - 1 ? 'Suivant' : 'Soumettre'))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildStep(int step, ColorScheme scheme) {
    switch (step) {
      case 0: return _buildVitaux(scheme);
      case 1: return _buildMedicaments(scheme);
      case 2: return _buildRepas(scheme);
      case 3: return _buildSoins(scheme);
      case 4: return _buildActivites(scheme);
      case 5: return _buildConclusion(scheme);
      default: return const SizedBox();
    }
  }

  // ── STEP 1 — Paramètres vitaux ────────────────────────────
  Widget _buildVitaux(ColorScheme scheme) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _SectionTitle('Tension artérielle — Bras droit'),
    Row(children: [
      Expanded(child: _TaField('Systolique', _taDroitSys, 'mmHg')),
      const SizedBox(width: 10),
      Expanded(child: _TaField('Diastolique', _taDroitDia, 'mmHg')),
    ]),
    const SizedBox(height: 16),
    _SectionTitle('Tension artérielle — Bras gauche'),
    Row(children: [
      Expanded(child: _TaField('Systolique', _taGaucheSys, 'mmHg')),
      const SizedBox(width: 10),
      Expanded(child: _TaField('Diastolique', _taGaucheDia, 'mmHg')),
    ]),
    const SizedBox(height: 16),
    Row(children: [
      Expanded(child: _TaField('Pouls', _pouls, 'pls/min')),
      const SizedBox(width: 10),
      Expanded(child: _TaField('Température', _temp, '°C')),
    ]),
    const SizedBox(height: 10),
    Row(children: [
      Expanded(child: _TaField('Glycémie', _glycemie, 'g/L')),
      const SizedBox(width: 10),
      Expanded(child: _TaField('SpO2', _spo2, '%')),
    ]),
    const SizedBox(height: 16),
    // Récap visuel
    _SectionTitle('Récapitulatif'),
    GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.2,
      children: [
        _VitalDisplay('TA D.', '${_taDroitSys.text}/${_taDroitDia.text}', const Color(0xFF00C7CC)),
        _VitalDisplay('TA G.', '${_taGaucheSys.text}/${_taGaucheDia.text}', const Color(0xFF00C7CC)),
        _VitalDisplay('Pouls', '${_pouls.text} pls/min', const Color(0xFF0C8C6B)),
        _VitalDisplay('Temp.', '${_temp.text}°C', const Color(0xFFF5A623)),
      ],
    ),
  ]);

  // ── STEP 2 — Médicaments ──────────────────────────────────
  Widget _buildMedicaments(ColorScheme scheme) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _SectionTitle('Liste des médicaments'),
      TextButton.icon(
        onPressed: () => setState(() => _medicaments.add(_Medicament('', '', '', ''))),
        icon: const Icon(Icons.add, size: 16), label: const Text('Ajouter')),
    ]),
    const SizedBox(height: 8),
    // En-tête tableau
    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        const Expanded(flex: 3, child: Text('Médicament', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        _Th('M'), _Th('A'), _Th('S'),
        const SizedBox(width: 32),
      ])),
    const SizedBox(height: 4),
    ...List.generate(_medicaments.length, (i) => _MedRow(
      med: _medicaments[i],
      scheme: scheme,
      onDelete: () => setState(() => _medicaments.removeAt(i)),
    )),
    const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: scheme.primaryContainer.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(Icons.check_circle_outline, color: scheme.primary, size: 18),
        const SizedBox(width: 8),
        const Expanded(child: Text('Le tout administré selon la prescription', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
      ])),
  ]);

  // ── STEP 3 — Repas ────────────────────────────────────────
  Widget _buildRepas(ColorScheme scheme) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _SectionTitle('Petit déjeuner'),
    _TextArea(_petitDej, 'Détail du petit déjeuner'),
    const SizedBox(height: 12),
    _SectionTitle('Déjeuner'),
    _TextArea(_dejeuner, 'Détail du déjeuner'),
    const SizedBox(height: 12),
    _SectionTitle('Dîner'),
    _TextArea(_diner, 'Détail du dîner'),
    const SizedBox(height: 12),
    _SectionTitle('Hydratation'),
    TextFormField(controller: _hydratation,
      decoration: const InputDecoration(labelText: 'Quantité d\'eau (ex: 1.7L)', prefixIcon: Icon(Icons.water_drop_outlined))),
  ]);

  // ── STEP 4 — Soins ────────────────────────────────────────
  Widget _buildSoins(ColorScheme scheme) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _SectionTitle('Soins effectués ce jour'),
    const SizedBox(height: 8),
    ..._soins.keys.map((soin) => CheckboxListTile(
      value:    _soins[soin],
      onChanged: (v) => setState(() => _soins[soin] = v ?? false),
      title:     Text(soin, style: const TextStyle(fontSize: 14)),
      activeColor: scheme.primary,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    )),
    ListTile(
      leading:  Icon(Icons.add_circle_outline, color: scheme.primary),
      title:    Text('Ajouter un soin', style: TextStyle(color: scheme.primary, fontSize: 14)),
      onTap: () => _addSoin(context),
      contentPadding: EdgeInsets.zero),
  ]);

  // ── STEP 5 — Activités ────────────────────────────────────
  Widget _buildActivites(ColorScheme scheme) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _SectionTitle('Activités menées'),
    const SizedBox(height: 8),
    ..._activites.asMap().entries.map((e) => ListTile(
      leading: CircleAvatar(radius: 14, backgroundColor: scheme.primaryContainer,
        child: Text('${e.key + 1}', style: TextStyle(color: scheme.primary, fontSize: 11, fontWeight: FontWeight.w700))),
      title: Text(e.value, style: const TextStyle(fontSize: 14)),
      trailing: IconButton(icon: const Icon(Icons.delete_outline, size: 18), color: Colors.red,
        onPressed: () => setState(() => _activites.removeAt(e.key))),
      contentPadding: EdgeInsets.zero,
    )),
    const SizedBox(height: 10),
    Row(children: [
      Expanded(child: TextFormField(controller: _nouvelleActivite,
        decoration: const InputDecoration(labelText: 'Ajouter une activité', prefixIcon: Icon(Icons.add)))),
      const SizedBox(width: 8),
      FilledButton(
        onPressed: () {
          if (_nouvelleActivite.text.isNotEmpty) {
            setState(() { _activites.add(_nouvelleActivite.text); _nouvelleActivite.clear(); });
          }
        },
        style: FilledButton.styleFrom(padding: const EdgeInsets.all(14)),
        child: const Icon(Icons.add)),
    ]),
  ]);

  // ── STEP 6 — Conclusion ───────────────────────────────────
  Widget _buildConclusion(ColorScheme scheme) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _SectionTitle('Divers clinique'),
    _TextArea(_divers, 'Observations cliniques particulières'),
    const SizedBox(height: 12),
    _SectionTitle('Visites du jour'),
    _TextArea(_visites, 'Personnes reçues au domicile'),
    const SizedBox(height: 12),
    _SectionTitle('Conclusion'),
    _TextArea(_conclusion, 'Résumé de la journée', minLines: 3),
    const SizedBox(height: 16),
    Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
      color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(Icons.info_outline, color: scheme.primary, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text('Le rapport sera signé avec votre nom et envoyé à la famille et au coordinateur.',
          style: TextStyle(fontSize: 12, color: scheme.primary))),
      ])),
  ]);

  void _addSoin(BuildContext ctx) {
    final ctrl = TextEditingController();
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: const Text('Ajouter un soin'),
      content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Nom du soin')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
        FilledButton(onPressed: () { if (ctrl.text.isNotEmpty) setState(() => _soins[ctrl.text] = true); Navigator.pop(ctx); },
          child: const Text('Ajouter')),
      ],
    ));
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Rapport soumis avec succès !'), behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xFF0C8C6B)));
    Navigator.pop(context);
  }
}

// ── WIDEGETS _TaField ────────────────────────────────────────
class _TaField extends StatelessWidget {
  const _TaField(this.label, this.controller, this.suffix);
  final String label;
  final TextEditingController controller;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
    );
  }
}


// ── WIDGETS INTERNES DU FORMULAIRE ───────────────────────────

class _Medicament { _Medicament(this.nom, this.matin, this.midi, this.soir); String nom, matin, midi, soir; }

class _MedRow extends StatelessWidget {
  const _MedRow({required this.med, required this.scheme, required this.onDelete});
  final _Medicament med; final ColorScheme scheme; final VoidCallback onDelete;
  @override
  Widget build(BuildContext ctx) => Padding(padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Expanded(flex: 3, child: TextFormField(initialValue: med.nom,
        onChanged: (v) => med.nom = v,
        style: const TextStyle(fontSize: 12),
        decoration: const InputDecoration(hintText: 'Nom du médicament', contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)))),
      const SizedBox(width: 6),
      _PosField(med.matin, (v) => med.matin = v),
      const SizedBox(width: 4),
      _PosField(med.midi,  (v) => med.midi  = v),
      const SizedBox(width: 4),
      _PosField(med.soir,  (v) => med.soir  = v),
      IconButton(icon: const Icon(Icons.delete_outline, size: 16), color: Colors.red, onPressed: onDelete, padding: const EdgeInsets.all(6)),
    ]));
}

class _PosField extends StatelessWidget {
  const _PosField(this.val, this.onChange);
  final String val; final ValueChanged<String> onChange;
  @override
  Widget build(BuildContext ctx) => SizedBox(width: 44, child: TextFormField(
    initialValue: val, onChanged: onChange, textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 12),
    decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 10))));
}

class _Th extends StatelessWidget {
  const _Th(this.t);
  final String t;
  @override
  Widget build(BuildContext ctx) => SizedBox(width: 44, child: Text(t, textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)));
}

Widget _SectionTitle(String t) => Padding(padding: const EdgeInsets.only(bottom: 8),
  child: Row(children: [
    Container(width: 3, height: 16, margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(color: const Color(0xFF00C7CC), borderRadius: BorderRadius.circular(2))),
    Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
  ]));

Widget _TextArea(TextEditingController ctrl, String hint, {int minLines = 2}) =>
  TextFormField(controller: ctrl, minLines: minLines, maxLines: 6,
    decoration: InputDecoration(hintText: hint));

class _VitalDisplay extends StatelessWidget {
  const _VitalDisplay(this.label, this.value, this.color);
  final String label, value; final Color color;
  @override
  Widget build(BuildContext ctx) {
    final s = Theme.of(ctx).colorScheme;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: s.surface, borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Row(children: [
        Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 10, color: s.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: s.onSurface)),
        ])),
      ]));
  }
}
