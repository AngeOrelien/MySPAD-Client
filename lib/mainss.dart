import 'package:flutter/material.dart';
import 'package:myspad/features/public/presentation/screens/home_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';

void main() => runApp(const SpadApp());

class SpadApp extends StatelessWidget {
  const SpadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPAD Cameroun',
      theme: AppTheme.lightTheme, // ← ici
      darkTheme: AppTheme.darkTheme, // ← et là
      themeMode: ThemeMode.system, // auto selon OS
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // page de test
    );
  }
}

// ─── Page de test temporaire ────────────────────────
class ThemeTestPage extends StatelessWidget {
  const ThemeTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme.of(context) lit le thème actif
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('SPAD — Test Thème')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test typographie
            Text('Heading 1', style: texts.displayLarge),
            Text('Body text normal', style: texts.bodyMedium),
            const SizedBox(height: 24),

            // Test couleurs via ColorScheme
            _ColorSwatch('primary', colors.primary),
            _ColorSwatch('secondary', colors.secondary),
            _ColorSwatch('surface', colors.surface),
            const SizedBox(height: 24),

            // Test AppColors direct
            _ColorSwatch('accent', AppColors.accentLight),
            _ColorSwatch('success', AppColors.success),
            _ColorSwatch('error', AppColors.error),
            const SizedBox(height: 24),

            // Test bouton avec thème
            ElevatedButton(
              onPressed: () {},
              child: const Text('ElevatedButton'),
            ),

            OutlinedButton(
              onPressed: () {},
              child: const Text("Outlined Button"),
            ),

            TextButton(
              onPressed: () {}, 
              child: const Text("TextButton")
            ),

            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

// Widget helper de test (à supprimer après)
class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}
