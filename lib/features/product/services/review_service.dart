import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'dart:convert';
import 'package:baket_mobile/core/constants/_constants.dart';

class ReviewService {
  final CookieRequest request;
  static const String baseUrl = Endpoints.baseUrl;
  static const String hasReviewedUrl = '$baseUrl/catalogue/has-reviewed/';

  ReviewService(this.request);

  /// Checks if the user has reviewed a specific product.
  Future<bool> hasReviewed(String productId) async {
    try {
      final response =
          await request.get('$hasReviewedUrl?product_id=$productId');

      if (response.containsKey('has_reviewed')) {
        return response['has_reviewed'] as bool;
      } else {
        throw Exception('Invalid response structure: $response');
      }
    } catch (e) {
      print('Error checking review status: $e');
      return false; // Default to false on error
    }
  }
}
