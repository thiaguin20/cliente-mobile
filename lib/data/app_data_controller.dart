import 'package:flutter/material.dart';

import 'database/app_database.dart';
import 'models/customer.dart';
import 'models/service.dart';
import 'models/service_status.dart';
import 'repositories/client_repository.dart';
import 'repositories/service_repository.dart';

class AppDataController extends ChangeNotifier {
  AppDataController()
      : _database = AppDatabase(),
        customers = const <Customer>[],
        services = const <ClientService>[] {
    _clientRepository = ClientRepository(_database);
    _serviceRepository = ServiceRepository(_database);
  }

  final AppDatabase _database;
  late final ClientRepository _clientRepository;
  late final ServiceRepository _serviceRepository;

  List<Customer> customers;
  List<ClientService> services;
  bool isLoading = true;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    customers = await _clientRepository.getAll();
    services = await _serviceRepository.getAll();
    isLoading = false;
    notifyListeners();
  }

  Customer? customerById(int id) {
    for (final customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }
    return null;
  }

  bool hasDuplicatedCustomerContact({
    required String email,
    required String phone,
    int? ignoringId,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPhone = phone.trim();

    if (normalizedEmail.isEmpty && normalizedPhone.isEmpty) {
      return false;
    }

    return customers.any((customer) {
      if (customer.id == ignoringId) {
        return false;
      }
      final sameEmail = normalizedEmail.isNotEmpty &&
          customer.email.trim().toLowerCase() == normalizedEmail;
      final samePhone =
          normalizedPhone.isNotEmpty && customer.phone.trim() == normalizedPhone;
      return sameEmail || samePhone;
    });
  }

  List<ClientService> servicesByCustomer(int customerId) {
    return services
        .where((service) => service.customerId == customerId)
        .toList(growable: false);
  }

  int countByStatus(ServiceStatus status) {
    return services.where((service) => service.status == status).length;
  }

  double valueByStatus(ServiceStatus status) {
    return services
        .where((service) => service.status == status)
        .fold(0, (total, service) => total + service.value);
  }

  double get totalExpectedValue {
    return services.fold(0, (total, service) => total + service.value);
  }

  Future<void> saveCustomer(Customer customer) async {
    if (customer.id == null) {
      await _clientRepository.insert(customer);
    } else {
      await _clientRepository.update(customer);
    }
    await load();
  }

  Future<void> deleteCustomer(int id) async {
    await _clientRepository.delete(id);
    await load();
  }

  Future<void> saveService(ClientService service) async {
    final serviceToSave = service.copyWith(updatedAt: DateTime.now());
    if (serviceToSave.id == null) {
      await _serviceRepository.insert(serviceToSave);
    } else {
      await _serviceRepository.update(serviceToSave);
    }
    await load();
  }

  Future<void> deleteService(int id) async {
    await _serviceRepository.delete(id);
    await load();
  }
}
