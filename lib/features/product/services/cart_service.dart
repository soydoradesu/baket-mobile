import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/cart_item_model.dart';

class CartService {
  final CookieRequest request;

  CartService(this.request);

  // Fetch cart items
  Future<CartData> fetchCartItems() async {
    final response =
        await request.get('${Endpoints.baseUrl}/catalogue/cart-api/');
    if (response == null) return CartData(cartItems: [], total: 0.0);

    if (!response.containsKey('cart_items')) return CartData(cartItems: [], total: 0.0);

    List<dynamic> itemsJson = response['cart_items'];
    double total = response['total']?.toDouble() ?? 0.0;

    List<CartItem> cartItems = itemsJson.map((json) => CartItem.fromJson(json)).toList();
    return CartData(cartItems: cartItems, total: total);
  }

  // Add a product to cart
  Future<bool> addToCart(String productId) async {
    final url = '${Endpoints.baseUrl}/catalogue/cart/add/$productId/';
    final result = await request.get(url);
    if (result == null) return false;
    return true;
  }

  // Remove from cart
  Future<bool> removeFromCart(int cartItemId) async {
    final url = '${Endpoints.baseUrl}/catalogue/cart/remove/$cartItemId/';
    final result = await request.post(url, {});
    if (result == null) return false;
    if (result['status'] == 'success') return true;
    return false;
  }

  // Checkout
  Future<Map<String, dynamic>?> checkout() async {
    const url = '${Endpoints.baseUrl}/catalogue/checkout-api/';
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
        await request.get('${Endpoints.baseUrl}/catalogue/cart-count/');
    if (response == null || !response.containsKey('cart_count')) return 0;
    return response['cart_count'];
  }
}

class CartData {
  final List<CartItem> cartItems;
  final double total;

  CartData({required this.cartItems, required this.total});
}
