import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text; 
  
  const SimpleButton({
    super.key,
    required this.onTap,
    required this.text, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFDFA28F),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text, 
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB46A57),
            ),
          ),
        ),
      ),
    );
  }
}