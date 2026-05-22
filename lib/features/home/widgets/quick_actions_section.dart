import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    required this.strings,
    required this.onNewClient,
    required this.onNewService,
    required this.onSeePending,
  });

  final AppStrings strings;
  final VoidCallback onNewClient;
  final VoidCallback onNewService;
  final VoidCallback onSeePending;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        label: strings.newClient,
        icon: Icons.person_add_alt,
        onTap: onNewClient,
      ),
      _QuickAction(
        label: strings.newService,
        icon: Icons.add_task,
        onTap: onNewService,
      ),
      _QuickAction(
        label: strings.seePending,
        icon: Icons.pending_actions,
        onTap: onSeePending,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.quickActions,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Row(
          children: actions
              .map(
                (action) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _QuickActionCard(action: action),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: action.onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(action.icon, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}
