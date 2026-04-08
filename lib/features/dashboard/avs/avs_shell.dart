// lib/features/dashboard/avs/avs_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/utils/user_session.dart';
// ← Import du fichier partagé PUBLIC (sans underscore)
import '../../../shared/widgets/dashboard_widgets.dart';

// ── Items de navigation AVS ───────────────────────────────────
const _avsItems = [
  SidebarItem(label: 'Accueil',     icon: Icons.home_outlined,        activeIcon: Icons.home),
  SidebarItem(label: 'Mon patient', icon: Icons.elderly_outlined,     activeIcon: Icons.elderly),
  SidebarItem(label: 'Rapports',   icon: Icons.edit_note_outlined,   activeIcon: Icons.edit_note),
  SidebarItem(label: 'Ma position',icon: Icons.location_on_outlined, activeIcon: Icons.location_on),
];

class AvsShell extends StatelessWidget {
  const AvsShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return _desktopLayout(context);
    if (w >= 600)  return _tabletLayout(context);
    return _mobileLayout(context);
  }

  Widget _mobileLayout(BuildContext ctx) => Scaffold(
    appBar: DashAppBar(
      title:           'Bonjour, ${UserSession.instance.name.split(' ').first}',
      notifCount:      3,
      showAlertButton: true,
    ),
    body: shell,
    bottomNavigationBar: NavigationBar(
      selectedIndex:         shell.currentIndex,
      onDestinationSelected: (i) => shell.goBranch(i),
      destinations: _avsItems.map((item) => NavigationDestination(
        icon:         Icon(item.icon),
        selectedIcon: Icon(item.activeIcon),
        label:        item.label,
      )).toList(),
    ),
  );

  Widget _tabletLayout(BuildContext ctx) => Scaffold(
    appBar: DashAppBar(
      title:           'Bonjour, ${UserSession.instance.name.split(' ').first}',
      notifCount:      3,
      showAlertButton: true,
    ),
    body: Row(children: [
      DashSidebar(
        navItems:     _avsItems,
        currentIndex: shell.currentIndex,
        onTap:        (i) => shell.goBranch(i),
      ),
      const VerticalDivider(width: 1),
      Expanded(child: shell),
    ]),
  );

  Widget _desktopLayout(BuildContext ctx) => Scaffold(
    body: Row(children: [
      DashSidebar(
        navItems:     _avsItems,
        currentIndex: shell.currentIndex,
        onTap:        (i) => shell.goBranch(i),
        width:        260,
      ),
      const VerticalDivider(width: 1),
      Expanded(child: Column(children: [
        DashAppBar(
          title:           'Bonjour, ${UserSession.instance.name.split(' ').first}',
          notifCount:      3,
          showAlertButton: true,
        ),
        Expanded(child: shell),
      ])),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────
// TABS AVS
// ─────────────────────────────────────────────────────────────

class AvsHomeTab extends StatelessWidget {
  const AvsHomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Résumé du jour',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        // Carte patient
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:        scheme.surface,
            borderRadius: BorderRadius.circular(14),
            border:       Border.all(color: scheme.outline.withOpacity(0.2)),
          ),
          child: Row(children: [
            CircleAvatar(radius: 24, backgroundColor: scheme.primaryContainer,
              child: Icon(Icons.elderly, color: scheme.primary, size: 24)),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mme Paulette Biya, 78 ans',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Row(children: [
                  Container(width: 8, height: 8,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                  Text('Suivi actif · Bastos, Yaoundé',
                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                ]),
              ],
            )),
          ]),
        ),
        const SizedBox(height: 20),
        const Text('Tâches du jour',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        ...[
          (true,  '08:00', 'Médicaments du matin administrés'),
          (true,  '09:30', 'Toilette et habillage effectués'),
          (false, '12:00', 'Préparer le déjeuner'),
          (false, '14:00', 'Rédiger le rapport quotidien'),
          (false, '18:00', 'Médicaments du soir'),
        ].map((t) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: t.$1 ? const Color(0xFFF8FEFE) : scheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: t.$1 ? const Color(0xFF73E6E8)
                         : scheme.outline.withOpacity(0.2)),
          ),
          child: Row(children: [
            Icon(t.$1 ? Icons.check_circle : Icons.radio_button_unchecked,
              color: t.$1 ? const Color(0xFF00C7CC) : scheme.outline,
              size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(t.$3,
              style: TextStyle(
                color:      t.$1 ? scheme.onSurfaceVariant : scheme.onSurface,
                decoration: t.$1 ? TextDecoration.lineThrough : null,
                fontSize:   14,
              ))),
            Text(t.$2,
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ]),
        )),
      ]),
    );
  }
}

class AvsPatientTab extends StatelessWidget {
  const AvsPatientTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.elderly, size: 64, color: Theme.of(context).colorScheme.outline),
      const SizedBox(height: 16),
      const Text('Détails du patient',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('À implémenter — Phase 6',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );
}

class AvsRapportsTab extends StatelessWidget {
  const AvsRapportsTab({super.key});
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

class AvsLocalisationTab extends StatelessWidget {
  const AvsLocalisationTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.location_on, size: 64, color: Theme.of(context).colorScheme.outline),
      const SizedBox(height: 16),
      const Text('Ma position GPS',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('Nécessite : geolocator: ^13.0.1 dans pubspec.yaml',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );
}