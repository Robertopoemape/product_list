import 'package:flutter/material.dart';
import 'package:product_list/presentation/product/widgets/quantity_selector.dart';
import 'package:product_list/presentation/product/view/product_vm.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    required this.products,
    required this.controller,
    super.key,
  });

  final List<Product> products;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          controller: controller,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final viewModel =
                Provider.of<ProductViewModel>(context, listen: false);
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/img/not_image.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(product.description,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Precio: S/ ${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Stock: ${product.stock}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      QuantitySelector(
                        quantity: product.quantity,
                        onChangedMinus: () =>
                            viewModel.decreaseQuantity(product),
                        onChangedAdd: () =>
                            viewModel.incrementQuantity(product),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
