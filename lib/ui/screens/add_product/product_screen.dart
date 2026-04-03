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
                    description: 'Lorem ipsum dolor sit amet...',
                  ),
                ),

                const SizedBox(height: 16),

                const Divider(
                  color: Color(0xFFF4B5A4),
                  thickness: 2,
                ),

                const SizedBox(height: 12),

                // 🔥 PREÇO COM PADDING
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '\$220.00',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD9A38F),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '8 Units',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔥 OPTIONS
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