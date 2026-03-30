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
          child:
            SizedBox(
              width: 1100,
              height: 600,
              child: ProductCard(
                image: 'images/sushi.jpg',
                title: 'Luxe Lounge Sofa',
                description:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
              ),
            ),
          ),
        ),
    );
  }
}