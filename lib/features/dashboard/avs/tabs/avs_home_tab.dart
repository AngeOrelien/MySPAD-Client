// lib/features/dashboard/avs/tabs/avs_home_tab.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/user_session.dart';

class AvsHomeTab extends StatelessWidget {
  const AvsHomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme  = Theme.of(context).colorScheme;
    final session = UserSession.instance;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Bannière patient ───────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00C7CC), Color(0xFF004345)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            CircleAvatar(radius: 28, backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.elderly, color: Colors.white, size: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Mme Paulette Biya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              Text('78 ans · Bastos, Yaoundé', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
              const SizedBox(height: 6),
              Row(children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                const Text('Suivi actif', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ]),
            ])),
            IconButton(icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              onPressed: () => context.go(RouteNames.avsPatient)),
          ]),
        ),
        const SizedBox(height: 16),

        // ── Actions rapides ────────────────────────────────────
        const Text('Actions rapides', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(children: [
          _QuickBtn(Icons.edit_note_rounded,    'Nouveau\nrapport',    scheme.primary,           () => context.go(RouteNames.avsRapports)),
          const SizedBox(width: 8),
          _QuickBtn(Icons.medication_rounded,   'Médicaments',        const Color(0xFF0C8C6B),  () => context.go(RouteNames.avsPatient)),
          const SizedBox(width: 8),
          _QuickBtn(Icons.location_on_rounded,  'Ma position',        const Color(0xFFF5A623),  () => context.go(RouteNames.avsLocalisation)),
          const SizedBox(width: 8),
          _QuickBtn(Icons.warning_amber_rounded,'Urgence',            const Color(0xFFE53935),  () {}),
        ]),
        const SizedBox(height: 20),

        // ── Signes vitaux d'aujourd'hui ───────────────────────
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Paramètres vitaux — aujourd\'hui', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          TextButton(onPressed: () {}, child: const Text('Saisir', style: TextStyle(fontSize: 12))),
        ]),
        const SizedBox(height: 10),
        GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.2,
          children: const [
            _VitalCard('TA matin', '128/70 mmHg', Icons.favorite_rounded, Color(0xFF00C7CC)),
            _VitalCard('Pouls',    '60 pls/min',  Icons.graphic_eq,       Color(0xFF0C8C6B)),
            _VitalCard('Temp.',    '36.8°C',      Icons.thermostat,       Color(0xFFF5A623)),
            _VitalCard('SpO2',     '97%',         Icons.air,              Color(0xFF7B61FF)),
          ],
        ),
        const SizedBox(height: 20),

        // ── Tâches du jour ────────────────────────────────────
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Tâches du jour', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFFD1FBFB), borderRadius: BorderRadius.circular(999)),
            child: const Text('2/5 complétées', style: TextStyle(color: Color(0xFF004345), fontSize: 11, fontWeight: FontWeight.w600))),
        ]),
        const SizedBox(height: 10),
        ..._tasks.map((t) => _TaskTile(task: t)),
      ]),
    );
  }
}

class _QuickBtn extends StatelessWidget {
  const _QuickBtn(this.icon, this.label, this.color, this.onTap);
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  @override
  Widget build(BuildContext ctx) => Expanded(child: InkWell(onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500, height: 1.2)),
      ]))));
}

class _VitalCard extends StatelessWidget {
  const _VitalCard(this.label, this.value, this.icon, this.color);
  final String label, value; final IconData icon; final Color color;
  @override
  Widget build(BuildContext ctx) {
    final scheme = Theme.of(ctx).colorScheme;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2))),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(label, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: scheme.onSurface)),
        ])),
      ]));
  }
}

class _Task { const _Task(this.time, this.label, this.done); final String time, label; final bool done; }
const _tasks = [
  _Task('08:00', 'Médicaments du matin',   true),
  _Task('09:30', 'Hygiène corporelle',     true),
  _Task('12:00', 'Préparer le déjeuner',   false),
  _Task('14:00', 'Rédiger le rapport',     false),
  _Task('18:00', 'Médicaments du soir',    false),
];

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});
  final _Task task;
  @override
  Widget build(BuildContext ctx) {
    final s = Theme.of(ctx).colorScheme;
    return Container(margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: task.done ? const Color(0xFFF8FEFE) : s.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: task.done ? const Color(0xFF73E6E8) : s.outline.withOpacity(0.2))),
      child: Row(children: [
        Icon(task.done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          color: task.done ? const Color(0xFF00C7CC) : s.outline, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(task.label, style: TextStyle(
          fontSize: 13, color: task.done ? s.onSurfaceVariant : s.onSurface,
          decoration: task.done ? TextDecoration.lineThrough : null))),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: s.surfaceVariant, borderRadius: BorderRadius.circular(6)),
          child: Text(task.time, style: TextStyle(fontSize: 11, color: s.onSurfaceVariant, fontWeight: FontWeight.w500))),
      ]));
  }
}
