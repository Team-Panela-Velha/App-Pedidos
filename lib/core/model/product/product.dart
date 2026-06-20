import 'package:app_pedidos/core/model/category.dart';
import 'package:app_pedidos/core/model/order/extra.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final Category? category;
  final List<Extra> extras;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    this.category,
    this.extras = const [],
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
      extras: json['extras'] != null
          ? (json['extras'] as List).map((i) => Extra.fromJson(i)).toList()
          : [],
    );
  }
}