import 'package:flutter/material.dart';
import 'package:app_pedidos/theme/app_colors.dart';

class SimpleButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text; 
  
  const SimpleButton({
    super.key,
    required this.onTap,
    required this.text, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text, 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textIconPrimary,
            ),
          ),
        ),
      ),
    );
  }
}