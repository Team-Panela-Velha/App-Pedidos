import 'package:app_pedidos/core/model/order/order_item.dart';
import 'package:app_pedidos/core/provider/order_provider.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ---------------------------------------------------------------------------
// Modelo interno do pedido em andamento
// ---------------------------------------------------------------------------

class _OrderEntry {
  final String id;
  final String name;
  final double unitPrice;
  int quantity;

  _OrderEntry({
    required this.id,
    required this.name,
    required this.unitPrice,
    this.quantity = 1,
  });
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // Removendo itens mockados e usando os do OrderProvider

  // ── Ações ─────────────────────────────────────────────────────────────────

  void _increment(int productId) {
    final orderProvider = context.read<OrderProvider>();
    final item = orderProvider.pendingItems.firstWhere((i) => i.productId == productId);
    orderProvider.updatePendingItemQuantity(productId, item.quantity + 1);
  }

  void _decrement(int productId) {
    final orderProvider = context.read<OrderProvider>();
    final item = orderProvider.pendingItems.firstWhere((i) => i.productId == productId);
    orderProvider.updatePendingItemQuantity(productId, item.quantity - 1);
  }

  void _removeItem(int productId) {
    context.read<OrderProvider>().removeItemFromPending(productId);
  }

  Future<void> _placeOrder() async {
    final orderProvider = context.read<OrderProvider>();
    if (orderProvider.pendingItems.isEmpty) return;

    try {
      // O OrderProvider agora usa o tabId dinâmico do AppData
      await orderProvider.placeOrder(orderProvider.pendingItems);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Pedido enviado para a cozinha! 🍳'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Limpa itens pendentes após sucesso
        orderProvider.clearPendingItems();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar pedido: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderProvider = context.watch<OrderProvider>();
    final entries = orderProvider.pendingItems;

    final totalCount = entries.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // ... (mesmo header)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
            child: Row(
              children: [
                Text(
                  'Pedido Atual',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (totalCount > 0)
                  Text(
                    '$totalCount ${totalCount == 1 ? 'item' : 'itens'}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textIconSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // ── Lista ou estado vazio ────────────────────────────────────────
          Expanded(
            child: entries.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                          final entry = entries[index];
                          return _OrderItemCard(
                            name: entry.productName ?? 'Produto',
                            productImage: entry.productImage,
                            quantity: entry.quantity,
                            observation: entry.observation,
                            extras: entry.extras,
                            onIncrement: () => _increment(entry.productId),
                            onDecrement: () => _decrement(entry.productId),
                            onRemove: () => _removeItem(entry.productId),
                          );
                        },
                  ),
          ),
        ],
      ),

      // ── Barra inferior: total + botão realizar pedido ────────────────────
      bottomNavigationBar: entries.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SimpleButton(
                    onTap: _placeOrder,
                    text: 'Enviar para Cozinha',
                    isLoading: orderProvider.isLoading,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: AppColors.textIconSecondary),
          const SizedBox(height: 16),
          Text(
            'Nenhum item no pedido',
            style: TextStyle(fontSize: 16, color: AppColors.textIconSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione itens pelas categorias',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textIconSecondary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card de item do pedido (atualizado para ser genérico)
// ---------------------------------------------------------------------------

class _OrderItemCard extends StatelessWidget {
  final String name;
  final String? productImage;
  final int quantity;
  final String? observation;
  final List<dynamic> extras;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _OrderItemCard({
    required this.name,
    this.productImage,
    required this.quantity,
    this.observation,
    this.extras = const [],
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.iconSquareColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (productImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                productImage!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, color: Colors.grey),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (observation != null && observation!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Obs: $observation',
                    style: TextStyle(
                      color: AppColors.textIconSecondary,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (extras.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Extras: ${extras.map((e) => e.name).join(', ')}',
                    style: TextStyle(
                      color: AppColors.textIconSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _QtyBtn(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _QtyBtn(icon: Icons.add, onTap: onIncrement, filled: true),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Botão +/-
// ---------------------------------------------------------------------------

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QtyBtn({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: filled ? color : color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: filled ? Colors.white : color),
      ),
    );
  }
}