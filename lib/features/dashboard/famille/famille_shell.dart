// lib/features/dashboard/famille/famille_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/utils/user_session.dart';
import '../../../shared/widgets/dashboard_widgets.dart'; // ← FIX

const _familleItems = [
  SidebarItem(label: 'Accueil',  icon: Icons.home_outlined,          activeIcon: Icons.home),
  SidebarItem(label: 'Santé',    icon: Icons.favorite_outline,        activeIcon: Icons.favorite),
  SidebarItem(label: 'Rapports', icon: Icons.description_outlined,   activeIcon: Icons.description),
  SidebarItem(label: 'Alertes',  icon: Icons.notifications_outlined, activeIcon: Icons.notifications),
];

class FamilleShell extends StatelessWidget {
  const FamilleShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final appBar = DashAppBar(     // ← DashAppBar (public)
      title:      'Espace famille',
      notifCount: 2,
    );

    if (w >= 600) {
      return Scaffold(
        appBar: appBar,
        body: Row(children: [
          DashSidebar(             // ← DashSidebar (public)
            navItems:     _familleItems,
            currentIndex: shell.currentIndex,
            onTap:        (i) => shell.goBranch(i),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: shell),
        ]),
      );
    }
    return Scaffold(
      appBar: appBar,
      body:   shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex:         shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i),
        destinations: _familleItems.map((n) => NavigationDestination(
          icon: Icon(n.icon), selectedIcon: Icon(n.activeIcon), label: n.label,
        )).toList(),
      ),
    );
  }
}

// ── TABS ──────────────────────────────────────────────────────

class FamilleHomeTab extends StatelessWidget {
  const FamilleHomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('État de santé du patient',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        // Signes vitaux
        Row(children: [
          _VitalCard('12/8',    'Tension',  const Color(0xFF00C7CC)),
          const SizedBox(width: 10),
          _VitalCard('1.05 g/L','Glycémie', const Color(0xFF0C8C6B)),
          const SizedBox(width: 10),
          _VitalCard('37.2°C', 'Temp.',    const Color(0xFFF5A623)),
        ]),
        const SizedBox(height: 20),
        const Text('Dernier rapport AVS',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:        scheme.surface,
            borderRadius: BorderRadius.circular(14),
            border:       Border.all(color: scheme.outline.withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('28 juin 2025',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color:        const Color(0xFFD1FBFB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('Validé',
                  style: TextStyle(
                    fontSize: 11, color: Color(0xFF004345), fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 8),
            Text(
              'Patiente en bonne forme. Repas pris correctement. Médicaments administrés selon prescription.',
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
          ]),
        ),
      ]),
    );
  }
}

class _VitalCard extends StatelessWidget {
  const _VitalCard(this.value, this.label, this.color);
  final String value, label;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:        color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border:       Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(children: [
            Text(value,
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            Text(label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ]),
        ),
      ),
    );
  }
}

class FamilleSanteTab extends StatelessWidget {
  const FamilleSanteTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.favorite, size: 64, color: Theme.of(context).colorScheme.outline),
      const SizedBox(height: 16),
      const Text('Suivi santé', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('À implémenter — Phase 6',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );
}

class FamilleRapportsTab extends StatelessWidget {
  const FamilleRapportsTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.description, size: 64, color: Theme.of(context).colorScheme.outline),
      const SizedBox(height: 16),
      const Text('Rapports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('À implémenter — Phase 6',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );
}

class FamilleAlertesTab extends StatelessWidget {
  const FamilleAlertesTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.notifications, size: 64, color: Theme.of(context).colorScheme.outline),
      const SizedBox(height: 16),
      const Text('Alertes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('À implémenter — Phase 6',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );
}