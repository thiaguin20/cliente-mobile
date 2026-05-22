import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/customer.dart';
import '../../../data/models/service.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.customer,
    required this.strings,
    required this.onTap,
  });

  final ClientService service;
  final Customer customer;
  final AppStrings strings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      service.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  StatusBadge(status: service.status, strings: strings),
                ],
              ),
              const SizedBox(height: 6),
              Text(customer.name),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(shortDate(service.startDate)),
                  const Spacer(),
                  Text(
                    money(service.value),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
