import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/summary_card.dart';
import '../../data/app_data_controller.dart';
import '../../data/models/service_status.dart';
import '../clients/client_form_page.dart';
import '../services/service_form_page.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/service_preview_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.strings,
    required this.dataController,
  });

  final AppStrings strings;
  final AppDataController dataController;

  @override
  Widget build(BuildContext context) {
    final pending = dataController.countByStatus(ServiceStatus.pending);
    final inProgress = dataController.countByStatus(ServiceStatus.inProgress);
    final completed = dataController.countByStatus(ServiceStatus.completed);
    final priorityServices = dataController.services
        .where((service) => service.status != ServiceStatus.completed)
        .toList(growable: false);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(strings.appName),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              tooltip: strings.searchServices,
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _HomeHero(
                strings: strings,
                onNewClient: () => _openClientForm(context),
                onNewService: () => _openServiceForm(context),
              ),
              const SizedBox(height: 18),
              Text(
                strings.todayOverview,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.18,
                children: [
                  SummaryCard(
                    title: strings.pending,
                    value: pending.toString(),
                    icon: Icons.schedule,
                    accentColor: AppColors.warningYellow,
                  ),
                  SummaryCard(
                    title: strings.inProgress,
                    value: inProgress.toString(),
                    icon: Icons.sync,
                    accentColor: AppColors.supportBlue,
                  ),
                  SummaryCard(
                    title: strings.completed,
                    value: completed.toString(),
                    icon: Icons.check_circle_outline,
                    accentColor: AppColors.successGreen,
                  ),
                  SummaryCard(
                    title: strings.expectedValue,
                    value: money(dataController.totalExpectedValue),
                    icon: Icons.payments_outlined,
                    accentColor: AppColors.primaryBlue,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              QuickActionsSection(
                strings: strings,
                onNewClient: () => _openClientForm(context),
                onNewService: () => _openServiceForm(context),
                onSeePending: () {},
              ),
              const SizedBox(height: 22),
              _SectionHeader(
                title: strings.priorityList,
                actionLabel: strings.seePending,
              ),
              const SizedBox(height: 10),
              if (dataController.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (priorityServices.isEmpty)
                EmptyState(
                  icon: Icons.assignment_turned_in_outlined,
                  title: strings.noPendingServicesTitle,
                  description: strings.noPendingServicesDescription,
                )
              else
                ...priorityServices.map(
                  (service) {
                    final customer = dataController.customerById(
                      service.customerId,
                    );
                    if (customer == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ServicePreviewTile(
                        service: service,
                        customer: customer,
                        strings: strings,
                      ),
                    );
                  },
                ),
            ]),
          ),
        ),
      ],
    );
  }

  void _openClientForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClientFormPage(
          strings: strings,
          dataController: dataController,
        ),
      ),
    );
  }

  void _openServiceForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ServiceFormPage(
          strings: strings,
          dataController: dataController,
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.strings,
    required this.onNewClient,
    required this.onNewService,
  });

  final AppStrings strings;
  final VoidCallback onNewClient;
  final VoidCallback onNewService;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.welcomeTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.welcomeSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.84),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroActionButton(
                label: strings.newService,
                icon: Icons.add_task,
                onPressed: onNewService,
                filled: true,
              ),
              _HeroActionButton(
                label: strings.newClient,
                icon: Icons.person_add_alt,
                onPressed: onNewClient,
                filled: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.filled,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = filled
        ? FilledButton.styleFrom(
            backgroundColor: colorScheme.onPrimary,
            foregroundColor: colorScheme.primary,
          )
        : OutlinedButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            side: BorderSide(
              color: colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          );

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(label),
      ],
    );

    return filled
        ? FilledButton(onPressed: onPressed, style: style, child: child)
        : OutlinedButton(onPressed: onPressed, style: style, child: child);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionLabel});

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        TextButton(onPressed: () {}, child: Text(actionLabel)),
      ],
    );
  }
}
