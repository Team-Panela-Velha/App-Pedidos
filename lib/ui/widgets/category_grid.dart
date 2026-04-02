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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return const CategoryItem(text: "Decorative\nLight", height: 200);
          case 1:
            return const CategoryItem(text: "Sofa", height: 220);
          case 2:
            return const CategoryItem(text: "Beds", height: 280);
          case 3:
            return const CategoryItem(text: "Tables", height: 220);
          case 4:
            return const CategoryItem(text: "Chairs", height: 220);
          case 5:
            return const CategoryItem(text: "Cupboard", height: 280);
          case 6:
            return const CategoryItem(text: "Decor", height: 200);
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