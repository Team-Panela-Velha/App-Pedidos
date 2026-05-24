import 'package:app_pedidos/core/cart_provider.dart';
import 'package:app_pedidos/theme/app_colors.dart';
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
                        _CartItemCard(item: items[index]),
                  ),
          ),

          // ── Resumo + botão fechar conta ───────────────────────────────────
          if (items.isNotEmpty)
            _AccountSummary(
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

// ---------------------------------------------------------------------------
// Card de item
// ---------------------------------------------------------------------------

class _CartItemCard extends StatelessWidget {
  final CartItem item;

  const _CartItemCard({required this.item});

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

// ---------------------------------------------------------------------------
// Resumo da conta + botão fechar
// ---------------------------------------------------------------------------

class _AccountSummary extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCloseAccount;

  const _AccountSummary({
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