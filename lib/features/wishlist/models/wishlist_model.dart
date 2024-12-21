import 'package:baket_mobile/features/product/models/product_model.dart';

class WishlistProduct {
  final String id;
  final String name;
  final int price;
  final String category;
  final String specs;
  final String image;
  final DateTime addedOn;

  WishlistProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.specs,
    required this.image,
    required this.addedOn,
  });

  factory WishlistProduct.fromJson(Map<String, dynamic> json) {
    return WishlistProduct(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
      specs: json['specs'],
      image: json['image'],
      addedOn: DateTime.parse(json['added_on']),
    );
  }

  Product toProduct() {
    return Product(
      id: id,
      name: name,
      price: price,
      category: category,
      specs: specs,
      image: image,
      // If your Product model has additional fields, set them to defaults or handle accordingly
    );
  }
}
