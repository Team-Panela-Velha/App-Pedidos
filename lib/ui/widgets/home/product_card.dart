import 'package:app_pedidos/core/model/product/product.dart';
import 'package:flutter/material.dart';
import 'package:app_pedidos/data/mock_data.dart';

Widget productCard(BuildContext context, Product product) {
  final width = MediaQuery.of(context).size.width;
  final isLandscape =
      MediaQuery.of(context).orientation == Orientation.landscape;

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias, // importante p/ cortar a imagem
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 IMAGEM
        AspectRatio(
          aspectRatio: 2.5,
          child: product.image == null
              ? Center(
                  child: Icon(
                    Icons.fastfood,
                    size: isLandscape ? 60 : width * 0.12,
                    color: Colors.grey,
                  ),
                )
              : Image.network(
                  product.image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),

        /// 🔹 CONTEÚDO
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Nome
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isLandscape ? 16 : width * 0.035,
                ),
              ),

              const SizedBox(height: 6),

              /// (Opcional) descrição fake tipo da imagem
              Text(
                "Lorem ipsum dolor sit amet",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isLandscape ? 13 : width * 0.028,
                ),
              ),

              const SizedBox(height: 8),

              /// Preço + Rating na mesma linha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.price.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isLandscape ? 15 : width * 0.032,
                    ),
                  ),

                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.star,
                  //       size: 14,
                  //       color: Colors.amber,
                  //     ),
                  //     const SizedBox(width: 4),
                  //     Text(
                  //       product.rating.toString(),
                  //       style: TextStyle(
                  //         fontSize: isLandscape ? 13 : width * 0.028,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}