// lib/core/router/route_names.dart
// ─── TOUTES LES ROUTES EN CONSTANTES ─────────────────────────
// RÈGLE : ne jamais écrire '/login' en dur dans un widget.
// Toujours utiliser RouteNames.login → facile à refactorer.
// ─────────────────────────────────────────────────────────────
class RouteNames {
  RouteNames._();

  // ── Splash + Public ─────────────────────────────────────────
  static const splash   = '/splash';
  static const setup = '/setup';
  static const home     = '/';
  static const offres   = '/offres';

  // ── Auth (standalone — SANS nav) ────────────────────────────
  static const login    = '/login';
  static const register = '/register';

  // ── AVS ─────────────────────────────────────────────────────
  static const avs             = '/avs';
  static const avsPatient      = '/avs/patient';
  static const avsRapports     = '/avs/rapports';
  static const avsLocalisation = '/avs/localisation';

  // ── Famille ─────────────────────────────────────────────────
  static const famille         = '/famille';
  static const familleSante    = '/famille/sante';
  static const familleRapports = '/famille/rapports';
  static const familleAlertes  = '/famille/alertes';

  // ── Admin ────────────────────────────────────────────────────
  static const admin           = '/admin';
  static const adminUsers      = '/admin/users';
  static const adminStats      = '/admin/stats';
  static const adminActualites = '/admin/actualites';

  // ── Coord. Personnel ─────────────────────────────────────────
  static const coordPersonnel    = '/coord-personnel';
  static const coordPersonnelAvs = '/coord-personnel/avs';
  static const coordPersonnelPat = '/coord-personnel/patients';
  static const coordPersonnelPay = '/coord-personnel/paiements';

  // ── Coord. Santé ─────────────────────────────────────────────
  static const coordSante         = '/coord-sante';
  static const coordSantePlan     = '/coord-sante/plannings';
  static const coordSanteAffect   = '/coord-sante/affectations';
  static const coordSanteCarte    = '/coord-sante/carte';

  // ── Médecin ──────────────────────────────────────────────────
  static const medecin             = '/medecin';
  static const medecinRapports     = '/medecin/rapports';
  static const medecinPrescription = '/medecin/prescriptions';

  // ── Helper : route home selon le rôle ────────────────────────
  static String homeForRole(String role) => switch (role) {
    'avs'            => avs,
    'famille'        => famille,
    'admin'          => admin,
    'coordPersonnel' => coordPersonnel,
    'coordSante'     => coordSante,
    'medecin'        => medecin,
    _                => home,
  };

  // ── Chemins publics (pas de redirection auth) ────────────────
  static const publicPaths = [splash, home, offres, login, register];
  static bool isPublic(String path) => publicPaths.contains(path);
}
