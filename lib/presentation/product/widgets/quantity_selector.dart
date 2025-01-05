import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChangedMinus,
    required this.onChangedAdd,
  });
  final int quantity;
  final VoidCallback onChangedMinus;
  final VoidCallback onChangedAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          if (quantity != 0) ...[
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                size: 35,
              ),
              onPressed: onChangedMinus,
            ),
            const SizedBox(width: 8),
            Text(
              quantity.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            icon: const Icon(
              Icons.add_circle_outlined,
              size: 35,
            ),
            onPressed: onChangedAdd,
          ),
        ],
      ),
    );
  }
}
