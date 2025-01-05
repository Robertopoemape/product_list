import 'package:flutter/material.dart';
import 'package:product_list/component/input_dropdown.dart';
import 'package:product_list/component/input_text.dart';
import 'package:product_list/presentation/buy_cart/widgets/buy_success.dart';
import 'package:product_list/presentation/product/model/product.dart';
import 'package:provider/provider.dart';

import '../widgets/floating_total.dart';
import '../widgets/shopping_cart_list.dart';
import 'buy_cart_vm.dart';

class BuyCartScreen extends StatelessWidget {
  const BuyCartScreen({
    required this.products,
    required this.total,
    super.key,
  });

  final List<Product> products;
  final double total;
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<BuyCartViewModel>(
        create: (BuildContext screenContext) => BuyCartViewModel(total: total),
        child: Consumer<BuyCartViewModel>(
          builder: (_, BuyCartViewModel viewModel, __) =>
              _buildBody(context, viewModel),
        ),
      );
  Widget _buildBody(BuildContext context, BuyCartViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade400,
        title: Text(
          'Carrito de compras',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (products.isEmpty) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 300),
                        child: Text(
                          'Agregue una cantidad al carrito',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ] else ...[
                    ShoppingCartList(
                      products: products,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Datos de compra',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 16),
                          InputDropdown(
                            hintText: 'Seleccione un método de pago',
                            labelText: 'Método de pago',
                            onChanged: (value) {
                              viewModel.paymentMethod = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          InputText(
                            labelText: 'Nombre',
                            hintText: 'Ingrese su texto aquí',
                            onChanged: (value) {
                              viewModel.userName = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          InputText(
                            labelText: 'Teléfono',
                            hintText: 'Ingrese su texto aquí',
                            onChanged: (value) {
                              viewModel.userPhone = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : viewModel.getLocation,
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.black,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  viewModel.location ?? 'Obtener ubicación',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text('Foto de la fachada'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: viewModel.pickImage,
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                viewModel.image != null ? '' : 'Tomar foto',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          viewModel.image != null
                              ? Image.file(viewModel.image!)
                              : const SizedBox.shrink(),
                          const SizedBox(height: 16)
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (products.isNotEmpty)
            FloatingTotal(
              total: total,
              onPressed: () async {
                // Llamamos a createOrder, que devuelve un Future<bool>
                Future<bool> orderFuture = viewModel.createOrder();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder<bool>(
                      future: orderFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError ||
                            !snapshot.hasData ||
                            !snapshot.data!) {
                          return BuySuccess(
                            error: true,
                            onPessedReturnHome: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          return const BuySuccess(
                            error: false,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
