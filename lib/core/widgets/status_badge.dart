import 'package:flutter/material.dart';

import '../../data/models/service_status.dart';
import '../constants/app_colors.dart';
import '../l10n/app_strings.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, required this.strings});

  final ServiceStatus status;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsForStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        strings.statusLabel(status.key),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _StatusColors _colorsForStatus(ServiceStatus status) {
    return switch (status) {
      ServiceStatus.pending => const _StatusColors(
        background: Color(0xFFFFF4CC),
        foreground: Color(0xFF7A5600),
      ),
      ServiceStatus.inProgress => const _StatusColors(
        background: Color(0xFFE4F0FF),
        foreground: AppColors.primaryBlue,
      ),
      ServiceStatus.completed => const _StatusColors(
        background: Color(0xFFDDF7E6),
        foreground: Color(0xFF176B34),
      ),
    };
  }
}

class _StatusColors {
  const _StatusColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
