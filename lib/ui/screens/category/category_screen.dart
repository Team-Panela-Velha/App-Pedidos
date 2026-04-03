
import 'package:app_pedidos/ui/widgets/category_grid.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Padding(
    padding: const EdgeInsets.all(12),
    child: CategoryGrid(),
  ),
);
  }
}