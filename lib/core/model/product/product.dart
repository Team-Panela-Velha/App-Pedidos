import 'package:app_pedidos/core/model/category.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
    );
  }
}