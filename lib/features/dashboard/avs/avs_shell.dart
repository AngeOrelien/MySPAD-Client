// lib/features/dashboard/avs/avs_shell.dart
// ─── DASHBOARD AVS COMPLET ────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/utils/user_session.dart';
import '../../../shared/widgets/dashboard_widgets.dart';
import '../../../shared/widgets/spad_ai_fab.dart';
import 'tabs/avs_home_tab.dart';
import 'tabs/avs_patient_tab.dart';
import 'tabs/avs_rapport_tab.dart';
import 'tabs/avs_localisation_tab.dart';

const _avsItems = [
  SidebarItem(label: 'Accueil',     icon: Icons.home_outlined,        activeIcon: Icons.home_rounded),
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
    final appBar = DashAppBar(
      title: 'Bonjour, ${UserSession.instance.name.split(' ').first} 👋',
      notifCount: 3, showAlertButton: true,
      aiButton: true, // ← active le bouton IA dans l'AppBar
    );

    if (w >= 600) {
      return Scaffold(
        appBar: appBar,
        body: Row(children: [
          DashSidebar(navItems: _avsItems, currentIndex: shell.currentIndex, onTap: (i) => shell.goBranch(i)),
          const VerticalDivider(width: 1),
          Expanded(child: shell),
        ]),
      );
    }
    return Scaffold(
      appBar: appBar,
      body:   shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i),
        destinations: _avsItems.map((n) => NavigationDestination(
          icon: Icon(n.icon), selectedIcon: Icon(n.activeIcon), label: n.label)).toList(),
      ),
    );
  }
}

// ── TABS (re-export) ──────────────────────────────────────────
// Les tabs sont dans des fichiers séparés pour la lisibilité
// export 'tabs/avs_home_tab.dart';
// export 'tabs/avs_patient_tab.dart';
// export 'tabs/avs_rapport_tab.dart';
// export 'tabs/avs_localisation_tab.dart';
