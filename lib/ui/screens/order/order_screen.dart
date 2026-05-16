import 'package:app_pedidos/core/cart_provider.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/screens/cart/cart_screen.dart';
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
  // Itens do pedido atual.
  // Substituir pelo estado real vindo da CategoryScreen/ProductScreen.
  final Map<String, _OrderEntry> _current = {
    '1': _OrderEntry(id: '1', name: 'X-Burguer', unitPrice: 32.90, quantity: 2),
    '7': _OrderEntry(id: '7', name: 'Refrigerante Lata', unitPrice: 7.90),
    '4': _OrderEntry(id: '4', name: 'Batata Frita P', unitPrice: 12.90),
  };

  // ── Helpers ───────────────────────────────────────────────────────────────

  int get _totalCount => _current.values.fold(0, (s, e) => s + e.quantity);

  double get _totalPrice =>
      _current.values.fold(0.0, (s, e) => s + e.unitPrice * e.quantity);

  // ── Ações ─────────────────────────────────────────────────────────────────

  void _increment(String id) => setState(() => _current[id]!.quantity++);

  void _decrement(String id) {
    setState(() {
      if (_current[id]!.quantity > 1) {
        _current[id]!.quantity--;
      } else {
        _current.remove(id);
      }
    });
  }

  void _removeItem(String id) => setState(() => _current.remove(id));

  void _sendToCart() {
    if (_current.isEmpty) return;

    final cartItems = _current.values
        .map((e) => CartItem(
              name: e.name,
              unitPrice: e.unitPrice,
              quantity: e.quantity,
            ))
        .toList();

    context.read<CartProvider>().addItems(cartItems);

    final count = _totalCount;
    setState(() => _current.clear());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('$count item(s) enviado(s) para a cozinha! 🍳'),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = _current.values.toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
            child: Row(
              children: [
                Text(
                  'Pedido',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (_totalCount > 0)
                  Text(
                    '$_totalCount ${_totalCount == 1 ? 'item' : 'itens'}',
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
                        entry: entry,
                        onIncrement: () => _increment(entry.id),
                        onDecrement: () => _decrement(entry.id),
                        onRemove: () => _removeItem(entry.id),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ── Barra inferior: total + botão realizar pedido ────────────────────
      bottomNavigationBar: _current.isEmpty
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total do pedido',
                        style: TextStyle(
                          color: AppColors.textIconSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'R\$ ${_totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SimpleButton(
                    onTap: _sendToCart,
                    text: 'Realizar Pedido',
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
// Card de item do pedido
// ---------------------------------------------------------------------------

class _OrderItemCard extends StatelessWidget {
  final _OrderEntry entry;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _OrderItemCard({
    required this.entry,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.iconSquareColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Nome + subtotal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'R\$ ${(entry.unitPrice * entry.quantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Controle de quantidade
          _QtyBtn(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${entry.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _QtyBtn(icon: Icons.add, onTap: onIncrement, filled: true),

          const SizedBox(width: 10),

          // Botão remover
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline,
                  size: 18, color: Colors.red),
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