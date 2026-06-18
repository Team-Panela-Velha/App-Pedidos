import 'package:app_pedidos/core/bloc/app/app_data.dart';
import 'package:app_pedidos/core/model/order/order.dart';
import 'package:app_pedidos/core/model/order/order_item.dart';
import 'package:app_pedidos/core/model/tab/tab.dart' as model;
import 'package:app_pedidos/core/service/order_service.dart';
import 'package:app_pedidos/core/service/tab_service.dart';
import 'package:app_pedidos/locator.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  final TabService _tabService = TabService();
  final AppData _appData = locator.get<AppData>();

  // Itens que estão sendo montados para o pedido atual
  final List<OrderItem> _pendingItems = [];
  
  List<Order> _orders = [];
  model.Tab? _currentTab;
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  model.Tab? get currentTab => _currentTab;
  List<OrderItem> get pendingItems => _pendingItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void addItemToPending(OrderItem item) {
    // Verifica se já existe o produto no pedido pendente
    final index = _pendingItems.indexWhere((i) => i.productId == item.productId);
    if (index != -1) {
      final existingItem = _pendingItems[index];
      _pendingItems[index] = OrderItem(
        productId: existingItem.productId,
        productName: existingItem.productName,
        quantity: existingItem.quantity + item.quantity,
        observation: item.observation ?? existingItem.observation,
      );
    } else {
      _pendingItems.add(item);
    }
    notifyListeners();
  }

  void removeItemFromPending(int productId) {
    _pendingItems.removeWhere((i) => i.productId == productId);
    notifyListeners();
  }

  void updatePendingItemQuantity(int productId, int quantity) {
    final index = _pendingItems.indexWhere((i) => i.productId == productId);
    if (index != -1) {
      if (quantity <= 0) {
        _pendingItems.removeAt(index);
      } else {
        final existingItem = _pendingItems[index];
        _pendingItems[index] = OrderItem(
          productId: existingItem.productId,
          productName: existingItem.productName,
          quantity: quantity,
          observation: existingItem.observation,
        );
      }
      notifyListeners();
    }
  }

  void clearPendingItems() {
    _pendingItems.clear();
    notifyListeners();
  }

  /// Busca todos os pedidos de uma mesa (tab)
  Future<void> fetchOrdersByTab() async {
    final tabId = _appData.tabId;
    if (tabId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getOrdersByTab(tabId),
        _tabService.getTabById(tabId),
      ]);
      _orders = results[0] as List<Order>;
      _currentTab = results[1] as model.Tab;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cria um novo pedido e adiciona os itens a ele
  Future<void> placeOrder(List<OrderItem> items) async {
    final tabId = _appData.tabId;
    if (tabId == null) throw Exception('Nenhuma mesa ativa selecionada');

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Criar o pedido (Order)
      final newOrder = await _service.createOrder(tabId);

      // 2. Adicionar cada item ao pedido
      for (var item in items) {
        final itemWithOrder = OrderItem(
          productId: item.productId,
          orderId: newOrder.id,
          quantity: item.quantity,
          observation: item.observation,
        );
        try {
          await _service.addOrderItem(itemWithOrder);
        } catch (e) {
          print('Erro ao adicionar item ${item.productName}: $e');
          // Opcional: deletar o pedido se um item falhar, ou continuar
          rethrow;
        }
      }

      // 3. Atualizar lista de pedidos
      await fetchOrdersByTab();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
