import 'package:app_pedidos/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app_pedidos/data/mock_data.dart';
import 'package:app_pedidos/ui/widgets/home/product_card.dart';
import 'package:app_pedidos/router.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.shortestSide > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
  children: [
    const SizedBox(height: 20),

    const Center(
      child: Text(
        "Produtos",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    ),

    const SizedBox(height: 20),

    Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        itemCount: productsMock.length,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 4 : (isLandscape ? 3 : 2),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,

          childAspectRatio: isLandscape ? 0.8 : 0.7,
        ),

        itemBuilder: (context, index) {
          final product = productsMock[index];

          return GestureDetector(
            onTap: () => context.go(Routes.addProduct, extra: product),
            child: productCard(context, product),
          );
        },
      ),
    ),
  ],
),
    );
  }
}