// lib/features/dashboard/admin/admin_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/utils/user_session.dart';
import '../../../shared/widgets/dashboard_widgets.dart'; // ← FIX

const _adminItems = [
  SidebarItem(label: 'Accueil',      icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard),
  SidebarItem(label: 'Utilisateurs', icon: Icons.people_outline,     activeIcon: Icons.people),
  SidebarItem(label: 'Stats',        icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart),
  SidebarItem(label: 'Actualités',   icon: Icons.article_outlined,   activeIcon: Icons.article),
];

class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final w      = MediaQuery.of(context).size.width;
    final appBar = DashAppBar(    // ← DashAppBar (public)
      title:      'Administration SPAD',
      notifCount: 5,
    );

    if (w >= 600) {
      return Scaffold(
        appBar: appBar,
        body: Row(children: [
          DashSidebar(            // ← DashSidebar (public)
            navItems:     _adminItems,
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
        destinations: _adminItems.map((n) => NavigationDestination(
          icon: Icon(n.icon), selectedIcon: Icon(n.activeIcon), label: n.label,
        )).toList(),
      ),
    );
  }
}

// ── TABS ADMIN ────────────────────────────────────────────────

class AdminHomeTab extends StatelessWidget {
  const AdminHomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cols   = MediaQuery.of(context).size.width < 600 ? 2 : 4;
    const stats  = [
      ('247',  'Utilisateurs',  Color(0xFF00C7CC)),
      ('83',   'AVS actifs',    Color(0xFF0C8C6B)),
      ('156',  'Patients',      Color(0xFFF5A623)),
      ('4.2k', 'Rapports/mois', Color(0xFF007E81)),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Vue d\'ensemble',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount:   cols,
          shrinkWrap:       true,
          physics:          const NeverScrollableScrollPhysics(),
          mainAxisSpacing:  12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.8,
          children: stats.map((s) => FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:        s.$3.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border:       Border.all(color: s.$3.withOpacity(0.3)),
              ),
              child: Column(children: [
                Text(s.$1,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: s.$3)),
                Text(s.$2,
                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
              ]),
            ),
          )).toList(),
        ),
        const SizedBox(height: 24),
        const Text('Activité récente',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        ...[
          (Icons.person_add,  'Nouveau compte AVS créé',    'il y a 10 min', const Color(0xFF00C7CC)),
          (Icons.article,     'Actualité publiée',           'il y a 1h',    const Color(0xFF0C8C6B)),
          (Icons.warning,     'Alerte signalée — Bastos',    'il y a 2h',    Colors.red),
          (Icons.description, '48 rapports soumis auj.',    'Aujourd\'hui',  const Color(0xFFF5A623)),
        ].map((a) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color:        scheme.surface,
            borderRadius: BorderRadius.circular(10),
            border:       Border.all(color: scheme.outline.withOpacity(0.2)),
          ),
          child: Row(children: [
            Container(width: 36, height: 36,
              decoration: BoxDecoration(
                color: a.$4.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(a.$1, color: a.$4, size: 18)),
            const SizedBox(width: 12),
            Expanded(child: Text(a.$2,
              style: const TextStyle(fontSize: 14))),
            Text(a.$3,
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ]),
        )),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
          icon:      Icon(Icons.logout, color: scheme.error),
          label:     Text('Déconnexion', style: TextStyle(color: scheme.error)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: scheme.error.withOpacity(0.4))),
        ),
      ]),
    );
  }
}

class AdminUsersTab extends StatelessWidget {
  const AdminUsersTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.people, size: 64, color: Theme.of(context).colorScheme.outline),
      const SizedBox(height: 16),
      const Text('Gestion utilisateurs',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('À implémenter — Phase 6',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );
}

class AdminStatsTab extends StatelessWidget {
  const AdminStatsTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.bar_chart, size: 64, color: Theme.of(context).colorScheme.outline),
      const SizedBox(height: 16),
      const Text('Statistiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('À implémenter — Phase 6',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );
}

class AdminActualitesTab extends StatelessWidget {
  const AdminActualitesTab({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.article, size: 64, color: Theme.of(context).colorScheme.outline),
      const SizedBox(height: 16),
      const Text('Actualités', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('À implémenter — Phase 6',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]),
  );
}