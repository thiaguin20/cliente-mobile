import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../data/app_data_controller.dart';
import '../../../data/models/service_status.dart';

class StatusProgressSection extends StatelessWidget {
  const StatusProgressSection({
    super.key,
    required this.strings,
    required this.dataController,
  });

  final AppStrings strings;
  final AppDataController dataController;

  @override
  Widget build(BuildContext context) {
    final total = dataController.services.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.servicesByStatus,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _ProgressRow(
              label: strings.pending,
              value: dataController.countByStatus(ServiceStatus.pending),
              total: total,
              color: AppColors.warningYellow,
            ),
            _ProgressRow(
              label: strings.inProgress,
              value: dataController.countByStatus(ServiceStatus.inProgress),
              total: total,
              color: AppColors.supportBlue,
            ),
            _ProgressRow(
              label: strings.completed,
              value: dataController.countByStatus(ServiceStatus.completed),
              total: total,
              color: AppColors.successGreen,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  final String label;
  final int value;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : value / total;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text('$value/$total'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(999),
          ),
        ],
      ),
    );
  }
}
