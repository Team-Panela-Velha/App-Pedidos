import 'package:app_pedidos/core/base/base_service.dart';
import 'package:app_pedidos/core/model/order/order.dart';
import 'package:app_pedidos/core/model/order/order_item.dart';
import 'package:app_pedidos/core/service/api_service.dart';

class OrderService extends BaseService {
  final ApiService _api = ApiService();

  Future<Order> createOrder(int tabId) async {
    final response = await _api.post('/orders', body: {'tabId': tabId});
    final data = getResponse(response);
    return Order.fromJson(data);
  }

  Future<List<Order>> getOrdersByTab(int tabId) async {
    final response = await _api.get('/orders/by-tab/$tabId');
    final data = getResponse(response);
    final List list = data['data'] ?? [];
    return list.map((json) => Order.fromJson(json)).toList();
  }

  Future<OrderItem> addOrderItem(OrderItem item) async {
    final response = await _api.post('/order-items', body: item.toJson());
    final data = getResponse(response);
    return OrderItem.fromJson(data);
  }

  Future<List<OrderItem>> getOrderItems(int orderId) async {
    final response = await _api.get('/order-items/by-order/$orderId');
    final data = getResponse(response);
    final List list = data['data'] ?? [];
    return list.map((json) => OrderItem.fromJson(json)).toList();
  }
}
