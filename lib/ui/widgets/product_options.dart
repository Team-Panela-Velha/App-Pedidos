import 'package:app_pedidos/core/model/order/extra.dart';
import 'package:flutter/material.dart';

class ProductOptions extends StatefulWidget {
  final List<Extra> extras;
  final Function(List<Extra> selectedExtras, String observation) onChanged;

  const ProductOptions({
    super.key,
    required this.extras,
    required this.onChanged,
  });

  @override
  State<ProductOptions> createState() => _ProductOptionsState();
}

class _ProductOptionsState extends State<ProductOptions> {
  final Set<int> _selectedExtraIds = {};
  final TextEditingController _observationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _observationController.addListener(_notifyChanges);
  }

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  void _notifyChanges() {
    final selectedExtras = widget.extras
        .where((extra) => _selectedExtraIds.contains(extra.id))
        .toList();
    widget.onChanged(selectedExtras, _observationController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.extras.isNotEmpty) ...[
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
                      'Extras',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Escolha os extras desejados',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...widget.extras.map((extra) {
            final isSelected = _selectedExtraIds.contains(extra.id);
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(extra.name),
              subtitle: Text('+ R\$ ${extra.price.toStringAsFixed(2)}'),
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedExtraIds.add(extra.id);
                  } else {
                    _selectedExtraIds.remove(extra.id);
                  }
                  _notifyChanges();
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
            );
          }),
          const Divider(),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            const Icon(Icons.chat_bubble_outline, size: 18),
            const SizedBox(width: 6),
            const Text(
              'Alguma observação?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              '${_observationController.text.length}/140',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _observationController,
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
        ),
      ],
    );
  }
}