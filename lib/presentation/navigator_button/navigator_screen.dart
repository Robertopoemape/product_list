import 'package:flutter/material.dart';
import 'package:product_list/presentation/product/view/product_screen.dart';

class NavigatorScreen extends StatelessWidget {
  const NavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductScreen()),
            );
          },
          child: const Text('Lista de productos'),
        ),
      ),
    );
  }
}
