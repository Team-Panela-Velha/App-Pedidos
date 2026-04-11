import 'package:app_pedidos/theme/app_colors.dart';
import 'package:flutter/material.dart';

Widget categoryItem(BuildContext context, IconData icon, String label) {
  final width = MediaQuery.of(context).size.width;
  final orientation = MediaQuery.of(context).orientation;
  final isLandscape = orientation == Orientation.landscape;

  return Container(
    width: isLandscape ? 140 : width * 0.40, // responsivo com ternário e width
    margin: EdgeInsets.only(right: isLandscape ? 32 : width * 0.04),
    decoration: BoxDecoration(
      color: AppColors.secondary,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: isLandscape ? 30 : width * 0.06, // ícone responsivo
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: isLandscape ? 16 : width * 0.03, // fonte responsiva
            color: AppColors.textPrimary,
          ),
        ),
      ],
    ),
  );
}