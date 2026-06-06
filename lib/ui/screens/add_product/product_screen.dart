import 'package:app_pedidos/core/model/order/order_item.dart';
import 'package:app_pedidos/core/model/product/product.dart';
import 'package:app_pedidos/core/provider/order_provider.dart';
import 'package:app_pedidos/router.dart';
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

  void _addToCart() {
    final orderProvider = context.read<OrderProvider>();
    
    final item = OrderItem(
      productId: widget.product.id,
      productName: widget.product.name,
      quantity: _quantity,
      // observation pode vir de um campo de texto futuro
    );

    orderProvider.addItemToPending(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} adicionado ao pedido!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    
    if (mounted) {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SizedBox(
            width: 1000,
            child: SingleChildScrollView( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductCard(product: widget.product),
                  const SizedBox(height: 24),
                  
                  // Controle de quantidade
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _qtyBtn(Icons.remove, () {
                        if (_quantity > 1) setState(() => _quantity--);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _qtyBtn(Icons.add, () => setState(() => _quantity++)),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const ProductOptions(),
                  const SizedBox(height: 32),    
                  
                  Center(
                    child: SimpleButton(
                      onTap: _addToCart, 
                      text: 'Adicionar ao Pedido',
                    ),
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