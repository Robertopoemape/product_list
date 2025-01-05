import 'package:flutter/material.dart';
import 'package:product_list/presentation/product/widgets/show_dialog_message.dart';
import 'package:provider/provider.dart';

import '../../buy_cart/view/buy_cart_screen.dart';
import '../widgets/floating_add.dart';
import '../widgets/image_container.dart';
import '../widgets/product_list.dart';
import 'product_vm.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<ProductViewModel>(
        create: (BuildContext screenContext) => ProductViewModel(),
        child: Consumer<ProductViewModel>(
          builder: (_, ProductViewModel viewModel, __) =>
              _buildBody(context, viewModel),
        ),
      );

  Widget _buildBody(BuildContext context, ProductViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingAdd(
        onPressedAdd: () {
          viewModel.onPressedAdd();
          if (viewModel.hasStockIssues) {
            showDialogMessage(
              context: context,
              message: 'No hay stock suficiente',
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyCartScreen(
                  products: viewModel.products
                      .where((product) => product.quantity > 0)
                      .toList(),
                  total: viewModel.totalSum(),
                ),
              ),
            );
          }
        },
      ),
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
          'Bodega Digital',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const ImageContainer(
                title: 'Lista de productos',
                image: 'assets/img/market.png',
              ),
              ProductList(
                products: viewModel.products,
                controller: viewModel.scrollController,
              ),
              const SizedBox(height: 80)
            ],
          ),
          if (viewModel.isLoading)
            const Positioned(
              top: 120,
              bottom: 0,
              right: 0,
              left: 0,
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
