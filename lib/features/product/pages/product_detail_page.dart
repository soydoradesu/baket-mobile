import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late CartService cartService;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    cartService = CartService(request);
  }

  void _addToCart() async {
    final success = await cartService.addToCart(widget.product.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barang berhasil dimasukkan ke keranjang!')),
      );
      // Optionally update cart count in UI
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memasukkan barang ke keranjang.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.network(widget.product.image),
          SizedBox(height: 16),
          Text(widget.product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Rp${widget.product.price}', style: TextStyle(fontSize: 20, color: Colors.blue)),
          Text('Kategori: ${widget.product.category}'),
          SizedBox(height: 16),
          Text(widget.product.specs),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addToCart,
            child: Text('Masukkan Keranjang'),
          ),
        ],
      ),
    );
  }
}
