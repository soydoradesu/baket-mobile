import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartService {
  final CookieRequest request;

  CartService(this.request);

  // Fetch cart items
  Future<List<CartItem>> fetchCartItems() async {
    final response = await request.get('http://localhost:8000/catalogue/cart-api/');
    if (response == null) return [];

    // The response is expected to be HTML rendered by Django.
    // For a mobile app, ideally provide a JSON endpoint.
    // If you only have HTML, you need a separate JSON endpoint or parse HTML.
    // Let's assume you have a JSON endpoint or plan to create one:
    //
    // For now, let's assume you add a `json/cart/` endpoint returning JSON:
    // { "items": [ { "id": ..., "product": {...}, "quantity":..., "total_price":... }, ...], "total":... }
    
    if (!response.containsKey('items')) return [];
    
    List<dynamic> itemsJson = response['items'];
    return itemsJson.map((json) => CartItem.fromJson(json)).toList();
  }

  // Add a product to cart
  Future<bool> addToCart(String productId) async {
    // Using the existing endpoint which returns JSON { "cart_count": ... }
    final url = 'http://localhost:8000/catalogue/cart/add/$productId/';

    final result = await request.get(url);
    if (result == null) return false;
    // result should contain cart_count or similar
    return true;
  }

  // Remove from cart
  Future<bool> removeFromCart(int cartItemId) async {
    final url = 'http://localhost:8000/catalogue/cart/remove/$cartItemId/';
    final result = await request.get(url);
    return result != null;
  }

  // Checkout
  Future<bool> checkout() async {
    final url = 'http://localhost:8000/catalogue/checkout/';
    // On successful checkout, Django creates an order and returns a redirect or HTML.
    // For a mobile app, consider adding a JSON response. For now, we just check success.
    final result = await request.post(url, {});
    return result != null && result['status'] == 'success';
  }
}
