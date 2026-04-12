import 'package:flutter/material.dart';
import 'package:app_pedidos/data/mock_data.dart';

Widget productCard(BuildContext context, ProductModel product) {
  final width = MediaQuery.of(context).size.width;
  final isLandscape =
      MediaQuery.of(context).orientation == Orientation.landscape;

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.grey.shade100,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Imagem (ou placeholder)
        Expanded(
          child: Center(
            child: product.image.isEmpty
                ? Icon(
                    Icons.fastfood, // mais coerente com comida havaiana 🍱
                    size: isLandscape ? 80 : width * 0.12,
                  )
                : Image.network(product.image),
          ),
        ),

        /// 🔹 Nome
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isLandscape ? 18 : width * 0.035,
            ),
          ),
        ),

        /// 🔹 Preço
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            product.price,
            style: TextStyle(
              fontSize: isLandscape ? 16 : width * 0.03,
            ),
          ),
        ),

        /// 🔹 Rating
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          child: Row(
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                product.rating.toString(),
                style: TextStyle(
                  fontSize: isLandscape ? 14 : width * 0.028,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}