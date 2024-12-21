import 'package:baket_mobile/features/product/services/cart_service.dart';
import 'package:baket_mobile/features/product/services/wishlist_service.dart';
import 'package:baket_mobile/features/wishlist/models/wishlist_model.dart';
import 'package:flutter/material.dart';
// import 'package:baket_mobile/features/product/models/product_model.dart';
import 'package:baket_mobile/features/product/pages/product_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class WishListCard extends StatelessWidget {
  final WishlistProduct product;
  final VoidCallback onRemove;

  const WishListCard({
    super.key,
    required this.product,
    required this.onRemove,
  });

  String formatRupiah(int value) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id', // Indonesian locale
      symbol: 'Rp', // Rupiah symbol
      decimalDigits: 0, // No decimal places
    );
    return formatter.format(value);
  }

  Future<bool> _addToCart(BuildContext context, String productId) async {
    final request = context.read<CookieRequest>();
    final cartService = CartService(request);
    final success = await cartService.addToCart(productId);

    // Use the current ScaffoldMessenger for the given context
    final messenger = ScaffoldMessenger.of(context);

    return success;
  }

  Future<void> _removeFromWishlist(BuildContext context, String productId) async {
    final request = context.read<CookieRequest>();
    final wishlistService = WishlistService(request);
    final removed = await wishlistService.toggleWishlist(productId);

    if (removed == false) {
      // Assuming 'removed' status is returned when the product is successfully removed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk dihapus dari Wishlist!')),
      );
      onRemove(); // Refresh the wishlist page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus produk dari Wishlist!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailPage(product: product.toProduct()),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ensures height adjusts to content
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                product.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.error_outline)),
                  );
                },
              ),
            ),

            const SizedBox(height: 8), // Spacing between image and text

            // Product Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 4), // Spacing between name and price

            // Product Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                formatRupiah(product.price), // Use the formatted price
                style: const TextStyle(
                  color: Color(0xFF01aae8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8), // Spacing before buttons

            // Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  // Trash Bin Button
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Remove ${product.name} from wishlist');
                        _removeFromWishlist(context, product.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF01aae8), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                        elevation: 1,
                      ),
                      child: const Icon(
                        Icons.heart_broken,
                        color: Color(0xFF01aae8),
                        size: 24,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8), // Spacing between buttons

                  // Add to Cart Button
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          print('Add ${product.name} to cart');
                          final success = await _addToCart(context, product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('TES')),
                          );
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Barang berhasil dimasukkan ke keranjang!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gagal memasukkan barang ke keranjang!')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01aae8),
                          side: const BorderSide(
                            color: Color(0xFF01aae8), 
                            width: 1.5
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          '+ Keranjang',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8), // Spacing before buttons
          ],
        ),
      ),
    );
  }
}
