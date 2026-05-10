import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Mock models (remova quando integrar com os models reais)
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
// Mock data
// ---------------------------------------------------------------------------

final _cartMock = [
  CartItem(
    name: 'X-Burguer',
    unitPrice: 28.90,
    quantity: 2,
    observation: 'Sem cebola',
    additionals: [
      CartAdditional(name: 'Bacon extra', price: 4.00),
      CartAdditional(name: 'Queijo duplo', price: 3.50),
    ],
  ),
  CartItem(
    name: 'Batata Frita G',
    unitPrice: 16.00,
    quantity: 1,
    additionals: [
      CartAdditional(name: 'Cheddar', price: 5.00),
    ],
  ),
  CartItem(
    name: 'Suco de Laranja',
    unitPrice: 9.00,
    quantity: 3,
    observation: 'Com pouco gelo',
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  double get _subtotal => _cartMock.fold(0, (sum, i) => sum + i.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.iconSquareColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 16, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Carrinho',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const Spacer(),
                Text(
                  '${_cartMock.length} ${_cartMock.length == 1 ? 'item' : 'itens'}',
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
            child: _cartMock.isEmpty
                ? _emptyState(context)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: _cartMock.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _CartItemCard(item: _cartMock[index]),
                  ),
          ),

          // ── Resumo + botão ────────────────────────────────────────────────
          if (_cartMock.isNotEmpty)
            _OrderSummary(subtotal: _subtotal),
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
            'Seu carrinho está vazio',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textIconSecondary,
            ),
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
          // Nome + quantidade + preço unitário
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge de quantidade
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

              // Nome
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

              // Preço total do item
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
                          fontSize: 12,
                          color: AppColors.textIconSecondary,
                        ),
                      ),
                    ),
                    Text(
                      '+R\$ ${a.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textIconSecondary,
                      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.07),
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
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
// Resumo e botão de pedido
// ---------------------------------------------------------------------------

class _OrderSummary extends StatelessWidget {
  final double subtotal;

  const _OrderSummary({required this.subtotal});

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
          // Linha subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textIconSecondary,
                ),
              ),
              Text(
                'R\$ ${subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textIconSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Divider(color: AppColors.textIconSecondary.withOpacity(0.15)),
          const SizedBox(height: 6),

          // Linha total
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
                'R\$ ${subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // TODO: integrar com service de pedido
          SimpleButton(
            onTap: () {},
            text: 'Realizar pedido',
          ),
        ],
      ),
    );
  }
}