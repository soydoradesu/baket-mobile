// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class WishlistService {
  final CookieRequest request;
  static const  String baseUrl = Endpoints.baseUrl;
  static const String isInWishlistUrl = '$baseUrl/wishlist/is_in_wishlist/';
  static const String wishlistToggleUrl = '$baseUrl/wishlist/toggle-api/';

  WishlistService(this.request);

  Future<bool> fetchIsInWishlist(String productId) async {
    try {
      final response = await request.get(
        '$isInWishlistUrl$productId/'
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
        wishlistToggleUrl,
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
