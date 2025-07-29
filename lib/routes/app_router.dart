import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import '../modules/main/main_view.dart';
import '../modules/splash/splash_view.dart';
import '../modules/main/home/home_view.dart';
import '../modules/main/settings/settings_view.dart';
import '../modules/main/voting/voting_view.dart';
import '../views/wikipedia_view.dart';

class AppRouter {
  static GoRouter get router => GoRouter(
        initialLocation: AppRoutes.splash,
        routes: [
          GoRoute(
            path: AppRoutes.splash,
            name: 'splash',
            builder: (context, state) => const SplashView(),
          ),
          GoRoute(
            path: AppRoutes.main,
            name: 'main',
            builder: (context, state) => const MainView(),
            routes: [
              GoRoute(
                path: 'home',
                name: 'home',
                builder: (context, state) => const HomeView(),
              ),
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) => const SettingsView(),
                routes: [
                  GoRoute(
                    path: 'webview',
                    name: 'webview',
                    builder: (context, state) {
                      final Map<String, String>? params =
                          state.extra as Map<String, String>?;
                      final title = params?['title'] ?? '';
                      final url = params?['url'] ?? '';
                      return WikiWebView(
                        title: title,
                        url: url,
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'voting',
                name: 'voting',
                builder: (context, state) => const VotingView(),
              ),
            ],
          ),
        ],
        errorBuilder: (context, state) => _ErrorScreen(error: state.error),
      );
}

class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Página no encontrada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              error?.toString() ?? 'Error desconocido',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
