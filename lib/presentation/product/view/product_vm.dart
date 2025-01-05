import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product.dart';

class ProductViewModel extends ChangeNotifier {
  ProductViewModel() {
    initState();
  }

  final ScrollController scrollController = ScrollController();
  final List<Product> _products = [];
  bool hasStockIssues = false;
  bool hasMoreProducts = true;
  bool isLoading = false;
  int page = 1;
  final int pageSize = 5;

  List<Product> get products => _products;

  void initState() {
    getListProducts();
    loadCart();
    scrollController.addListener(_scrollListener);
  }

  Future<void> getListProducts() async {
    if (!hasMoreProducts || isLoading) return;

    isLoading = true;

    try {
      final response = await http.get(Uri.parse(
          'https://shop-api-roan.vercel.app/product?page=$page&pageSize=$pageSize'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data.isEmpty || data.length < pageSize) {
          hasMoreProducts = false;
        }

        _products.addAll(
          data.map((product) => Product.fromJson(product)).toList(),
        );
      } else {
        log('Error: Falló la carga de productos con código ${response.statusCode}');
      }
    } catch (error) {
      log('Error en la solicitud de productos: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _scrollListener() {
    if (_isEndOfPage() && hasMoreProducts) {
      pageNext();
    }
  }

  bool _isEndOfPage() {
    return scrollController.position.pixels ==
        scrollController.position.maxScrollExtent;
  }

  void pageNext() {
    page++;
    getListProducts();
  }

  void incrementQuantity(Product product) {
    product.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    if (product.quantity > 0) {
      product.quantity--;

      // Si la cantidad es cero, actualiza el carrito en SharedPreferences
      if (product.quantity == 0) {
        _saveCart(products.where((p) => p.quantity > 0).toList());
      } else {
        _saveCart(products); // Guardar todos los productos
      }

      notifyListeners();
    }
  }

  // Método para agregar productos al carrito
  void onPressedAdd() {
    hasStockIssues = false;

    // Obtiene productos con cantidad mayor a cero
    List<Product> selectedProducts =
        products.where((product) => product.quantity > 0).toList();

    for (var product in selectedProducts) {
      if (product.quantity > product.stock) {
        hasStockIssues = true;
        break;
      }
    }

    // Guardar solo si no hay problemas de stock
    if (!hasStockIssues) {
      _saveCart(selectedProducts);
    }
    notifyListeners();
  }

  // Método para guardar el carrito en SharedPreferences
  Future<void> _saveCart(List<Product> selectedProducts) async {
    // Convierte los productos seleccionados a una lista de mapas (json)
    var productJsonList =
        selectedProducts.map((product) => product.toJson()).toList();

    // Convierte la lista de mapas a una cadena JSON
    String jsonString = jsonEncode(productJsonList);

    // Guarda el carrito en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    bool isSaved = await prefs.setString('cart', jsonString);

    // Imprime en el log los datos que se están guardando
    log('Datos guardados en SharedPreferences: $jsonString'); // Muestra el JSON completo

    if (isSaved) {
      log('Carrito guardado correctamente con ${selectedProducts.length} productos.');
    } else {
      log('Error al guardar el carrito.');
    }
  }

  // Método para cargar el carrito
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('cart');
    if (jsonString != null) {
      try {
        List<dynamic> jsonList = jsonDecode(jsonString);
        List<Product> loadedProducts = jsonList
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        // Combina productos guardados con la lista actual, solo si la cantidad es mayor a cero
        for (var loadedProduct in loadedProducts) {
          var productIndex =
              _products.indexWhere((p) => p.id == loadedProduct.id);
          if (productIndex != -1) {
            _products[productIndex].quantity = loadedProduct.quantity;
          } else {
            _products.add(loadedProduct);
          }
        }
        log('Carrito guardado correctamente con ${_products.length} productos.');
        notifyListeners();
      } catch (e) {
        log("Error al cargar el carrito: $e");
      }
    }
  }

  Future<void> clearCart() async {
    // Obtiene la instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Elimina el carrito de SharedPreferences
    await prefs.remove('cart');

    // Opción alternativa: Si quieres reiniciar la lista de productos en la UI, puedes hacerlo aquí
    _products.clear(); // Limpiar la lista de productos cargados en la UI

    notifyListeners(); // Notificar a los listeners para actualizar la UI
  }

  double totalSum() {
    return _products.fold(
      0.0,
      (sum, product) => sum + product.price * product.quantity,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
