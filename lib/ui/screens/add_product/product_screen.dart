import 'package:app_pedidos/data/mock_data.dart';
import 'package:app_pedidos/ui/widgets/product_options.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:app_pedidos/ui/widgets/product_card.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: width * 0.9,
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AspectRatio(
                  aspectRatio: 16 / 6,
                  child: ProductCard(
                    image: widget.product.image,
                    title: widget.product.name,
                    description: widget.product.description,
                    price: widget.product.price,
                  ),
                ),

                const SizedBox(height: 20),

                const ProductOptions(),

                const SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: 300,
                    child: SimpleButton(
                      onTap: () => print('adicionado'),
                      text: 'Add to Cart',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}