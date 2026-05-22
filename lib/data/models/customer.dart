class Customer {
  const Customer({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.address,
    required this.notes,
    required this.createdAt,
  });

  final int? id;
  final String name;
  final String phone;
  final String email;
  final String city;
  final String address;
  final String notes;
  final DateTime createdAt;

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? city,
    String? address,
    String? notes,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      city: city ?? this.city,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'city': city,
      'address': address,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static Customer fromMap(Map<String, Object?> map) {
    return Customer(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      city: map['city'] as String,
      address: map['address'] as String,
      notes: map['notes'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
