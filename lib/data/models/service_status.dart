enum ServiceStatus {
  pending('pending'),
  inProgress('inProgress'),
  completed('completed');

  const ServiceStatus(this.key);

  final String key;

  static ServiceStatus fromKey(String key) {
    return ServiceStatus.values.firstWhere(
      (status) => status.key == key,
      orElse: () => ServiceStatus.pending,
    );
  }
}
