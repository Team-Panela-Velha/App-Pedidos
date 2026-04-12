import 'package:flutter/material.dart';

/// =======================
/// 📢 BANNERS
/// =======================
class BannerModel {
  final String title;
  final IconData icon;

  BannerModel({
    required this.title,
    required this.icon,
  });
}

final List<BannerModel> bannersMock = [
  BannerModel(
    title: "Combo Havaiano\n20% OFF",
    icon: Icons.local_offer,
  ),
  BannerModel(
    title: "Frete Grátis hoje",
    icon: Icons.local_shipping,
  ),
  BannerModel(
    title: "Novidades do Hawaii",
    icon: Icons.new_releases,
  ),
  BannerModel(
    title: "Peça 2 e leve 3",
    icon: Icons.shopping_cart,
  ),
];

/// =======================
/// 🧭 CATEGORIAS
/// =======================
class CategoryModel {
  final String name;
  final IconData icon;

  CategoryModel({
    required this.name,
    required this.icon,
  });
}

final List<CategoryModel> categoriesMock = [
  CategoryModel(name: "Pokes", icon: Icons.rice_bowl),
  CategoryModel(name: "Sushis", icon: Icons.set_meal),
  CategoryModel(name: "Bebidas", icon: Icons.local_drink),
  CategoryModel(name: "Sobremesas", icon: Icons.icecream),
  CategoryModel(name: "Combos", icon: Icons.lunch_dining),
  CategoryModel(name: "Veganos", icon: Icons.eco),
];

/// =======================
/// 🍱 PRODUTOS
/// =======================
class ProductModel {
  final String name;
  final String description;
  final String price;
  final String image;
  final double rating;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
  });
}

final List<ProductModel> productsMock = [
  ProductModel(
    name: "Poke de Salmão",
    description: "Salmão fresco com arroz, manga e molho especial",
    price: "R\$ 39,90",
    image: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
    rating: 4.8,
  ),
  ProductModel(
    name: "Poke de Atum",
    description: "Atum com avocado, gergelim e shoyu",
    price: "R\$ 42,90",
    image: "https://images.unsplash.com/photo-1553621042-f6e147245754",
    rating: 4.7,
  ),
  ProductModel(
    name: "Sushi Havaiano",
    description: "Sushi com toque tropical e frutas",
    price: "R\$ 29,90",
    image: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351",
    rating: 4.5,
  ),
  ProductModel(
    name: "Temaki de Salmão",
    description: "Temaki grande com salmão e cream cheese",
    price: "R\$ 24,90",
    image: "https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56",
    rating: 4.6,
  ),
  ProductModel(
    name: "Combo Aloha",
    description: "Mix de poke + sushi + bebida",
    price: "R\$ 59,90",
    image: "https://images.unsplash.com/photo-1562158070-622a9f0c5f0c",
    rating: 4.9,
  ),
  ProductModel(
    name: "Smoothie Tropical",
    description: "Abacaxi, coco e manga batidos",
    price: "R\$ 14,90",
    image: "https://images.unsplash.com/photo-1505252585461-04db1eb84625",
    rating: 4.4,
  ),
  ProductModel(
    name: "Mochi de Manga",
    description: "Sobremesa japonesa com recheio de manga",
    price: "R\$ 12,90",
    image: "https://images.unsplash.com/photo-1582450871972-ab5ca641643d",
    rating: 4.3,
  ),
  ProductModel(
    name: "Poke Vegano",
    description: "Tofu, legumes frescos e molho agridoce",
    price: "R\$ 34,90",
    image: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd",
    rating: 4.5,
  ),
];