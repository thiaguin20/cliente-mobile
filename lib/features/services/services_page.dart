import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/app_data_controller.dart';
import '../../data/models/service.dart';
import '../../data/models/service_status.dart';
import '../home/widgets/service_preview_tile.dart';
import 'service_form_page.dart';
import 'widgets/service_status_filter.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({
    super.key,
    required this.strings,
    required this.dataController,
  });

  final AppStrings strings;
  final AppDataController dataController;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  ServiceStatus? _selectedStatus;
  int? _selectedCustomerId;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final services = widget.dataController.services.where((service) {
      final matchesStatus =
          _selectedStatus == null || service.status == _selectedStatus;
      final matchesCustomer = _selectedCustomerId == null ||
          service.customerId == _selectedCustomerId;
      final matchesQuery = _query.trim().isEmpty ||
          service.title.toLowerCase().contains(_query.toLowerCase().trim());
      return matchesStatus && matchesCustomer && matchesQuery;
    }).toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.strings.services)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_task),
        label: Text(widget.strings.newService),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          SearchBar(
            hintText: widget.strings.searchServices,
            leading: const Icon(Icons.search),
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
            elevation: const WidgetStatePropertyAll(0),
            side: WidgetStatePropertyAll(
              BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
          ),
          const SizedBox(height: 14),
          ServiceStatusFilter(
            strings: widget.strings,
            selectedStatus: _selectedStatus,
            onChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            value: _selectedCustomerId,
            decoration: InputDecoration(
              labelText: widget.strings.filterByCustomer,
            ),
            items: [
              DropdownMenuItem<int?>(
                value: null,
                child: Text(widget.strings.all),
              ),
              ...widget.dataController.customers.map(
                (customer) => DropdownMenuItem<int?>(
                  value: customer.id,
                  child: Text(customer.name),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCustomerId = value;
              });
            },
          ),
          const SizedBox(height: 16),
          if (widget.dataController.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (services.isEmpty)
            EmptyState(
              icon: Icons.assignment_outlined,
              title: widget.strings.noServicesTitle,
              description: widget.strings.noServicesDescription,
            )
          else
            ...services.map(
              (service) {
                final customer = widget.dataController.customerById(
                  service.customerId,
                );
                if (customer == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ServicePreviewTile(
                    service: service,
                    customer: customer,
                    strings: widget.strings,
                    onTap: () => _openForm(context, service: service),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, {ClientService? service}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ServiceFormPage(
          strings: widget.strings,
          dataController: widget.dataController,
          service: service,
        ),
      ),
    );
  }
}
