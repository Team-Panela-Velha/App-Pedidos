import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.iconSquareColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome + quantidade + preço
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${item.quantity}x',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                'R\$ ${item.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),

          // Adicionais
          if (item.additionals.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...item.additionals.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline,
                        size: 13, color: AppColors.textIconSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        a.name,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textIconSecondary),
                      ),
                    ),
                    Text(
                      '+R\$ ${a.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textIconSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Observação
          if (item.observation != null && item.observation!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 13,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.observation!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}