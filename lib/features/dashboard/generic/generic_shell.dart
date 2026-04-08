// lib/features/dashboard/generic/generic_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../shared/widgets/dashboard_widgets.dart'; // ← FIX

const _navByRole = <String, List<SidebarItem>>{
  'coordPersonnel': [
    SidebarItem(label: 'Accueil',   icon: Icons.home_outlined,     activeIcon: Icons.home),
    SidebarItem(label: 'AVS',       icon: Icons.badge_outlined,    activeIcon: Icons.badge),
    SidebarItem(label: 'Patients',  icon: Icons.elderly_outlined,  activeIcon: Icons.elderly),
    SidebarItem(label: 'Paiements', icon: Icons.payments_outlined, activeIcon: Icons.payments),
  ],
  'coordSante': [
    SidebarItem(label: 'Accueil',      icon: Icons.home_outlined,           activeIcon: Icons.home),
    SidebarItem(label: 'Plannings',    icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month),
    SidebarItem(label: 'Affectations', icon: Icons.assignment_outlined,     activeIcon: Icons.assignment),
    SidebarItem(label: 'Carte',        icon: Icons.map_outlined,            activeIcon: Icons.map),
  ],
  'medecin': [
    SidebarItem(label: 'Accueil',       icon: Icons.home_outlined,        activeIcon: Icons.home),
    SidebarItem(label: 'Rapports',      icon: Icons.description_outlined, activeIcon: Icons.description),
    SidebarItem(label: 'Prescriptions', icon: Icons.medication_outlined,  activeIcon: Icons.medication),
  ],
};

class GenericShell extends StatelessWidget {
  const GenericShell({super.key, required this.shell, required this.role});
  final StatefulNavigationShell shell;
  final String                  role;

  String get _title => switch (role) {
    'coordPersonnel' => 'Coord. Personnel',
    'coordSante'     => 'Coord. Santé',
    'medecin'        => 'Médecin',
    _                => role,
  };

  @override
  Widget build(BuildContext context) {
    final w         = MediaQuery.of(context).size.width;
    final navItems  = _navByRole[role] ?? _navByRole['coordPersonnel']!;
    final appBar    = DashAppBar(title: _title, notifCount: 0); // ← DashAppBar (public)

    if (w >= 600) {
      return Scaffold(
        appBar: appBar,
        body: Row(children: [
          DashSidebar(             // ← DashSidebar (public)
            navItems:     navItems,
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
        destinations: navItems.map((n) => NavigationDestination(
          icon: Icon(n.icon), selectedIcon: Icon(n.activeIcon), label: n.label,
        )).toList(),
      ),
    );
  }
}

// ── TAB GÉNÉRIQUE ────────────────────────────────────────────

class GenericTab extends StatelessWidget {
  const GenericTab({super.key, required this.title, required this.icon});
  final String   title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color:  scheme.primaryContainer,
              shape:  BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: scheme.primary),
          ),
          const SizedBox(height: 20),
          Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text('Cette section sera implémentée en Phase 6.',
            style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
            textAlign: TextAlign.center),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
            icon:  Icon(Icons.logout, color: scheme.error),
            label: Text('Déconnexion', style: TextStyle(color: scheme.error)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: scheme.error.withOpacity(0.4))),
          ),
        ]),
      ),
    );
  }
}