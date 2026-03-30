import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 Fundo só na imagem
          Container(
            height: 500,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE3D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Image.asset(
    image,
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.cover, // 🔥 ISSO resolve
  ),
)
            ),
          ),

          const SizedBox(height: 16),

          // Título
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Descrição
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}