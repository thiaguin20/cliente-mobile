import 'service_status.dart';

class ClientService {
  const ClientService({
    this.id,
    required this.customerId,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.expectedEndDate,
    required this.value,
    required this.updatedAt,
  });

  final int? id;
  final int customerId;
  final String title;
  final String description;
  final ServiceStatus status;
  final DateTime startDate;
  final DateTime? expectedEndDate;
  final double value;
  final DateTime updatedAt;

  ClientService copyWith({
    int? id,
    int? customerId,
    String? title,
    String? description,
    ServiceStatus? status,
    DateTime? startDate,
    DateTime? expectedEndDate,
    bool clearExpectedEndDate = false,
    double? value,
    DateTime? updatedAt,
  }) {
    return ClientService(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      expectedEndDate:
          clearExpectedEndDate ? null : expectedEndDate ?? this.expectedEndDate,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'title': title,
      'description': description,
      'status': status.key,
      'start_date': startDate.toIso8601String(),
      'expected_end_date': expectedEndDate?.toIso8601String(),
      'value': value,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static ClientService fromMap(Map<String, Object?> map) {
    return ClientService(
      id: map['id'] as int?,
      customerId: map['customer_id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      status: ServiceStatus.fromKey(map['status'] as String),
      startDate: DateTime.parse(map['start_date'] as String),
      expectedEndDate: map['expected_end_date'] == null
          ? null
          : DateTime.parse(map['expected_end_date'] as String),
      value: (map['value'] as num).toDouble(),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
