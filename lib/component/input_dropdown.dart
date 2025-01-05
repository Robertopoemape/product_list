import 'package:flutter/material.dart';

class InputDropdown extends StatefulWidget {
  const InputDropdown({
    required this.hintText,
    required this.labelText,
    required this.onChanged,
    super.key,
  });

  final String hintText;
  final String labelText;
  final ValueChanged<String?> onChanged;

  @override
  State<InputDropdown> createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  final List<String> paymentMethods = ['cash', 'credit-card', 'debit-card'];
  String? selectedPaymentMethod;

  String _getPaymentMethodLabel(String method) {
    switch (method) {
      case 'cash':
        return 'Efectivo';
      case 'credit-card':
        return 'Tarjeta de Crédito';
      case 'debit-card':
        return 'Tarjeta de Débito';
      default:
        return method;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
          hint: Center(
            child: Text(
              widget.hintText,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          value: selectedPaymentMethod,
          items: paymentMethods.map((method) {
            return DropdownMenuItem<String>(
              value: method,
              child: Text(_getPaymentMethodLabel(method)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedPaymentMethod = value;
            });
            widget.onChanged(value);
          },
          validator: (value) =>
              value == null ? 'Seleccione un método de pago' : null,
        ),
      ],
    );
  }
}
