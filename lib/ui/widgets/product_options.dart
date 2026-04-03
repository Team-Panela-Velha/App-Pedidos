import 'package:flutter/material.dart';

class ProductOptions extends StatefulWidget {
  const ProductOptions({super.key});

  @override
  State<ProductOptions> createState() => _ProductOptionsState();
}

class _ProductOptionsState extends State<ProductOptions> {
  int selectedOption = 0;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Quantidade hot roll',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Escolha 1 opção',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'OBRIGATÓRIO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 🔥 OPÇÃO
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Quero em dobro (total 10un)'),
          subtitle: const Text('+ R\$ 10,00'),
          trailing: Radio(
            value: 1,
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
        ),

        const Divider(),

        const SizedBox(height: 12),

        
        Row(
          children: const [
            Icon(Icons.chat_bubble_outline, size: 18),
            SizedBox(width: 6),
            Text(
              'Alguma observação?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Text(
              '0/140',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          maxLength: 140,
          decoration: InputDecoration(
            hintText: 'Ex: tirar a cebola, maionese à parte etc.',
            counterText: '', // remove contador padrão
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (text) {
            setState(() {});
          },
        ),
      ],
    );
  }
}