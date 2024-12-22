// lib/features/user/widgets/shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer for the Profile Section
class ShimmerProfileSection extends StatelessWidget {
  const ShimmerProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate responsive widths based on screen size
    double screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          // Profile Picture Placeholder
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          // Name and Role Placeholders
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Placeholder
              Container(
                width: screenWidth * 0.4, // 40% of screen width
                height: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              // Role Placeholder
              Container(
                width: 80,
                height: 16,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer for the Wishlist Section
class ShimmerWishlistSection extends StatelessWidget {
  const ShimmerWishlistSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Favorite Icon Placeholder
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                // Wishlist Count Placeholder
                Container(
                  width: screenWidth * 0.4, // 40% of screen width
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
            // 'beli sekarang!' Text Placeholder
            Container(
              width: 100,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for the Cart Section
class ShimmerCartSection extends StatelessWidget {
  const ShimmerCartSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Shopping Cart Icon Placeholder
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                // Cart Count Placeholder
                Container(
                  width: screenWidth * 0.4, // 40% of screen width
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
            // 'checkout yuk!' Text Placeholder
            Container(
              width: 120,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for Cart Count Text (Used in Profile Page)
class ShimmerCartCount extends StatelessWidget {
  const ShimmerCartCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust width to be responsive
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: screenWidth * 0.35, // 35% of screen width
        height: 16,
        color: Colors.white,
      ),
    );
  }
}
