import 'package:app_pedidos/core/model/order/order_item.dart';

class Order {
  final int id;
  final int tabId;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.tabId,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      tabId: json['tabId'],
      items: json['items'] != null
          ? (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tabId': tabId,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}
