import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/app_data_controller.dart';
import 'client_detail_page.dart';
import 'client_form_page.dart';
import 'widgets/client_card.dart';
import 'widgets/client_search_bar.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({
    super.key,
    required this.strings,
    required this.dataController,
  });

  final AppStrings strings;
  final AppDataController dataController;

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final dataController = widget.dataController;
    final customers = dataController.customers.where((customer) {
      final query = _query.toLowerCase().trim();
      if (query.isEmpty) {
        return true;
      }
      return customer.name.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query);
    }).toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text(strings.clients)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.person_add_alt),
        label: Text(strings.newClient),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          ClientSearchBar(
            hint: strings.searchClients,
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
          ),
          const SizedBox(height: 16),
          if (dataController.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (customers.isEmpty)
            EmptyState(
              icon: Icons.people_outline,
              title: strings.noCustomersTitle,
              description: strings.noCustomersDescription,
            )
          else
            ...customers.map(
              (customer) {
                final services = dataController.servicesByCustomer(
                  customer.id!,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClientCard(
                    customer: customer,
                    serviceCount: services.length,
                    totalValue: services.fold(
                      0,
                      (total, service) => total + service.value,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ClientDetailPage(
                            strings: strings,
                            dataController: dataController,
                            customer: customer,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClientFormPage(
          strings: widget.strings,
          dataController: widget.dataController,
        ),
      ),
    );
  }
}
