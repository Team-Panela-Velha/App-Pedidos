import 'package:app_pedidos/core/model/order/extra.dart';

class OrderItem {
  final int? id;
  final int productId;
  final String? productName;
  final int? orderId;
  final int quantity;
  final String? observation;
  final List<Extra> extras;

  OrderItem({
    this.id,
    required this.productId,
    this.productName,
    this.orderId,
    required this.quantity,
    this.observation,
    this.extras = const [],
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      orderId: json['orderId'],
      quantity: json['quantity'],
      observation: json['observation'],
      extras: json['extras'] != null
          ? (json['extras'] as List).map((i) => Extra.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'productId': productId,
      if (productName != null) 'productName': productName,
      if (orderId != null) 'orderId': orderId,
      'quantity': quantity,
      'observation': observation,
      // 'extras': extras.map((e) => e.toJson()).toList(), // Se o backend aceitar extras no request
    };
  }
}
