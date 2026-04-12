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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 1000,
            child: SingleChildScrollView( 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: ProductCard(
                  image: widget.product.image,
                  title: widget.product.name,
                  description: widget.product.description,
                  price: widget.product.price,
                )
              ),
                const SizedBox(height: 16),
                const ProductOptions(),
                const SizedBox(height: 16),    
                // ignore: avoid_print
                Center(child: SimpleButton(onTap:() => print('adicionado'), text: 'Add to Card'))
              ],
            ),
          ),
          
        ),
      ),
      ),
    );
  }
}