import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';
import '../pages/product_detail_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> deleteReview(int reviewId) async {
  final url = Uri.parse('http://127.0.0.1:8000/catalogue/delete/$reviewId/');

  try {
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        print(data['message']); // Successfully deleted
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  } catch (error) {
    print('Error deleting review: $error');
  }
}

class ReviewCard extends StatelessWidget {
  final List<Review> reviews;
  final Product product;

  const ReviewCard({required this.reviews, required this.product, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < review.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.yellow[700],
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  review.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (review.isUserReview)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 20,
                        onPressed: () async {
                          bool confirmed = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: const Text(
                                    "Apakah Anda yakin ingin menghapus ulasan ini?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Batal"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  TextButton(
                                    child: const Text("Hapus"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmed ?? false) {
                            await deleteReview(review.id);
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                      ),
                    const Icon(
                      Icons.thumb_up,
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${review.likeReviewCount}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
