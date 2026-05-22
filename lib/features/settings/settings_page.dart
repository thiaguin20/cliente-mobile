import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/widgets/app_button.dart';
import 'widgets/language_selector.dart';
import 'widgets/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.strings,
    required this.themeMode,
    required this.language,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  final AppStrings strings;
  final ThemeMode themeMode;
  final AppLanguage language;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SettingsSection(
            title: strings.appearance,
            child: ThemeSelector(
              strings: strings,
              value: themeMode,
              onChanged: onThemeChanged,
            ),
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: strings.languageText,
            child: LanguageSelector(
              strings: strings,
              value: language,
              onChanged: onLanguageChanged,
            ),
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: strings.localData,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.storage_outlined),
                  title: Text(strings.exportBackup),
                  subtitle: Text(strings.offlineInfo),
                  enabled: false,
                ),
                const SizedBox(height: 8),
                AppButton.danger(
                  label: strings.clearData,
                  icon: Icons.delete_outline,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: strings.appInfo,
            child: Text(strings.offlineInfo),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
