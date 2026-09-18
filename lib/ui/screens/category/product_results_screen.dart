import 'package:app_pedidos/core/model/category.dart';
import 'package:app_pedidos/core/model/product/product.dart';
import 'package:app_pedidos/core/service/category/category_service.dart';
import 'package:app_pedidos/core/service/product/product_service.dart';
import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/ui/widgets/home/product_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductResultsScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  final String? keyword;

  const ProductResultsScreen({
    super.key,
    this.categoryId,
    this.categoryName,
    this.keyword,
  });

  @override
  State<ProductResultsScreen> createState() => _ProductResultsScreenState();
}

class _ProductResultsScreenState extends State<ProductResultsScreen> {
  List<Product> _products = [];
  String? _categoryName;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _categoryName = widget.categoryName;
    _load();
  }

  @override
  void didUpdateWidget(covariant ProductResultsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId ||
        oldWidget.keyword != widget.keyword) {
      _categoryName = widget.categoryName;
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (widget.categoryId != null) {
        final id = widget.categoryId!;
        final results = await Future.wait<Object>([
          ProductService().getProductsByCategory(id),
          CategoryService().getCategoryById(id),
        ]);
        if (mounted) {
          setState(() {
            _products = results[0] as List<Product>;
            _categoryName = (results[1] as Category).name;
          });
        }
      } else {
        final products = await ProductService().searchProducts(
          keyword: widget.keyword,
          available: true,
        );
        if (mounted) setState(() => _products = products);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Não foi possível carregar os produtos.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.categoryId != null;
    final title = category
        ? (_categoryName ?? 'Categoria')
        : 'Busca: ${widget.keyword ?? ''}';
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Voltar',
                      onPressed: _back,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      TextButton(
                        onPressed: _load,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_products.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    category
                        ? 'Nenhum produto disponível nesta categoria.'
                        : 'Nenhum produto encontrado.',
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.crossAxisExtent >= 900
                        ? 4
                        : constraints.crossAxisExtent >= 600
                        ? 3
                        : 2;
                    return SliverGrid.builder(
                      itemCount: _products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: columns == 2 ? 0.68 : 0.85,
                      ),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => context.push(
                          Routes.addProduct,
                          extra: _products[index],
                        ),
                        child: productCard(context, _products[index]),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
