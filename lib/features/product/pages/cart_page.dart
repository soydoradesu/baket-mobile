import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item_model.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartService cartService;
  List<CartItem> cartItems = [];
  int total = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    cartService = CartService(request);
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    setState(() {
      isLoading = true;
    });

    final items = await cartService.fetchCartItems();
    int sum = 0;
    for (var item in items) {
      sum += item.totalPrice;
    }

    setState(() {
      cartItems = items;
      total = sum;
      isLoading = false;
    });
  }

  Future<void> _removeItem(int id) async {
    final success = await cartService.removeFromCart(id);
    if (success) {
      // refresh cart
      _fetchCart();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus barang dari keranjang.')),
      );
    }
  }

  Future<void> _checkout() async {
    final success = await cartService.checkout();
    if (success) {
      // Navigate to order confirmation or fetch order_id from response if possible
      // If order_id is not returned as JSON, you might need to adapt.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesanan dibuat!')),
      );
      // For now, just clear cart or navigate to order confirmation page.
      // Example:
      Navigator.pushNamed(context, '/order-confirmation');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal melakukan checkout.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Keranjangmu')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Keranjangmu')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Keranjang Kosong'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/catalogue');
                },
                child: Text('Lanjutkan Belanja'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Keranjangmu')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Qty: ${item.quantity}, Rp${item.product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Rp${item.totalPrice}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeItem(item.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Total: Rp$total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _checkout,
                  child: Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
