class CartItem {
  final String productId;
  final int quantity;
  final double price;

  CartItem(
      {required this.productId, required this.quantity, required this.price});

  // Convierte CartItem a un mapa para poder guardarlo en SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }

  // Convierte un mapa a un CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
