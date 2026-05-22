import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/app_data_controller.dart';
import '../../data/models/customer.dart';
import '../../data/models/service.dart';
import '../home/widgets/service_preview_tile.dart';
import '../services/service_form_page.dart';
import 'client_form_page.dart';

class ClientDetailPage extends StatelessWidget {
  const ClientDetailPage({
    super.key,
    required this.strings,
    required this.dataController,
    required this.customer,
  });

  final AppStrings strings;
  final AppDataController dataController;
  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final currentCustomer = dataController.customerById(customer.id!) ?? customer;
    final services = dataController.servicesByCustomer(currentCustomer.id!);
    final total = services.fold(0.0, (sum, service) => sum + service.value);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.customerDetail),
        actions: [
          IconButton(
            onPressed: () => _openEdit(context, currentCustomer),
            icon: const Icon(Icons.edit_outlined),
            tooltip: strings.edit,
          ),
          IconButton(
            onPressed: () => _confirmDelete(context, currentCustomer),
            icon: const Icon(Icons.delete_outline),
            tooltip: strings.delete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentCustomer.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(currentCustomer.phone),
                  Text(currentCustomer.email),
                  if (currentCustomer.city.isNotEmpty) Text(currentCustomer.city),
                  if (currentCustomer.address.isNotEmpty)
                    Text(currentCustomer.address),
                  const SizedBox(height: 16),
                  Text(
                    strings.notes,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentCustomer.notes.isEmpty
                        ? '-'
                        : currentCustomer.notes,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.totalByCustomer),
                  const SizedBox(height: 6),
                  Text(
                    money(total),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton.primary(
            label: strings.newService,
            icon: Icons.add_task,
            onPressed: () => _openServiceForm(context, currentCustomer),
          ),
          const SizedBox(height: 20),
          Text(
            strings.linkedServices,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          if (services.isEmpty)
            EmptyState(
              icon: Icons.assignment_outlined,
              title: strings.noServicesTitle,
              description: strings.noServicesDescription,
            )
          else
            ...services.map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ServicePreviewTile(
                  service: service,
                  customer: currentCustomer,
                  strings: strings,
                  onTap: () => _openServiceForm(
                    context,
                    currentCustomer,
                    service: service,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openEdit(BuildContext context, Customer customer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClientFormPage(
          strings: strings,
          dataController: dataController,
          customer: customer,
        ),
      ),
    );
  }

  void _openServiceForm(
    BuildContext context,
    Customer customer, {
    ClientService? service,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ServiceFormPage(
          strings: strings,
          dataController: dataController,
          service: service,
          initialCustomerId: customer.id,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Customer customer) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: strings.deleteCustomerTitle,
      message: strings.deleteCustomerMessage,
      confirmLabel: strings.delete,
      cancelLabel: strings.cancel,
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await dataController.deleteCustomer(customer.id!);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
