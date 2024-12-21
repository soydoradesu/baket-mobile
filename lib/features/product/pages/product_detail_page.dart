import 'dart:convert';

import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/review_model.dart';
import '../models/product_model.dart';
import '../widgets/review_card.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import '../services/review_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({required this.product, Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int? selectedRatingFilter;
  late CartService cartService;
  late Future<List<Review>> reviewsFuture;
  late ReviewService reviewService;
  late Future<Map<String, dynamic>> _ratingData;

  List<Review> originalReviews = [];
  List<Review> filteredReviews = [];

  late WishlistService wishlistService;
  bool isInWishlist = false;

  double ratingValue = 3.5;
  String comment = '';
  bool hasReviewed = false;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    debugPrint("CookieRequest initialized: $request");
    reviewService = ReviewService(request);
    cartService = CartService(request);
    reviewsFuture = fetchReviews(widget.product.id.toString());
    _ratingData = fetchAverageRating(widget.product.id);
    _checkIfReviewed();

    wishlistService = WishlistService(request);
    if (request.loggedIn) {
      _fetchWishlistStatus();
    }
  }

  void _addToCart() async {
    final success = await cartService.addToCart(widget.product.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Barang berhasil dimasukkan ke keranjang!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memasukkan barang ke keranjang.')),
      );
    }
  }

  void _fetchWishlistStatus() async {
    final status =
        await wishlistService.fetchIsInWishlist(widget.product.id.toString());
    setState(() {
      isInWishlist = status;
    });
  }

  Future<void> _toggleWishlist() async {
    final newStatus =
        await wishlistService.toggleWishlist(widget.product.id.toString());
    setState(() {
      isInWishlist = newStatus;
    });

    if (newStatus) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk ditambahkan ke Wishlist!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk dihapus dari Wishlist.')),
      );
    }
  }

  Future<void> _checkIfReviewed() async {
    final status =
        await reviewService.hasReviewed(widget.product.id.toString());
    setState(() {
      hasReviewed = status;
    });
  }

  Future<List<Review>> fetchReviews(String productId) async {
    try {
      final response = await http.get(
          Uri.parse('http://127.0.0.1:8000/catalogue/review-json/$productId'));

      if (response.statusCode == 200) {
        originalReviews = reviewFromJson(response.body);
        filteredReviews = List.from(originalReviews);
        setState(() {});
        return originalReviews;
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchAverageRating(String prodId) async {
    final url = Uri.parse('http://127.0.0.1:8000/catalogue/calculate-ratings/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'prod_id': prodId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'average_rating': data['average_rating'],
          'review_count': data['review_count'],
        };
      } else {
        print('Failed to fetch rating data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching average rating: $e');
    }
    return {'average_rating': 0.0, 'review_count': 0};
  }

  List<Review> applyFilter() {
    if (selectedRatingFilter != 0) {
      filteredReviews = originalReviews
          .where((review) => review.rating == selectedRatingFilter)
          .toList();
    } else {
      filteredReviews = List.from(originalReviews); // Reset to all reviews
    }
    return filteredReviews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: const Color(0xFF01aae8),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Center(
                        child: Image.network(
                          widget.product.image,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              width: 200,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.error_outline),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Product Name
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Product Price
                      Text(
                        'Rp${widget.product.price}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF01aae8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Product average rating
                      FutureBuilder<Map<String, dynamic>>(
                        future: _ratingData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                                child: Text('No rating data available'));
                          }

                          final data = snapshot.data!;
                          final averageRating = data['average_rating'];
                          final reviewCount = data['review_count'];

                          // Calculate the number of filled and empty stars
                          int fullStars = averageRating.toInt();
                          int emptyStars = 5 - fullStars;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Stars section
                                Row(
                                  children: List.generate(fullStars, (index) {
                                        return Icon(
                                          Icons.star,
                                          color: Colors.yellow[700],
                                          size: 20,
                                        );
                                      }) +
                                      List.generate(emptyStars, (index) {
                                        return Icon(
                                          Icons.star_border,
                                          color: Colors.yellow[700],
                                          size: 20,
                                        );
                                      }),
                                ),
                                const SizedBox(width: 8),
                                // Average rating and review count section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${averageRating.toStringAsFixed(1)} | $reviewCount Ulasan',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Category
                      Row(
                        children: [
                          const Text(
                            'Kategori:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.product.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Description
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deskripsi:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Expanded widget ensures the text fills the available space
                          Expanded(
                            child: Text(
                              widget.product.specs,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black87),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Buttons
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _addToCart,
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Masukkan Keranjang'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF01aae8),
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _toggleWishlist,
                            icon: Icon(isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border),
                            label: Text(
                              isInWishlist
                                  ? 'Hapus dari Wishlist'
                                  : 'Tambah ke Wishlist',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isInWishlist
                                  ? const Color(0xFFf87171)
                                  : const Color(0xFF01aae8),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Write Review Section
              if (!hasReviewed) ...[
                Center(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tulis Ulasan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingStars(
                                value: ratingValue,
                                onValueChanged: (v) {
                                  setState(() {
                                    ratingValue = v;
                                  });
                                },
                                starCount: 5,
                                starSize: 20,
                                valueLabelColor: const Color(0xff9b9b9b),
                                valueLabelTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                valueLabelRadius: 10,
                                maxValue: 5,
                                starSpacing: 2,
                                maxValueVisibility: true,
                                valueLabelVisibility: true,
                                animationDuration:
                                    const Duration(milliseconds: 1000),
                                valueLabelPadding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 8),
                                valueLabelMargin:
                                    const EdgeInsets.only(right: 8),
                                starOffColor: const Color(0xffe7e8ea),
                                starColor: Colors.yellow,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Apa pendapat Anda tentang produk ini?',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                comment = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final response = await request.postJson(
                                  "${Endpoints.baseUrl}/catalogue/create-review/",
                                  jsonEncode(<String, String>{
                                    'product_id': widget.product.id,
                                    'rating': ratingValue.toString(),
                                    'comment': comment,
                                  }),
                                );
                                if (context.mounted) {
                                  if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Review berhasil dikirim!"),
                                      ),
                                    );
                                    setState(() {
                                      hasReviewed = true;
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailPage(
                                            product: widget.product),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Terdapat kesalahan, silakan coba lagi."),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF01aae8),
                              ),
                              child: const Text(
                                'Kirim',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ] else ...[
                const Center(
                  child: Text(
                    'Anda telah memberikan ulasan untuk produk ini.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Reviews Section with Filter Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Ulasan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<int>(
                    onSelected: (rating) {
                      setState(() {
                        selectedRatingFilter = rating;
                        applyFilter();
                      });
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text(
                          'Semua',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 5,
                        child: Text(
                          '5 Bintang',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 4,
                        child: Text(
                          '4 Bintang',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Text(
                          '3 Bintang',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text(
                          '2 Bintang',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text(
                          '1 Bintang',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.filter_alt_outlined),
                    color: const Color(0xFF01aae8),
                  ),
                ],
              ),
              FutureBuilder<List<Review>>(
                future: Future.value(filteredReviews),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final reviewsToDisplay = snapshot.data!;
                    if (reviewsToDisplay.isNotEmpty) {
                      return ReviewCard(
                        reviews: reviewsToDisplay,
                        product: widget.product,
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Tidak ada ulasan dengan filter ini.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text(
                        'Belum ada ulasan untuk produk ini.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
