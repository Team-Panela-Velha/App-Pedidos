import 'package:app_pedidos/core/model/order/extra.dart';

class OrderItem {
  final int? id;
  final int productId;
  final String? productName;
  final String? productImage;
  final double? unitPrice;
  final int? orderId;
  final int quantity;
  final String? observation;
  final String? status;
  final List<Extra> extras;

  OrderItem({
    this.id,
    required this.productId,
    this.productName,
    this.productImage,
    this.unitPrice,
    this.orderId,
    required this.quantity,
    this.observation,
    this.status,
    this.extras = const [],
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      unitPrice: (json['unitPriceSnapshot'] as num?)?.toDouble(),
      orderId: json['orderId'],
      quantity: json['quantity'],
      observation: json['observation'],
      status: json['status'],
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
      'extraIds': extras.map((e) => e.id).toList(),
    };
  }

  double get estimatedTotal =>
      ((unitPrice ?? 0) +
              extras.fold<double>(0, (sum, extra) => sum + extra.price)) *
          quantity;

  String get statusLabel => switch (status) {
    'RECEIVED' => 'Recebido',
    'IN_PREPARATION' => 'Em preparo',
    'READY' => 'Pronto',
    'DELIVERED' => 'Entregue',
    'CANCELLED' => 'Cancelado',
    _ => 'Aguardando atualização',
  };
}
