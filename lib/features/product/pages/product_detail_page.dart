import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/review_model.dart';
import '../models/product_model.dart';
import '../widgets/review_card.dart';
import '../services/cart_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

Future<List<Review>> fetchReviews(String productId) async {
  try {
    final response = await http.get(
        Uri.parse('http://localhost:8000/catalogue/review-json/$productId'));

    if (response.statusCode == 200) {
      return reviewFromJson(response.body);
    } else {
      throw Exception('Failed to load reviews: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching reviews: $e');
    rethrow;
  }
}

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late CartService cartService;
  late Future<List<Review>> reviewsFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    cartService = CartService(request);
    reviewsFuture = fetchReviews(widget.product.id.toString());
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

  @override
  Widget build(BuildContext context) {
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
              // Product details and buttons go here...
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
                      // Category and Description
                      const Text(
                        'Kategori: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Deskripsi:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_border),
                            label: const Text('Tambah ke Wishlist'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF01aae8),
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
                      const Text(
                        'Tulis Ulasan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star_border,
                            color: Colors.yellow[700],
                            size: 30,
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Apa pendapat Anda tentang produk ini?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01aae8),
                        ),
                        child: const Text(
                          'Kirim',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt_outlined),
                    color: const Color(0xFF01aae8),
                  ),
                ],
              ),
              FutureBuilder<List<Review>>(
                future: reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ReviewCard(reviews: snapshot.data!);
                  } else {
                    return const Text('No reviews yet.');
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
