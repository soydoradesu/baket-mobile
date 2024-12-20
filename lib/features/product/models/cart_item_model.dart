import 'package:baket_mobile/features/product/models/product_model.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      totalPrice: json['total_price']?.toDouble() ?? 0.0,
    );
  }
}
