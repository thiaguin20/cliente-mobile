import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../data/models/service_status.dart';

class ServiceStatusFilter extends StatelessWidget {
  const ServiceStatusFilter({
    super.key,
    required this.strings,
    required this.selectedStatus,
    required this.onChanged,
  });

  final AppStrings strings;
  final ServiceStatus? selectedStatus;
  final ValueChanged<ServiceStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <ServiceStatus?>[
      null,
      ServiceStatus.pending,
      ServiceStatus.inProgress,
      ServiceStatus.completed,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((status) {
          final isSelected = status == selectedStatus;
          final label = status == null
              ? strings.all
              : strings.statusLabel(status.key);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(label),
              onSelected: (_) => onChanged(status),
            ),
          );
        }).toList(),
      ),
    );
  }
}
