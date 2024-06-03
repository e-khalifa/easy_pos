import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  String label;
  String value;
  HeaderCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color.fromARGB(255, 32, 109, 225),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 220, 252, 255),
                fontSize: 16,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Color.fromARGB(255, 152, 196, 253),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
