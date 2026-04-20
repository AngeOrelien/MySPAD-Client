// lib/features/dashboard/avs/tabs/avs_localisation_tab.dart
import 'package:flutter/material.dart';

class AvsLocalisationTab extends StatefulWidget {
  const AvsLocalisationTab({super.key});
  @override State<AvsLocalisationTab> createState() => _AvsLocalisationTabState();
}

class _AvsLocalisationTabState extends State<AvsLocalisationTab> {
  bool _tracking = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Statut tracking ────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _tracking ? const Color(0xFF00C7CC).withOpacity(0.1) : scheme.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _tracking ? const Color(0xFF00C7CC).withOpacity(0.4) : scheme.outline.withOpacity(0.2))),
          child: Row(children: [
            Container(width: 48, height: 48,
              decoration: BoxDecoration(
                color: _tracking ? const Color(0xFF00C7CC).withOpacity(0.15) : scheme.surfaceVariant,
                shape: BoxShape.circle),
              child: Icon(Icons.location_on_rounded, size: 28,
                color: _tracking ? const Color(0xFF00C7CC) : scheme.onSurfaceVariant)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_tracking ? 'Localisation active' : 'Localisation désactivée',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15,
                  color: _tracking ? const Color(0xFF00C7CC) : scheme.onSurface)),
              Text(_tracking ? 'Votre position est partagée avec le coordinateur' : 'Activez pour partager votre position',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            ])),
            Switch(value: _tracking, onChanged: (v) => setState(() => _tracking = v),
              activeColor: const Color(0xFF00C7CC)),
          ]),
        ),
        const SizedBox(height: 16),

        // ── Carte simulée ──────────────────────────────────────
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: scheme.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outline.withOpacity(0.2))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(children: [
              // Placeholder carte — remplacer par google_maps_flutter
              Container(color: const Color(0xFFE8F5E9),
                child: GridView.count(crossAxisCount: 8, childAspectRatio: 1,
                  children: List.generate(64, (_) => Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.green.withOpacity(0.1))))),
                )),
              // Marqueur position
              Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF00C7CC), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Bastos, Yaoundé', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                Container(width: 2, height: 20, color: const Color(0xFF00C7CC)),
                Container(width: 16, height: 16, decoration: BoxDecoration(
                  color: const Color(0xFF00C7CC), shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: const Color(0xFF00C7CC).withOpacity(0.4), blurRadius: 8, spreadRadius: 4)])),
              ])),
              // Badge "Simulation" en bas
              Positioned(bottom: 8, right: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                child: const Text('Simulation — Phase 6 : google_maps_flutter',
                  style: TextStyle(color: Colors.white, fontSize: 10)))),
            ]),
          ),
        ),
        const SizedBox(height: 16),

        // ── Infos position ────────────────────────────────────
        const Text('Position actuelle', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        _InfoRow(scheme, Icons.location_on_outlined, 'Adresse', 'Bastos, Yaoundé, Cameroun'),
        _InfoRow(scheme, Icons.my_location,           'Coordonnées', '3.8612° N, 11.5241° E'),
        _InfoRow(scheme, Icons.access_time,           'Dernière mise à jour', 'Il y a 2 min'),
        const SizedBox(height: 16),

        // ── Comment ajouter Google Maps ───────────────────────
        Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: scheme.tertiaryContainer, borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.info_outline, color: scheme.tertiary, size: 18),
              const SizedBox(width: 8),
              Text('Pour activer la carte réelle', style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onTertiaryContainer, fontSize: 13)),
            ]),
            const SizedBox(height: 8),
            Text('1. Ajouter dans pubspec.yaml :\n   geolocator: ^13.0.1\n   google_maps_flutter: ^2.10.0\n\n2. Ajouter la clé API dans AndroidManifest.xml\n3. Remplacer ce widget par GoogleMap()',
              style: TextStyle(fontSize: 12, color: scheme.onTertiaryContainer, height: 1.5)),
          ])),
      ]),
    );
  }
}

Widget _InfoRow(ColorScheme s, IconData icon, String label, String value) => Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: Row(children: [
    Container(width: 36, height: 36,
      decoration: BoxDecoration(color: s.primaryContainer, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 18, color: s.primary)),
    const SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 11, color: s.onSurfaceVariant)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    ]),
  ]));
