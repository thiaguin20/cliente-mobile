import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : variant = _AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : variant = _AppButtonVariant.secondary;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : variant = _AppButtonVariant.danger;

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final _AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      _AppButtonVariant.primary => FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
      _AppButtonVariant.secondary => OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
      _AppButtonVariant.danger => FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    };
  }
}

enum _AppButtonVariant { primary, secondary, danger }
