import 'package:flutter/material.dart';
import 'package:app_pedidos/theme/app_colors.dart';

class SimpleButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final bool isLoading;

  const SimpleButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 240,
        height: 52,
        decoration: BoxDecoration(
          color: isLoading ? AppColors.primary.withOpacity(0.6) : AppColors.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
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