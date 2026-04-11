import 'package:app_pedidos/ui/widgets/product_options.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:app_pedidos/ui/widgets/product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

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
                  image: 'images/sushi.jpg',
                  title: 'Luxe Lounge Sofa',
                  description: 'Lorem ipsum...',
                  price: '\$220.00',
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