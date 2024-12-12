class Product {
  final String id;
  final String name;
  final int price;
  final String category;
  final String specs;
  final String image;
  final DateTime addedOn;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.specs,
    required this.image,
    required this.addedOn,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
      specs: json['specs'],
      image: json['image'],
      addedOn: DateTime(json['added_ons']),
    );
  }
}
