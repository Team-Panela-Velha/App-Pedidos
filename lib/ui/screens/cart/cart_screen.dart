import 'package:app_pedidos/core/provider/cart_provider.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/cart/account_summary.dart';
import 'package:app_pedidos/ui/widgets/cart/cart_item_card.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ---------------------------------------------------------------------------
// Modelos (mantidos aqui pois já existiam neste arquivo)
// ---------------------------------------------------------------------------

class CartAdditional {
  final String name;
  final double price;

  const CartAdditional({required this.name, required this.price});
}

class CartItem {
  final String name;
  final String? imageAsset;
  final double unitPrice;
  final int quantity;
  final String? observation;
  final List<CartAdditional> additionals;

  const CartItem({
    required this.name,
    this.imageAsset,
    required this.unitPrice,
    required this.quantity,
    this.observation,
    this.additionals = const [],
  });

  double get additionalsTotal =>
      additionals.fold(0, (sum, a) => sum + a.price);

  double get total => (unitPrice + additionalsTotal) * quantity;
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final totalPrice = cart.totalPrice;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 8),
            child: Row(
              children: [
                Text(
                  'Carrinho',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const Spacer(),
                Text(
                  '${items.length} ${items.length == 1 ? 'item' : 'itens'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textIconSecondary,
                  ),
                ),
              ],
            ),
          ),

          // ── Lista de itens ────────────────────────────────────────────────
          Expanded(
            child: items.isEmpty
                ? _emptyState(context)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        CartItemCard(item: items[index]),
                  ),
          ),

          // ── Resumo + botão fechar conta ───────────────────────────────────
          if (items.isNotEmpty)
            AccountSummary(
              totalPrice: totalPrice,
              onCloseAccount: () => _confirmCloseAccount(context, cart),
            ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 64, color: AppColors.textIconSecondary),
          const SizedBox(height: 16),
          Text(
            'Nenhum pedido realizado ainda',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textIconSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vá em "Pedido" para adicionar itens',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textIconSecondary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCloseAccount(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Fechar conta?'),
        content: Text(
          'Total: R\$ ${cart.totalPrice.toStringAsFixed(2)}\n\nDeseja finalizar e fechar a conta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              cart.closeAccount();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Conta fechada com sucesso!'),
                    ],
                  ),
                  backgroundColor: Colors.green.shade700,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Fechar conta'),
          ),
        ],
      ),
    );
  }
}