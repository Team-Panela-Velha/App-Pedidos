import 'package:app_pedidos/data/mock_data.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 IMAGEM
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEDE1D7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // 🔥 NOME
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE29578),
          ),
        ),

        const SizedBox(height: 4),

        // 🔥 DESCRIÇÃO
        Text(
          product.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 6),

        const Divider(),

        // 🔥 PREÇO + BOTÕES
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFE76F51),
              ),
            ),
            Row(
              children: [
                _iconButton(Icons.favorite_border),
                const SizedBox(width: 6),
                _iconButton(Icons.add),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF4A896),
      ),
      child: Icon(
        icon,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}