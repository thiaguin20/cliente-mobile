import 'package:flutter/material.dart';

class ClientSearchBar extends StatelessWidget {
  const ClientSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hint,
      leading: const Icon(Icons.search),
      onChanged: onChanged,
      elevation: const WidgetStatePropertyAll(0),
      side: WidgetStatePropertyAll(
        BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }
}
