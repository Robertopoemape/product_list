import 'package:flutter/material.dart';

class FloatingAdd extends StatelessWidget {
  const FloatingAdd({required this.onPressedAdd, super.key});
  final VoidCallback onPressedAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Column(
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green.shade400,
            shape: CircleBorder(
              side: BorderSide(color: Colors.green.shade700, width: 4),
            ),
            onPressed: onPressedAdd,
            child: const Icon(
              Icons.add,
            ),
          ),
          const Text(
            'Agregar',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
