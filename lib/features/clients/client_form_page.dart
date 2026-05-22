import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../data/app_data_controller.dart';
import '../../data/models/customer.dart';

class ClientFormPage extends StatefulWidget {
  const ClientFormPage({
    super.key,
    required this.strings,
    required this.dataController,
    this.customer,
  });

  final AppStrings strings;
  final AppDataController dataController;
  final Customer? customer;

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _notesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _nameController = TextEditingController(text: customer?.name ?? '');
    _phoneController = TextEditingController(text: customer?.phone ?? '');
    _emailController = TextEditingController(text: customer?.email ?? '');
    _addressController = TextEditingController(text: customer?.address ?? '');
    _cityController = TextEditingController(text: customer?.city ?? '');
    _notesController = TextEditingController(text: customer?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final isEditing = widget.customer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? strings.edit : strings.newClient),
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
              title: strings.mainInfo,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: strings.fullName,
                  helperText: strings.requiredLabel,
                  prefixIcon: Icons.person_outline,
                  validator: _required,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _notesController,
                  label: strings.notes,
                  helperText: strings.optionalLabel,
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 4,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _FormSection(
              title: strings.contactInfo,
              children: [
                AppTextField(
                  controller: _phoneController,
                  label: strings.phoneWhatsapp,
                  helperText: strings.optionalLabel,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _emailController,
                  label: strings.email,
                  helperText: strings.optionalLabel,
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: _optionalEmailValidator,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _addressController,
                  label: strings.address,
                  helperText: strings.optionalLabel,
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _cityController,
                  label: strings.city,
                  helperText: strings.optionalLabel,
                  prefixIcon: Icons.location_city_outlined,
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
                label: strings.deleteThisCustomer,
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

  String? _optionalEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final email = value.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return widget.strings.invalidEmail;
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    if (widget.dataController.hasDuplicatedCustomerContact(
      email: _emailController.text,
      phone: _phoneController.text,
      ignoringId: widget.customer?.id,
    )) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.strings.duplicatedCustomer)),
      );
      return;
    }

    final customer = Customer(
      id: widget.customer?.id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      notes: _notesController.text.trim(),
      createdAt: widget.customer?.createdAt ?? DateTime.now(),
    );

    await widget.dataController.saveCustomer(customer);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmDelete() async {
    final customer = widget.customer;
    if (customer?.id == null) {
      return;
    }

    final confirmed = await showConfirmDialog(
      context: context,
      title: widget.strings.deleteCustomerTitle,
      message: widget.strings.deleteCustomerMessage,
      confirmLabel: widget.strings.delete,
      cancelLabel: widget.strings.cancel,
    );

    if (confirmed != true) {
      return;
    }

    await widget.dataController.deleteCustomer(customer!.id!);
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
