import 'dart:async';

import 'package:app_pedidos/theme/app_colors.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Banner
            SizedBox(
              height: 160,
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  bannerItem(context, "Promoção Especial\n20% OFF", Icons.chair),
                  bannerItem(context, "Frete Grátis", Icons.local_shipping),
                  bannerItem(context, "Novidades da Semana", Icons.new_releases),
                ],
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Categorias",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textSecondary
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  categoryItem(Icons.chair, "Cadeiras"),
                  categoryItem(Icons.table_restaurant, "Mesas"),
                  categoryItem(Icons.bed, "Camas"),
                  categoryItem(Icons.kitchen, "Cozinha"),
                  categoryItem(Icons.chair, "Teste")
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
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Produto muito útil para sua casa",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              "4.5",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          
                        )
                      ],
                    ),
                  ),

                  // 🔹 Ícone com estilo mais leve (igual design)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.kitchen,
                      size: 40,
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return productCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Categoria item
Widget categoryItem(IconData icon, String label) {
  return Container(
    width: 80,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: AppColors.secondary,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
      ],
    ),
  );
}

// 🔹 Card de produto
Widget productCard() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.grey.shade100,
    ),
    child: Column(
      children: [
        Expanded(
          child: Icon(Icons.chair, size: 60),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Cadeira Moderna",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text("R\$ 199,00"),
        ),
      ],
    ),
  );
}

Widget bannerItem(BuildContext context, String title, IconData icon) {
  final colors = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          colors.primary,
          colors.secondary,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          right: 10,
          bottom: 10,
          child: Icon(
            icon,
            size: 80,
            color: colors.onPrimary.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: textTheme.headlineMedium?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}