import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';

class AccountSummary extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCloseAccount;

  const AccountSummary({super.key, 
    required this.totalPrice,
    required this.onCloseAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                    fontSize: 14, color: AppColors.textIconSecondary),
              ),
              Text(
                'R\$ ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 14, color: AppColors.textIconSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Divider(color: AppColors.textIconSecondary.withOpacity(0.15)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'R\$ ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SimpleButton(
            onTap: onCloseAccount,
            text: 'Fechar Conta',
          ),
        ],
      ),
    );
  }
}