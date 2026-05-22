String money(double value) {
  final fixed = value.toStringAsFixed(2).replaceAll('.', ',');
  final parts = fixed.split(',');
  final integer = parts.first;
  final cents = parts.last;
  final buffer = StringBuffer();

  for (var index = 0; index < integer.length; index++) {
    final reverseIndex = integer.length - index;
    buffer.write(integer[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'R\$ $buffer,$cents';
}

String shortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month';
}

String dateInput(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
