import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main navigation page (placeholder)
///
/// Shows compass, distance, and navigation instructions
/// This is displayed after location permission and service are verified
class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navegação'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 64, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              'Localização OK',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Página de navegação com bússola 3D\nvirá aqui em breve',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.pushNamed('camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Capturar Evidência'),
            ),
          ],
        ),
      ),
    );
  }
}
