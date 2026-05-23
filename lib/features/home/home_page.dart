import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/app_data_controller.dart';
import '../../data/models/service_status.dart';
import '../clients/client_form_page.dart';
import '../services/service_form_page.dart';
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
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(child: _AppIdentityIcon(tooltip: strings.appName)),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _HomeHeader(
                strings: strings,
                onNewClient: () => _openClientForm(context),
                onNewService: () => _openServiceForm(context),
              ),
              const SizedBox(height: 24),
              _MetricCarousel(
                strings: strings,
                pending: pending,
                inProgress: inProgress,
                completed: completed,
                totalValue: dataController.totalExpectedValue,
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: strings.priorityList),
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.todayOverview,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                strings.welcomeSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;
            if (compact) {
              return Column(
                children: [
                  _HomeActionPill(
                    label: strings.newService,
                    icon: Icons.add_task,
                    onTap: onNewService,
                    filled: true,
                  ),
                  const SizedBox(height: 10),
                  _HomeActionPill(
                    label: strings.newClient,
                    icon: Icons.person_add_alt,
                    onTap: onNewClient,
                    filled: false,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _HomeActionPill(
                    label: strings.newService,
                    icon: Icons.add_task,
                    onTap: onNewService,
                    filled: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HomeActionPill(
                    label: strings.newClient,
                    icon: Icons.person_add_alt,
                    onTap: onNewClient,
                    filled: false,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AppIdentityIcon extends StatelessWidget {
  const _AppIdentityIcon({required this.tooltip});

  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          Icons.assignment_ind_outlined,
          color: colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }
}

class _HomeActionPill extends StatelessWidget {
  const _HomeActionPill({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = filled
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35);
    final foreground = filled ? colorScheme.onPrimary : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 50),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: filled
                    ? colorScheme.primary
                    : colorScheme.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCarousel extends StatefulWidget {
  const _MetricCarousel({
    required this.strings,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.totalValue,
  });

  final AppStrings strings;
  final int pending;
  final int inProgress;
  final int completed;
  final double totalValue;

  @override
  State<_MetricCarousel> createState() => _MetricCarouselState();
}

class _MetricCarouselState extends State<_MetricCarousel> {
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 45), (_) {
      if (!_scrollController.hasClients) {
        return;
      }

      final position = _scrollController.position;
      if (position.maxScrollExtent <= 0) {
        return;
      }

      final nextOffset = _scrollController.offset + 0.35;
      if (nextOffset >= position.maxScrollExtent) {
        _scrollController.jumpTo(0);
        return;
      }

      _scrollController.jumpTo(nextOffset);
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final tileWidth = compact ? 162.0 : 176.0;
    final openServices = widget.pending + widget.inProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricTile.wide(
          title: widget.strings.openServices,
          value: openServices.toString(),
          subtitle:
              '${widget.pending} ${widget.strings.pending} - ${widget.inProgress} ${widget.strings.inProgress}',
          icon: Icons.pending_actions_outlined,
          color: Theme.of(context).colorScheme.primary,
          compact: compact,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: compact ? 154 : 146,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _MetricTile(
                width: tileWidth,
                title: widget.strings.expectedValue,
                value: money(widget.totalValue),
                subtitle: widget.strings.monthlyResult,
                icon: Icons.payments_outlined,
                color: AppColors.primaryBlue,
                compact: compact,
              ),
              _MetricTile(
                width: tileWidth,
                title: widget.strings.completed,
                value: widget.completed.toString(),
                subtitle: widget.strings.completedValue,
                icon: Icons.check_circle_outline,
                color: AppColors.successGreen,
                compact: compact,
              ),
              _MetricTile(
                width: tileWidth,
                title: widget.strings.pending,
                value: widget.pending.toString(),
                subtitle: widget.strings.seePending,
                icon: Icons.schedule,
                color: AppColors.warningYellow,
                compact: compact,
              ),
              _MetricTile(
                width: tileWidth,
                title: widget.strings.inProgress,
                value: widget.inProgress.toString(),
                subtitle: widget.strings.totalServices,
                icon: Icons.sync,
                color: AppColors.supportBlue,
                compact: compact,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.width,
    this.compact = false,
  }) : isWide = false;

  const _MetricTile.wide({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.compact = false,
  }) : width = null,
       isWide = true;

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double? width;
  final bool compact;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: isWide ? double.infinity : width,
      height: isWide ? (compact ? 124 : 118) : null,
      margin: EdgeInsets.only(right: isWide ? 0 : 12),
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: isWide
          ? Row(
              children: [
                _MetricIcon(icon: icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricText(
                    title: title,
                    value: value,
                    subtitle: subtitle,
                    compact: compact,
                    valueStyle: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MetricIcon(icon: icon, color: color),
                SizedBox(height: compact ? 10 : 14),
                _MetricText(
                  title: title,
                  value: value,
                  subtitle: subtitle,
                  compact: compact,
                  showSubtitle: !compact,
                  valueStyle: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
    );
  }
}

class _MetricIcon extends StatelessWidget {
  const _MetricIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 19, color: color),
    );
  }
}

class _MetricText extends StatelessWidget {
  const _MetricText({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueStyle,
    this.compact = false,
    this.showSubtitle = true,
  });

  final String title;
  final String value;
  final String subtitle;
  final TextStyle? valueStyle;
  final bool compact;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: valueStyle?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        SizedBox(height: compact ? 2 : 3),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
        ),
        if (showSubtitle) ...[
          SizedBox(height: compact ? 1 : 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.1,
                ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}
