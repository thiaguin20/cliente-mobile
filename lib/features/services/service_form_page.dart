import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../data/app_data_controller.dart';
import '../../data/models/service.dart';
import '../../data/models/service_status.dart';

class ServiceFormPage extends StatefulWidget {
  const ServiceFormPage({
    super.key,
    required this.strings,
    required this.dataController,
    this.service,
    this.initialCustomerId,
  });

  final AppStrings strings;
  final AppDataController dataController;
  final ClientService? service;
  final int? initialCustomerId;

  @override
  State<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startDateController;
  late final TextEditingController _expectedEndDateController;
  late final TextEditingController _valueController;
  int? _customerId;
  late ServiceStatus _status;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    _customerId =
        service?.customerId ?? widget.initialCustomerId ?? _firstCustomerId();
    _status = service?.status ?? ServiceStatus.pending;
    _titleController = TextEditingController(text: service?.title ?? '');
    _descriptionController =
        TextEditingController(text: service?.description ?? '');
    _startDateController = TextEditingController(
      text: service == null ? dateInput(DateTime.now()) : dateInput(service.startDate),
    );
    _expectedEndDateController = TextEditingController(
      text: service?.expectedEndDate == null ? '' : dateInput(service!.expectedEndDate!),
    );
    _valueController = TextEditingController(
      text: service == null ? '' : service.value.toStringAsFixed(2).replaceAll('.', ','),
    );
  }

  int? _firstCustomerId() {
    if (widget.dataController.customers.isEmpty) {
      return null;
    }
    return widget.dataController.customers.first.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _expectedEndDateController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final isEditing = widget.service != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? strings.edit : strings.newService),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: strings.delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            96 + MediaQuery.of(context).padding.bottom,
          ),
          children: [
            _FormSection(
              title: strings.serviceInfo,
              children: [
                AppTextField(
                  controller: _titleController,
                  label: strings.serviceTitle,
                  helperText: strings.requiredLabel,
                  prefixIcon: Icons.assignment_outlined,
                  validator: _required,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _customerId,
                  decoration: InputDecoration(
                    labelText: strings.linkedCustomer,
                    helperText: strings.requiredLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  items: widget.dataController.customers
                      .map(
                        (customer) => DropdownMenuItem<int>(
                          value: customer.id!,
                          child: Text(customer.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _customerId = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? strings.selectCustomer : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _descriptionController,
                  label: strings.description,
                  helperText: strings.optionalLabel,
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ServiceStatus>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: strings.status,
                    helperText: strings.requiredLabel,
                    prefixIcon: const Icon(Icons.flag_outlined),
                  ),
                  items: ServiceStatus.values
                      .map(
                        (status) => DropdownMenuItem<ServiceStatus>(
                          value: status,
                          child: Text(strings.statusLabel(status.key)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _status = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            _FormSection(
              title: strings.scheduleInfo,
              children: [
                AppTextField(
                  controller: _startDateController,
                  label: strings.startDate,
                  hint: strings.dateHint,
                  helperText: strings.requiredLabel,
                  prefixIcon: Icons.event_outlined,
                  keyboardType: TextInputType.datetime,
                  validator: _dateRequired,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _expectedEndDateController,
                  label: strings.expectedEndDate,
                  hint: strings.dateHint,
                  helperText: strings.optionalLabel,
                  prefixIcon: Icons.event_available_outlined,
                  keyboardType: TextInputType.datetime,
                  validator: _optionalDate,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _valueController,
                  label: strings.value,
                  helperText: strings.requiredLabel,
                  prefixIcon: Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                  validator: _numberRequired,
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppButton.primary(
              label: _isSaving ? strings.saving : strings.save,
              icon: Icons.save_outlined,
              onPressed: _isSaving ? null : _save,
            ),
            if (isEditing) ...[
              const SizedBox(height: 12),
              AppButton.danger(
                label: strings.deleteThisService,
                icon: Icons.delete_outline,
                onPressed: _isSaving ? null : _confirmDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return widget.strings.requiredField;
    }
    return null;
  }

  String? _dateRequired(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) {
      return requiredError;
    }
    return _parseDate(value!) == null ? widget.strings.invalidDate : null;
  }

  String? _optionalDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return _parseDate(value) == null ? widget.strings.invalidDate : null;
  }

  String? _numberRequired(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) {
      return requiredError;
    }
    return _parseMoney(value!) == null ? widget.strings.requiredField : null;
  }

  DateTime? _parseDate(String value) {
    final parts = value.trim().split('/');
    if (parts.length != 3) {
      return null;
    }
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      return null;
    }
    try {
      final parsed = DateTime(year, month, day);
      if (parsed.day != day || parsed.month != month || parsed.year != year) {
        return null;
      }
      return parsed;
    } catch (_) {
      return null;
    }
  }

  double? _parseMoney(String value) {
    return double.tryParse(
      value.trim().replaceAll('.', '').replaceAll(',', '.'),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final oldService = widget.service;
    if (oldService?.status == ServiceStatus.completed &&
        _status != ServiceStatus.completed) {
      final confirmed = await showConfirmDialog(
        context: context,
        title: widget.strings.changeCompletedTitle,
        message: widget.strings.changeCompletedMessage,
        confirmLabel: widget.strings.confirm,
        cancelLabel: widget.strings.cancel,
      );
      if (confirmed != true) {
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    final service = ClientService(
      id: oldService?.id,
      customerId: _customerId!,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _status,
      startDate: _parseDate(_startDateController.text)!,
      expectedEndDate: _expectedEndDateController.text.trim().isEmpty
          ? null
          : _parseDate(_expectedEndDateController.text),
      value: _parseMoney(_valueController.text)!,
      updatedAt: oldService?.updatedAt ?? DateTime.now(),
    );

    await widget.dataController.saveService(service);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmDelete() async {
    final service = widget.service;
    if (service?.id == null) {
      return;
    }

    final confirmed = await showConfirmDialog(
      context: context,
      title: widget.strings.deleteServiceTitle,
      message: widget.strings.deleteServiceMessage,
      confirmLabel: widget.strings.delete,
      cancelLabel: widget.strings.cancel,
    );

    if (confirmed != true) {
      return;
    }

    await widget.dataController.deleteService(service!.id!);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}
