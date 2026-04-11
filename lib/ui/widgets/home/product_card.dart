import 'package:flutter/material.dart';

Widget productCard(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.grey.shade100,
    ),
    child: Column(
      children: [
        Expanded(
          child: Icon(
            Icons.chair,
            size: isLandscape ? 80 : width * 0.12, // ícone responsivo
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Cadeira Moderna",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isLandscape ? 18 : width * 0.035, // fonte responsiva
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            "R\$ 199,00",
            style: TextStyle(
              fontSize: isLandscape ? 16 : width * 0.03, // fonte responsiva
            ),
          ),
        ),
      ],
    ),
  );
}