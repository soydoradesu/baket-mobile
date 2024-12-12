// services/wishlist_service.dart

// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class WishlistService {
  final CookieRequest request;

  WishlistService(this.request);

  Future<bool> fetchIsInWishlist(String productId) async {
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/wishlist/is_in_wishlist/$productId/'
      );

      // Since response is a Map, directly access the key
      if (response.containsKey('is_in_wishlist')) {
        return response['is_in_wishlist'] as bool;
      } else {
        throw Exception('Invalid response structure: ${response}');
      }

    } catch (e) {
      print('Error fetching wishlist status: $e');
      return false; // Default to false on error
    }
  }

  Future<bool> toggleWishlist(String productId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/wishlist/toggle-api/',
        {'product_id': productId}
      );

      if (response['status'] == 'added') {
        return true;
      } else if (response['status'] == 'removed') {
        return false;
      } else {
        throw Exception('Unexpected response: ${response['status']}');
      }
    } catch (e) {
      print('Error toggling wishlist: $e');
      return false; // Indicate failure
    }
  }
}
