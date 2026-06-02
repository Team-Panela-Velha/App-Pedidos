import 'package:app_pedidos/core/provider/order_provider.dart';
import 'package:app_pedidos/core/model/order/order.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/cart/account_summary.dart';
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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrdersByTab(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

    // Flatten all items from all orders to show in the cart
    final allItems = orders.expand((o) => o.items).toList();

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
                  'Minha Conta', // Mudado de Carrinho para Minha Conta
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const Spacer(),
                Text(
                  '${allItems.length} ${allItems.length == 1 ? 'item' : 'itens'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textIconSecondary,
                  ),
                ),
              ],
            ),
          ),

          // ── Lista de itens vindos do backend ──────────────────────────────
          Expanded(
            child: orderProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : allItems.isEmpty
                    ? _emptyState(context)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        itemCount: allItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = allItems[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.iconSquareColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName ?? 'Produto',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Quantidade: ${item.quantity}',
                                      style: TextStyle(
                                        color: AppColors.textIconSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),

          // ── Resumo + botão fechar conta ───────────────────────────────────
          if (allItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
              child: SimpleButton(
                onTap: () {
                  // Lógica de fechar conta
                },
                text: 'Fechar Conta',
              ),
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
          Icon(Icons.shopping_cart_outlined,
              size: 64, color: AppColors.textIconSecondary),
          const SizedBox(height: 16),
          const Text(
            'Nenhum pedido realizado',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Seus itens aparecerão aqui após\nconfirmar o pedido.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textIconSecondary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}