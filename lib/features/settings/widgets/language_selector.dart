import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.strings,
    required this.value,
    required this.onChanged,
  });

  final AppStrings strings;
  final AppLanguage value;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AppLanguage>(
      segments: [
        ButtonSegment(
          value: AppLanguage.pt,
          label: Text(strings.portuguese),
          icon: const Icon(Icons.language),
        ),
        ButtonSegment(
          value: AppLanguage.en,
          label: Text(strings.english),
          icon: const Icon(Icons.translate),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
    );
  }
}
