import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartService {
  final CookieRequest request;

  CartService(this.request);

  // Fetch cart items
  Future<CartData> fetchCartItems() async {
    final response =
        await request.get('http://127.0.0.1:8000/catalogue/cart-api/');
    if (response == null) return CartData(cartItems: [], total: 0.0);

    if (!response.containsKey('cart_items')) return CartData(cartItems: [], total: 0.0);

    List<dynamic> itemsJson = response['cart_items'];
    double total = response['total']?.toDouble() ?? 0.0;

    List<CartItem> cartItems = itemsJson.map((json) => CartItem.fromJson(json)).toList();
    return CartData(cartItems: cartItems, total: total);
  }

  // Add a product to cart
  Future<bool> addToCart(String productId) async {
    final url = 'http://127.0.0.1:8000/catalogue/cart/add/$productId/';
    final result = await request.get(url);
    if (result == null) return false;
    return true;
  }

  // Remove from cart
  Future<bool> removeFromCart(int cartItemId) async {
    final url = 'http://127.0.0.1:8000/catalogue/cart/remove/$cartItemId/';
    final result = await request.post(url, {});
    if (result == null) return false;
    if (result['status'] == 'success') return true;
    return false;
  }

  // Checkout
  Future<Map<String, dynamic>?> checkout() async {
    final url = 'http://127.0.0.1:8000/catalogue/checkout-api/';
    final response = await request.post(url, {});
    if (response == null) return null;
    if (response['status'] == 'success') {
      return {
        'order_id': response['order_id'],
        'total': response['total']?.toDouble() ?? 0.0,
      };
    }
    return null;
  }

  // Fetch cart count
  Future<int> fetchCartCount() async {
    final response =
        await request.get('http://127.0.0.1:8000/catalogue/cart-count/');
    if (response == null || !response.containsKey('cart_count')) return 0;
    return response['cart_count'];
  }
}

class CartData {
  final List<CartItem> cartItems;
  final double total;

  CartData({required this.cartItems, required this.total});
}
