import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../models/cart_item_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'order_confirmation_page.dart'; // Ensure this page exists
import 'checkout_page.dart'; // Import the new CheckoutPage

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartService cartService;
  List<CartItem> cartItems = [];
  double total = 0.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    cartService = CartService(request);
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    setState(() {
      isLoading = true;
    });
    final cartData = await cartService.fetchCartItems();
    setState(() {
      cartItems = cartData.cartItems;
      total = cartData.total;
      isLoading = false;
    });
  }

  void _removeFromCart(String cartItemId) async {
    setState(() {
      // Optimistically remove the item from the list
      cartItems.removeWhere((item) => item.id == cartItemId);
      total = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    });

    final success = await cartService.removeFromCart(int.parse(cartItemId));

    if (!success) {
      // If deletion fails, revert the UI changes
      await _fetchCartData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove item from cart.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart.')),
      );
      // Optionally, update the cart count in the profile page
      // You might need to use a state management solution like Provider or Bloc
      // For simplicity, we're not handling it here
    }
  }

  void _checkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(total: total),
      ),
    ).then((_) {
      // Refresh cart data when returning
      _fetchCartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
          backgroundColor: const Color(0xFF01aae8),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : cartItems.isEmpty
                ? const Center(child: Text('Your cart is empty.'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            return ListTile(
                              leading: Image.network(
                                cartItem.product.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.error_outline),
                                  );
                                },
                              ),
                              title: Text(cartItem.product.name),
                              subtitle: Text(
                                  'Quantity: ${cartItem.quantity}\nTotal: Rp${cartItem.totalPrice.toStringAsFixed(2)}'),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _removeFromCart(cartItem.id);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Total: Rp${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _checkout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF01aae8),
                                minimumSize:
                                    const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
  }
}
