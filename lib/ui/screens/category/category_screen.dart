import 'package:app_pedidos/core/model/category.dart';
import 'package:app_pedidos/core/service/category/category_service.dart';
import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/ui/widgets/category_grid.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> _categories = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final categories = await CategoryService().getCategories();
      categories.sort((a, b) => a.name.compareTo(b.name));
      if (mounted) setState(() => _categories = categories);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Não foi possível carregar as categorias.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
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
            )
          : _categories.isEmpty
          ? const Center(child: Text('Nenhuma categoria cadastrada.'))
          : CategoryGrid(
              categories: _categories,
              onSelected: (category) => context.push(
                Routes.categoryProductsPath(category.id),
                extra: category.name,
              ),
            ),
    );
  }
}
