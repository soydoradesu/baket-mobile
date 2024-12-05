// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    List<Product> products;
    int page;
    int totalPages;

    Welcome({
        required this.products,
        required this.page,
        required this.totalPages,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
        page: json["page"],
        totalPages: json["total_pages"],
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "page": page,
        "total_pages": totalPages,
    };
}

class Product {
    final String id;
    final String name;
    final int price;
    final String image;

    Product({
        required this.id,
        required this.name,
        required this.price,
        required this.image,
    });

    factory Product.fromJson(Map<String, dynamic> json) {
        return Product(
            id: json['id'],
            name: json['name'],
            price: json['price'],
            image: json['image'],
        );
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'image': image,
    };
}
