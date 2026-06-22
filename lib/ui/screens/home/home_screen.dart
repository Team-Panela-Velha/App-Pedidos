import 'dart:async';

import 'package:app_pedidos/core/model/product/product.dart';
import 'package:app_pedidos/core/provider/product_provider.dart';
import 'package:app_pedidos/core/service/notification_service.dart';
import 'package:app_pedidos/data/mock_data.dart';
import 'package:app_pedidos/locator.dart';
import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/home/banner_item.dart';
import 'package:app_pedidos/ui/widgets/home/category_item.dart';
import 'package:app_pedidos/ui/widgets/home/product_card.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(viewportFraction: 0.95);
  final NotificationService _notificationService = locator<NotificationService>();

  int currentPage = 0;

  late Timer _bannerTimer;
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getProducts();
    });

    // Escutar notificações
    _notificationSubscription = _notificationService.notifications.listen((event) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${event.title}: ${event.body}'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    });

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
    _notificationSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _testNotification() async {
    await _notificationService.showNotification(
      title: 'Teste de Notificação',
      body: 'Esta é uma notificação de teste!',
      data: {'teste': 'valor'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    final List<Product> products = productProvider.products;

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final shortestSide = size.shortestSide;
    final isTablet = shortestSide > 600;

    return Scaffold(
      body: productProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                        children: List.generate(bannersMock.length, (j) {
                          return bannerItem(
                            context,
                            bannersMock[j].title,
                            bannersMock[j].icon,
                          );
                        }),
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isLandscape ? 32 : width * 0.05,
                          ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: isLandscape ? 140 : height * 0.15,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: List.generate(categoriesMock.length, (j) {
                        return categoryItem(
                          context,
                          categoriesMock[j].icon,
                          categoriesMock[j].name,
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Destaque
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Mais Vendido",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    height: isLandscape ? 280 : height * 0.22,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Carrinho de Cozinha",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Produto muito útil para sua casa",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "4.5",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.kitchen,
                            size:
                                isLandscape ? 48 : width * 0.1,
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  GridView.builder(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          isTablet ? 4 : (isLandscape ? 3 : 2),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio:
                          isLandscape ? 0.8 : 0.50,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return GestureDetector(
                        onTap: () => context.go(
                          Routes.addProduct,
                          extra: product,
                        ),
                        child: productCard(context, product),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SimpleButton(
                      onTap: _testNotification,
                      text: 'Testar Notificação',
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}