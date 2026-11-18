import 'dart:async';

import 'package:app_pedidos/core/model/category.dart';
import 'package:app_pedidos/core/model/product/product.dart';
import 'package:app_pedidos/core/provider/product_provider.dart';
import 'package:app_pedidos/core/service/category/category_service.dart';
import 'package:app_pedidos/core/service/product/product_service.dart';
import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/home/banner_item.dart';
import 'package:app_pedidos/ui/widgets/home/category_item.dart';
import 'package:app_pedidos/ui/widgets/home/product_card.dart';
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
  Timer? _bannerTimer;
  int _currentPage = 0;
  List<Category> _categories = [];
  bool _loadingCategories = true;
  String? _categoryError;
  List<Product> _bestSellers = [];
  // Carrossel: o mais vendido de cada categoria
  List<Product> _banners = [];

  void _openProduct(Product product) =>
      context.push(Routes.addProduct, extra: product);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final count = _banners.length;
      if (!_controller.hasClients || count == 0) return;
      _controller.animateToPage(
        (_currentPage + 1) % count,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loadingCategories = true;
      _categoryError = null;
    });
    final products = context.read<ProductProvider>().getProducts();
    ProductService()
        .getBestSellers(limit: 1)
        .then((list) {
          if (mounted) setState(() => _bestSellers = list);
        })
        .catchError((_) {}); // sem mais vendido a seção some
    ProductService()
        .getBestSellerPerCategory()
        .then((list) {
          if (mounted) setState(() => _banners = list);
        })
        .catchError((_) {}); // sem produtos o carrossel some
    try {
      final categories = await CategoryService().getCategories();
      categories.sort((a, b) => a.name.compareTo(b.name));
      if (mounted) setState(() => _categories = categories);
    } catch (_) {
      if (mounted) {
        setState(
          () => _categoryError = 'Não foi possível carregar as categorias.',
        );
      }
    } finally {
      await products;
      if (mounted) setState(() => _loadingCategories = false);
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final products = provider.products.where((p) => p.available).toList();
    final banners = _banners;
    final bestSeller = _bestSellers.isEmpty ? null : _bestSellers.first;
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final isTablet = size.shortestSide > 600;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (banners.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: isLandscape ? 300 : height * 0.22,
                    child: PageView(
                      padEnds: false,
                      controller: _controller,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      children: [
                        for (final product in banners)
                          Semantics(
                            button: true,
                            label: 'Ver ${product.name}',
                            child: GestureDetector(
                              onTap: () => _openProduct(product),
                              child: bannerItem(context, product),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var index = 0; index < banners.length; index++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? AppColors.disabled
                              : Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Categorias',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: isLandscape ? 32 : width * 0.05,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: isLandscape ? 140 : height * 0.15,
                child: _loadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : _categoryError != null
                    ? Center(
                        child: TextButton(
                          onPressed: _load,
                          child: Text('$_categoryError Tentar novamente'),
                        ),
                      )
                    : _categories.isEmpty
                    ? const Center(child: Text('Nenhuma categoria cadastrada.'))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return Semantics(
                            button: true,
                            label: 'Ver produtos de ${category.name}',
                            child: GestureDetector(
                              onTap: () => context.push(
                                Routes.categoryProductsPath(category.id),
                                extra: category.name,
                              ),
                              child: categoryItem(
                                context,
                                categoryIcon(category.name),
                                category.name,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              if (bestSeller != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Mais Vendido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Ver ${bestSeller.name}',
                  child: GestureDetector(
                    onTap: () => _openProduct(bestSeller),
                    child: Container(
                      height: isLandscape ? 280 : height * 0.22,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  bestSeller.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bestSeller.description ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'R\$ ${bestSeller.price.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox.square(
                              dimension: isLandscape ? 200 : width * 0.3,
                              child: (bestSeller.image?.isNotEmpty ?? false)
                                  ? Image.network(
                                      bestSeller.image!,
                                      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stack) =>
                                          const Icon(Icons.fastfood),
                                    )
                                  : Icon(
                                      Icons.fastfood,
                                      size: isLandscape ? 48 : width * 0.1,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Novos Produtos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (provider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.error != null)
                Center(
                  child: TextButton(
                    onPressed: _load,
                    child: const Text(
                      'Não foi possível carregar os produtos. Tentar novamente',
                    ),
                  ),
                )
              else if (products.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Nenhum produto disponível.')),
                )
              else
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 4 : (isLandscape ? 3 : 2),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isLandscape ? 0.8 : 0.50,
                  ),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _openProduct(products[index]),
                    child: productCard(context, products[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
