import 'package:app_pedidos/core/model/product/product.dart';
import 'package:flutter/material.dart';

Widget bannerItem(BuildContext context, Product product) {
  final width = MediaQuery.of(context).size.width;
  final colors = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [colors.primary, colors.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (product.image?.isNotEmpty ?? false)
          Image.network(
            product.image!,
            webHtmlElementStrategy: WebHtmlElementStrategy.fallback, // hosts sem CORS: usa <img> no navegador
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => const SizedBox.shrink(),
          ),
        // escurece a base da imagem para o nome ficar legível
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${product.name}\nR\$ ${product.price.toStringAsFixed(2)}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isLandscape ? 28 : width * 0.05,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
