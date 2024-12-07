import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  final int orderId; // If known
  final double total; // If known

  const OrderConfirmationPage({Key? key, required this.orderId, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan Diterima!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Terimakasih sudah berbelanja!'),
            Text('Order ID: #$orderId'),
            Text('Total Harga: Rp$total'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/catalogue');
              },
              child: Text('Kembali Berbelanja'),
            ),
          ],
        ),
      ),
    );
  }
}
