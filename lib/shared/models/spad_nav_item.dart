// lib/shared/models/spad_nav_item.dart
//
// ─── MODÈLE D'ITEM DE NAVIGATION ─────────────────────────────
// Mise à jour : visiteur → 3e item = "Connexion" (auth hub)
// LoginScreen et RegisterScreen sont des sous-pages de l'auth hub.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class SpadNavItem {
  const SpadNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.badge,
  });

  final String   label;
  final IconData icon;
  final IconData activeIcon;
  final String   route;
  final int?     badge;
}

class SpadNavItems {
  SpadNavItems._();

  // ── Visiteur ─────────────────────────────────────────────
  // 3e item = "Connexion" → ouvre AuthHubScreen
  // LoginScreen et RegisterScreen sont dans AuthHubScreen
  static const List<SpadNavItem> visitor = [
    SpadNavItem(
      label:      'Accueil',
      icon:       Icons.home_outlined,
      activeIcon: Icons.home,
      route:      '/',
    ),
    SpadNavItem(
      label:      'Offres',
      icon:       Icons.work_outline,
      activeIcon: Icons.work,
      route:      '/offres',
    ),
    SpadNavItem(
      label:      'Connexion',
      icon:       Icons.person_outline,
      activeIcon: Icons.person,
      route:      '/auth',
    ),
  ];

  // ── Famille / Patient ────────────────────────────────────
  static const List<SpadNavItem> famille = [
    SpadNavItem(label: 'Accueil',  icon: Icons.home_outlined,         activeIcon: Icons.home,          route: '/famille'),
    SpadNavItem(label: 'Santé',    icon: Icons.favorite_outline,      activeIcon: Icons.favorite,      route: '/famille/sante'),
    SpadNavItem(label: 'Rapports', icon: Icons.description_outlined,  activeIcon: Icons.description,   route: '/famille/rapports'),
    SpadNavItem(label: 'Alertes',  icon: Icons.notifications_outlined,activeIcon: Icons.notifications, route: '/famille/alertes'),
  ];

  // ── AVS ──────────────────────────────────────────────────
  static const List<SpadNavItem> avs = [
    SpadNavItem(label: 'Accueil',    icon: Icons.home_outlined,        activeIcon: Icons.home,         route: '/avs'),
    SpadNavItem(label: 'Patient',    icon: Icons.elderly_outlined,     activeIcon: Icons.elderly,      route: '/avs/patient'),
    SpadNavItem(label: 'Rapports',   icon: Icons.edit_note_outlined,   activeIcon: Icons.edit_note,    route: '/avs/rapports'),
    SpadNavItem(label: 'Ma position',icon: Icons.location_on_outlined, activeIcon: Icons.location_on,  route: '/avs/localisation'),
  ];

  // ── Administrateur ───────────────────────────────────────
  static const List<SpadNavItem> admin = [
    SpadNavItem(label: 'Accueil',      icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard,    route: '/admin'),
    SpadNavItem(label: 'Utilisateurs', icon: Icons.people_outline,     activeIcon: Icons.people,       route: '/admin/users'),
    SpadNavItem(label: 'Stats',        icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart,    route: '/admin/stats'),
    SpadNavItem(label: 'Actualités',   icon: Icons.article_outlined,   activeIcon: Icons.article,      route: '/admin/actualites'),
  ];

  // ── Coordonnateur Personnel ──────────────────────────────
  static const List<SpadNavItem> coordPersonnel = [
    SpadNavItem(label: 'Accueil',   icon: Icons.home_outlined,     activeIcon: Icons.home,     route: '/coord-personnel'),
    SpadNavItem(label: 'AVS',       icon: Icons.badge_outlined,    activeIcon: Icons.badge,    route: '/coord-personnel/avs'),
    SpadNavItem(label: 'Patients',  icon: Icons.elderly_outlined,  activeIcon: Icons.elderly,  route: '/coord-personnel/patients'),
    SpadNavItem(label: 'Paiements', icon: Icons.payments_outlined, activeIcon: Icons.payments, route: '/coord-personnel/paiements'),
  ];

  // ── Coordonnateur Santé ──────────────────────────────────
  static const List<SpadNavItem> coordSante = [
    SpadNavItem(label: 'Accueil',      icon: Icons.home_outlined,           activeIcon: Icons.home,           route: '/coord-sante'),
    SpadNavItem(label: 'Plannings',    icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month, route: '/coord-sante/plannings'),
    SpadNavItem(label: 'Affectations', icon: Icons.assignment_outlined,     activeIcon: Icons.assignment,     route: '/coord-sante/affectations'),
    SpadNavItem(label: 'Carte',        icon: Icons.map_outlined,            activeIcon: Icons.map,            route: '/coord-sante/carte'),
  ];

  // ── Médecin ──────────────────────────────────────────────
  static const List<SpadNavItem> medecin = [
    SpadNavItem(label: 'Accueil',      icon: Icons.home_outlined,        activeIcon: Icons.home,        route: '/medecin'),
    SpadNavItem(label: 'Rapports',     icon: Icons.description_outlined, activeIcon: Icons.description, route: '/medecin/rapports'),
    SpadNavItem(label: 'Prescriptions',icon: Icons.medication_outlined,  activeIcon: Icons.medication,  route: '/medecin/prescriptions'),
  ];

  /// Retourne la liste d'items pour un rôle donné
  static List<SpadNavItem> forRole(String role) {
    switch (role) {
      case 'famille':        return famille;
      case 'avs':            return avs;
      case 'admin':          return admin;
      case 'coordPersonnel': return coordPersonnel;
      case 'coordSante':     return coordSante;
      case 'medecin':        return medecin;
      default:               return visitor;
    }
  }
}