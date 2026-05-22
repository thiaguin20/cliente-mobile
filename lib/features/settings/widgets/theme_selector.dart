import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.strings,
    required this.value,
    required this.onChanged,
  });

  final AppStrings strings;
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(strings.light),
          icon: const Icon(Icons.light_mode_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(strings.dark),
          icon: const Icon(Icons.dark_mode_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(strings.system),
          icon: const Icon(Icons.phone_android_outlined),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
    );
  }
}
