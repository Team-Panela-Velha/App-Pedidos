import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: 6,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return const CategoryItem(text: "Pokes", height: 220);
          case 1:
            return const CategoryItem(text: "Sushi", height: 250);
          case 2:
            return const CategoryItem(text: "Bebidas", height: 250);
          case 3:
            return const CategoryItem(text: "Sobremesas", height: 250);
          case 4:
            return const CategoryItem(text: "Combos", height: 250);
          case 5:
            return const CategoryItem(text: "Veganos", height: 220);
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String text;
  final double height;

  const CategoryItem({
    super.key,
    required this.text,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE2A693),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}