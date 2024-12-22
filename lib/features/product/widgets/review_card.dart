import 'package:baket_mobile/core/themes/_themes.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';
import '../pages/product_detail_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> fetchCsrfToken(Uri url) async {
  try {
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['csrf_token'] != null) {
        return data['csrf_token'];
      }
    }
  } catch (e) {
    print('Error fetching CSRF token: $e');
  }
  return null;
}

Future<void> deleteReview(int reviewId) async {
  final url = Uri.parse('http://127.0.0.1:8000/catalogue/delete/$reviewId/');

  try {
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        print(data['message']);
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

Future<void> toggleLikeReview(
    int reviewId, Function(int) onUpdate, String csrfToken) async {
  final url = Uri.parse('http://127.0.0.1:8000/catalogue/like-review/');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': csrfToken,
      },
      body: json.encode({'review_id': reviewId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        onUpdate(data['like_count']);
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  } catch (error) {
    print('Error liking review: $error');
  }
}

class ReviewCard extends StatefulWidget {
  final List<Review> reviews;
  final Product product;

  const ReviewCard({required this.reviews, required this.product, Key? key})
      : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  // Function to update like count in state
  void updateLikeCount(int index, int newLikeCount) {
    setState(() {
      widget.reviews[index].likeReviewCount = newLikeCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.reviews.length,
      itemBuilder: (context, index) {
        final review = widget.reviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < review.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.yellow[700],
                      size: 18,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  review.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
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
                                  ProductDetailPage(product: widget.product),
                            ),
                          );
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      iconSize: 16,
                      color: review.isLiked
                          ? const Color(0xFF01aae8)
                          : Colors.black,
                      onPressed: () async {
                        String? csrfToken = await fetchCsrfToken(
                          Uri.parse(
                              'http://127.0.0.1:8000/catalogue/api/csrf-token/'),
                        );
                        if (csrfToken != null) {
                          await toggleLikeReview(
                            review.id,
                            (newLikeCount) =>
                                updateLikeCount(index, newLikeCount),
                            csrfToken,
                          );

                          setState(() {
                            review.isLiked = !review.isLiked;
                          });
                        } else {
                          print("Failed to fetch CSRF token.");
                        }
                      },
                    ),
                    const SizedBox(width: 2),
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
