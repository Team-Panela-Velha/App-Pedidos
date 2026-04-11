import 'package:flutter/material.dart';

Widget bannerItem(BuildContext context, String title, IconData icon) {
  final width = MediaQuery.of(context).size.width;
  final colors = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [colors.primary, colors.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Stack(
      children: [
        Positioned(
          right: 10,
          bottom: 10,
          child: Icon(
            icon,
            size: isLandscape ? 120 : width * 0.2, // ícone responsivo
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
              fontSize: isLandscape ? 32 : width * 0.06, // texto responsivo
            ),
          ),
        ),
      ],
    ),
  );
}