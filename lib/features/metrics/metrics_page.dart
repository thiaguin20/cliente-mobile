import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/summary_card.dart';
import '../../data/app_data_controller.dart';
import '../../data/models/service_status.dart';
import 'widgets/status_progress_section.dart';

class MetricsPage extends StatelessWidget {
  const MetricsPage({
    super.key,
    required this.strings,
    required this.dataController,
  });

  final AppStrings strings;
  final AppDataController dataController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(strings.metrics)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            strings.monthlyResult,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              SummaryCard(
                title: strings.totalServices,
                value: dataController.services.length.toString(),
                icon: Icons.assignment_outlined,
                accentColor: AppColors.primaryBlue,
              ),
              SummaryCard(
                title: strings.expectedValue,
                value: money(dataController.totalExpectedValue),
                icon: Icons.payments_outlined,
                accentColor: AppColors.supportBlue,
              ),
              SummaryCard(
                title: strings.completedValue,
                value: money(
                  dataController.valueByStatus(ServiceStatus.completed),
                ),
                icon: Icons.check_circle_outline,
                accentColor: AppColors.successGreen,
              ),
              SummaryCard(
                title: strings.pendingValue,
                value: money(
                  dataController.valueByStatus(ServiceStatus.pending),
                ),
                icon: Icons.schedule,
                accentColor: AppColors.warningYellow,
              ),
            ],
          ),
          const SizedBox(height: 24),
          StatusProgressSection(
            strings: strings,
            dataController: dataController,
          ),
        ],
      ),
    );
  }
}
