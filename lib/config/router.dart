import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirai/modules/authentication/presentation/pages/auth_page.dart';
import 'package:mirai/modules/navigation/presentation/pages/location_permission_guard_page.dart';
import 'package:mirai/modules/navigation/presentation/pages/navigation_page.dart';
import 'package:mirai/modules/properties/presentation/pages/home_page.dart';

/// App router configuration factory with lazy-loaded camera page
///
/// Routes:
/// - / : LocationPermissionGuardPage (entry point)
/// - /navigation : NavigationPage (after location verified)
/// - /camera : CaptureEvidencePage (lazy-loaded on first access)
GoRouter createAppRouter({
  required Widget Function() cameraPageBuilder,
  required Future<void> Function(String code) onCodeSubmitted,
}) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'auth',
        pageBuilder: (context, state) => MaterialPage(
          child: AuthPage(onCodeSubmitted: onCodeSubmitted),
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          child: HomePage(
            ownerIdentifier:
                state.uri.queryParameters['ownerCode'] ?? 'owner-demo',
          ),
        ),
      ),
      GoRoute(
        path: '/location-guard',
        name: 'location-guard',
        pageBuilder: (context, state) => MaterialPage<bool>(
          child: LocationPermissionGuardPage(
            navigationPage: const NavigationPage(),
            onLocationReady: () {
            },
          ),
        ),
      ),
      GoRoute(
        path: '/navigation',
        name: 'navigation',
        pageBuilder: (context, state) =>
            const MaterialPage(child: NavigationPage()),
      ),
      GoRoute(
        path: '/camera',
        name: 'camera',
        pageBuilder: (context, state) =>
            MaterialPage(child: cameraPageBuilder()),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Text('Rota não encontrada: ${state.matchedLocation}'),
        ),
      ),
    ),
  );
}
