import 'package:flutter/material.dart';

class AppSearchField extends StatefulWidget {
  final ValueChanged<String> onSearchTextChanged;

  const AppSearchField({super.key, required this.onSearchTextChanged});

  @override
  _AppSearchFieldState createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onSearchTextChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        labelText: 'Search',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
