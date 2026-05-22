import 'package:flutter/material.dart';

import '../core/l10n/app_strings.dart';
import '../data/app_data_controller.dart';
import 'app_theme.dart';
import 'main_shell.dart';

class ClienteMobileApp extends StatefulWidget {
  const ClienteMobileApp({super.key});

  @override
  State<ClienteMobileApp> createState() => _ClienteMobileAppState();
}

class _ClienteMobileAppState extends State<ClienteMobileApp> {
  ThemeMode _themeMode = ThemeMode.system;
  AppLanguage _language = AppLanguage.pt;
  final AppDataController _dataController = AppDataController();

  @override
  void initState() {
    super.initState();
    _dataController.load();
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void _changeLanguage(AppLanguage language) {
    setState(() {
      _language = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_language);

    return MaterialApp(
      title: 'Cliente Mobile',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: MainShell(
        strings: strings,
        dataController: _dataController,
        themeMode: _themeMode,
        language: _language,
        onThemeChanged: _changeTheme,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}
