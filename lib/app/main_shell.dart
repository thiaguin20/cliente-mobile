import 'package:flutter/material.dart';

import '../core/l10n/app_strings.dart';
import '../data/app_data_controller.dart';
import '../features/clients/clients_page.dart';
import '../features/home/home_page.dart';
import '../features/metrics/metrics_page.dart';
import '../features/services/services_page.dart';
import '../features/settings/settings_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.strings,
    required this.dataController,
    required this.themeMode,
    required this.language,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  final AppStrings strings;
  final AppDataController dataController;
  final ThemeMode themeMode;
  final AppLanguage language;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;

    return AnimatedBuilder(
      animation: widget.dataController,
      builder: (context, _) {
        final pages = [
          HomePage(strings: strings, dataController: widget.dataController),
          ClientsPage(strings: strings, dataController: widget.dataController),
          ServicesPage(strings: strings, dataController: widget.dataController),
          MetricsPage(strings: strings, dataController: widget.dataController),
          SettingsPage(
            strings: strings,
            themeMode: widget.themeMode,
            language: widget.language,
            onThemeChanged: widget.onThemeChanged,
            onLanguageChanged: widget.onLanguageChanged,
          ),
        ];

        return Scaffold(
          body: SafeArea(child: pages[_selectedIndex]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: strings.home,
              ),
              NavigationDestination(
                icon: const Icon(Icons.people_outline),
                selectedIcon: const Icon(Icons.people),
                label: strings.clients,
              ),
              NavigationDestination(
                icon: const Icon(Icons.assignment_outlined),
                selectedIcon: const Icon(Icons.assignment),
                label: strings.services,
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: strings.metrics,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: strings.settingsTab,
              ),
            ],
          ),
        );
      },
    );
  }
}
