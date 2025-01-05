import 'dart:convert';
import 'package:product_list/presentation/product/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPersistence {
  // Método para guardar el carrito en SharedPreferences
  static Future<void> saveCart(List<Product> cart) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cartJson =
        cart.map((product) => product.toJson()).toList();
    String cartString = jsonEncode(cartJson);
    await prefs.setString('cart', cartString);
  }

  // Método para cargar el carrito desde SharedPreferences
  static Future<List<Product>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    String? cartString = prefs.getString('cart');
    if (cartString != null) {
      List<dynamic> cartJson = jsonDecode(cartString);
      return cartJson.map((json) => Product.fromJson(json)).toList();
    }
    return []; // Si no hay productos guardados, retornamos una lista vacía
  }
}
