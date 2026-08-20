import 'package:app_pedidos/core/base/base_service.dart';
import 'package:app_pedidos/core/model/order/order.dart';
import 'package:app_pedidos/core/model/order/order_item.dart';
import 'package:app_pedidos/core/service/api_service.dart';

class OrderService extends BaseService {
  final ApiService _api = ApiService();

  Future<Order> createOrder(int tabId, List<OrderItem> items) async {
    final response = await _api.post('/orders', body: {
      'tabId': tabId,
      'items': items.map((item) => item.toJson()).toList(),
    });
    final data = getResponse(response);
    return Order.fromJson(data);
  }

  Future<List<Order>> getOrdersByTab(int tabId) async {
    final response = await _api.get('/orders/tab/$tabId');
    final data = getResponse(response);
    final List list = data['data'] ?? []; // BaseService wraps list in { "data": [...] }
    return list.map((json) => Order.fromJson(json)).toList();
  }

  Future<List<OrderItem>> getOrderItems(int orderId) async {
    final response = await _api.get('/order-items/by-order/$orderId');
    final data = getResponse(response);
    final List list = data['data'] ?? [];
    return list.map((json) => OrderItem.fromJson(json)).toList();
  }
}
