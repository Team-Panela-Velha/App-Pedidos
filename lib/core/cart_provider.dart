// temporario

import 'package:flutter/material.dart';
import 'package:app_pedidos/ui/screens/cart/cart_screen.dart';

/// Provider central — compartilhado entre OrderScreen e CartScreen.
/// A OrderScreen adiciona itens; a CartScreen os exibe e fecha a conta.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalItemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get totalPrice => _items.fold(0.0, (sum, i) => sum + i.total);

  /// Chamado pela OrderScreen ao confirmar um pedido.
  /// Acumula os itens na conta (agrupa por nome se já existir).
  void addItems(List<CartItem> newItems) {
    for (final newItem in newItems) {
      final idx = _items.indexWhere((i) => i.name == newItem.name);
      if (idx >= 0) {
        final old = _items[idx];
        _items[idx] = CartItem(
          name: old.name,
          imageAsset: old.imageAsset,
          unitPrice: old.unitPrice,
          quantity: old.quantity + newItem.quantity,
          observation: old.observation,
          additionals: old.additionals,
        );
      } else {
        _items.add(newItem);
      }
    }
    notifyListeners();
  }

  /// Fecha a conta — limpa tudo.
  void closeAccount() {
    _items.clear();
    notifyListeners();
  }
}