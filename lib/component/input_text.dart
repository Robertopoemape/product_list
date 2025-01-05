import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText({
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    super.key,
  });
  final String labelText;
  final String hintText;
  final ValueChanged<String?> onChanged;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final TextEditingController _controller = TextEditingController();

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
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              // Llama a onChanged cuando se pierde el foco
              widget.onChanged(_controller.text);
            }
          },
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(10),
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }
}
