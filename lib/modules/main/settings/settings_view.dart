import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/theme_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _showAboutModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Acerca de'),
          content: const Text(
            'Esta es una aplicación de prueba para el cargo de Desarrollador FullStack Flutter y Java en XpertGroup.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                leading: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Modo Oscuro'),
                subtitle: Text(
                  themeProvider.isDarkMode ? 'Activado' : 'Desactivado',
                ),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.security,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Privacidad y Seguridad'),
            subtitle: const Text('Configuraciones de seguridad'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.go('/main/settings/webview', extra: {
                'title': 'Política de Privacidad',
                'url': 'https://xpertgroup.co/politica-privacidad/',
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.help,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Ayuda y Soporte'),
            subtitle: const Text('Obtener ayuda y contactar soporte'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.go('/main/settings/webview', extra: {
                'title': 'Ayuda y Soporte',
                'url': 'https://xpertgroup.co/',
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Acerca de'),
            subtitle: const Text('Información de la aplicación'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showAboutModal(context),
          ),
        ],
      ),
    );
  }
}
