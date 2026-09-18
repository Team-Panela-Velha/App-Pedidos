import 'package:app_pedidos/core/provider/order_provider.dart';
import 'package:app_pedidos/core/service/tab_service.dart';
import 'package:app_pedidos/core/bloc/app/app_bloc.dart';
import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/cart/account_summary.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  double get additionalsTotal => additionals.fold(0, (sum, a) => sum + a.price);

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
  bool _isClosing = false;

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
                IconButton(
                  tooltip: 'Atualizar conta',
                  onPressed: orderProvider.isLoading ? null : orderProvider.fetchOrdersByTab,
                  icon: const Icon(Icons.refresh),
                ),
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
                : orderProvider.error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Não foi possível atualizar sua conta.'),
                        TextButton(
                          onPressed: orderProvider.fetchOrdersByTab,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  )
                : allItems.isEmpty
                ? _emptyState(context)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: allItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = allItems[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.iconSquareColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _ProductImage(
                              imageUrl: item.productImage,
                              size: 72,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.productName ?? 'Produto',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'Qtd: ${item.quantity}',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item.observation != null &&
                                      item.observation!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      'Obs: ${item.observation}',
                                      style: TextStyle(
                                        color: AppColors.textIconSecondary,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  if (item.extras.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Extras: ${item.extras.map((e) => e.name).join(', ')}',
                                      style: TextStyle(
                                        color: AppColors.textIconSecondary,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                      Text('Status: ${item.statusLabel}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // ── Resumo + botão fechar conta ───────────────────────────────────
          if (orderProvider.currentTab != null && !orderProvider.currentTab!.closed)
            _isClosing
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : AccountSummary(
                    totalPrice: orderProvider.currentTab?.totalValue ?? 0.0,
                    onCloseAccount: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Fechar comanda?'),
                          content: Text(
                          orderProvider.pendingItems.isEmpty
                              ? 'Depois de fechada, a comanda não poderá receber novos pedidos.'
                              : 'Itens ainda não enviados serão descartados. Depois de fechada, a comanda não poderá receber novos pedidos.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Voltar'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                      if (confirm != true || !context.mounted) return;
                      final appBloc = context.read<AppBloc>();
                      final tabId = appBloc.appData.tabId;

                      if (tabId == null) return;

                      setState(() => _isClosing = true);

                      try {
                        final tabService = TabService();
                        await tabService.closeTab(tabId);

                        if (context.mounted) {
                          context.read<OrderProvider>().resetSession();
                          appBloc.endSession();
                          context.go(Routes.startSession);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao fechar conta: $e')),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isClosing = false);
                      }
                    },
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
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppColors.textIconSecondary,
          ),
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

// ---------------------------------------------------------------------------
// Widget de imagem do produto com loading e erro
// ---------------------------------------------------------------------------

class _ProductImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const _ProductImage({required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade100, Colors.grey.shade200],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null || imageUrl!.isEmpty
          ? Center(
              child: Icon(
                Icons.restaurant_menu,
                size: size * 0.45,
                color: Colors.grey.shade400,
              ),
            )
          : Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              width: size,
              height: size,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: SizedBox(
                    width: size * 0.4,
                    height: size * 0.4,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: size * 0.45,
                    color: Colors.grey.shade400,
                  ),
                );
              },
            ),
    );
  }
}
