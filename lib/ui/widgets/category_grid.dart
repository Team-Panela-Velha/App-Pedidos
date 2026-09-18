import 'package:app_pedidos/core/model/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category> onSelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 3 : 2;
        return MasonryGridView.count(
          padding: const EdgeInsets.all(12),
          crossAxisCount: columns,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemCount: categories.length,
          itemBuilder: (context, index) => CategoryItem(
            category: categories[index],
            height: index % 5 == 0 ? 220 : 250,
            onTap: () => onSelected(categories[index]),
          ),
        );
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;
  final double height;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE2A693),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
