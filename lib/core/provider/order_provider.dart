import 'dart:math';

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
  String? _submissionId;

  List<Order> _orders = [];
  model.Tab? _currentTab;
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  model.Tab? get currentTab => _currentTab;
  List<OrderItem> get pendingItems => List.unmodifiable(_pendingItems);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void addItemToPending(OrderItem item) {
    if (_isLoading) return;
    _pendingItems.add(item);
    _submissionId = null;
    notifyListeners();
  }

  void removeItemFromPending(int index) {
    if (_isLoading) return;
    if (index < 0 || index >= _pendingItems.length) return;
    _pendingItems.removeAt(index);
    _submissionId = null;
    notifyListeners();
  }

  void replacePendingItem(int index, OrderItem item) {
    if (_isLoading) return;
    if (index < 0 || index >= _pendingItems.length) return;
    _pendingItems[index] = item;
    _submissionId = null;
    notifyListeners();
  }

  void updatePendingItemQuantity(int index, int quantity) {
    if (_isLoading) return;
    if (index >= 0 && index < _pendingItems.length) {
      if (quantity <= 0) {
        _pendingItems.removeAt(index);
      } else {
        final existingItem = _pendingItems[index];
        _pendingItems[index] = OrderItem(
          productId: existingItem.productId,
          productName: existingItem.productName,
          productImage: existingItem.productImage,
          unitPrice: existingItem.unitPrice,
          quantity: quantity,
          observation: existingItem.observation,
          extras: existingItem.extras,
        );
      }
      _submissionId = null;
      notifyListeners();
    }
  }

  void clearPendingItems() {
    _pendingItems.clear();
    _submissionId = null;
    notifyListeners();
  }

  void resetSession() {
    _pendingItems.clear();
    _orders = [];
    _currentTab = null;
    _submissionId = null;
    _error = null;
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
    if (_isLoading) return;
    final tabId = _appData.tabId;
    if (tabId == null) throw Exception('Nenhuma mesa ativa selecionada');

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Criar o pedido com todos os itens em uma única requisição
      _submissionId ??=
          '${DateTime.now().microsecondsSinceEpoch}-${List.generate(4, (_) => Random.secure().nextInt(0x100000000).toRadixString(16).padLeft(8, '0')).join()}';
      await _service.createOrder(tabId, items, clientRequestId: _submissionId);
      _pendingItems.clear();
      _submissionId = null;
      notifyListeners();

      // 2. Atualizar lista de pedidos
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
