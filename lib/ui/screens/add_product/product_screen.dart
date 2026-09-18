import 'package:app_pedidos/core/model/order/order_item.dart';
import 'package:app_pedidos/core/model/order/extra.dart';
import 'package:app_pedidos/core/model/product/product.dart';
import 'package:app_pedidos/core/provider/order_provider.dart';
import 'package:app_pedidos/core/service/product/product_service.dart';
import 'package:app_pedidos/ui/widgets/product_options.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:app_pedidos/ui/widgets/product_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _quantity = 1;
  List<Extra> _selectedExtras = [];
  String _observation = '';
  Product? _product;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final product = await ProductService().getProductById(widget.product.id);
      if (mounted) setState(() => _product = product);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Não foi possível carregar o produto.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _addToCart() {
    final product = _product;
    if (product == null || !product.available) return;
    final orderProvider = context.read<OrderProvider>();

    final item = OrderItem(
      productId: product.id,
      productName: product.name,
      productImage: product.image,
      unitPrice: product.price,
      quantity: _quantity,
      observation: _observation.isEmpty ? null : _observation,
      extras: _selectedExtras,
    );

    orderProvider.addItemToPending(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} adicionado ao pedido!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  TextButton(
                    onPressed: _loadProduct,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SizedBox(
                  width: 1000,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductCard(product: _product!),
                        if (!_product!.available)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text('Produto indisponível no momento.'),
                          ),
                        const SizedBox(height: 24),

                        // Controle de quantidade
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _qtyBtn(Icons.remove, () {
                              if (_quantity > 1) setState(() => _quantity--);
                            }),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _qtyBtn(
                              Icons.add,
                              () => setState(() => _quantity++),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        ProductOptions(
                          extras: _product!.extras,
                          onChanged: (selectedExtras, observation) {
                            setState(() {
                              _selectedExtras = selectedExtras;
                              _observation = observation;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            'Total estimado: R\$ ${((_product!.price + _selectedExtras.fold<double>(0, (sum, extra) => sum + extra.price)) * _quantity).toStringAsFixed(2)}',
                          ),
                        ),

                        Center(
                          child: _product!.available
                              ? SimpleButton(
                                  onTap: _addToCart,
                                  text: 'Adicionar ao Pedido',
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFD9A38F).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFFD9A38F)),
      ),
    );
  }
}
