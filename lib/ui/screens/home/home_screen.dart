import 'dart:async';

import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/home/banner_item.dart';
import 'package:app_pedidos/ui/widgets/home/category_item.dart';
import 'package:app_pedidos/ui/widgets/home/product_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(viewportFraction: 0.95);
  int currentPage = 0;

  late Timer _bannerTimer;

  @override
  void initState() {
    super.initState();

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        int nextPage = currentPage + 1;

        if (nextPage >= 3) {
          nextPage = 0;
        }

        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final shortestSide = size.shortestSide;
    final isTablet = shortestSide > 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: isLandscape ? 300 : height * 0.22,
                child: PageView(
                  padEnds: false,
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: [
                    bannerItem(
                      context,
                      "Promoção Especial\n20% OFF",
                      Icons.chair,
                    ),
                    bannerItem(context, "Frete Grátis", Icons.local_shipping),
                    bannerItem(
                      context,
                      "Novidades da Semana",
                      Icons.new_releases,
                    ),
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isActive = currentPage == index;
                final colors = Theme.of(context).colorScheme;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isActive
                        ? AppColors.disabled
                        : colors.primary.withOpacity(0.3),
                  ),
                );
              }),
            ),

            // 🔹 Categorias
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Categorias",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isLandscape ? 32 : width * 0.05, // fonte responsiva
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: isLandscape ? 140 : height * 0.15, // altura responsiva
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  categoryItem(context, Icons.chair, "Cadeiras"),
                  categoryItem(context, Icons.table_restaurant, "Mesas"),
                  categoryItem(context, Icons.bed, "Camas"),
                  categoryItem(context, Icons.kitchen, "Cozinha"),
                  categoryItem(context, Icons.chair, "Teste"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Destaque
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Mais Vendido",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              height: isLandscape ? 280 : height * 0.22,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Carrinho de Cozinha",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Produto muito útil para sua casa",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "4.5",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Ícone com estilo mais leve
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.kitchen,
                      size: isLandscape ? 48 : width * 0.1, // ícone responsivo
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Lista de produtos
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Novos Produtos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 4 : (isLandscape ? 3 : 2),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isLandscape
                    ? 1.2
                    : 0.75, // proporção responsiva
              ),
              itemBuilder: (context, index) {
                return productCard(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
