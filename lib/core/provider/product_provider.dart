import 'package:app_pedidos/core/model/product.dart';
import 'package:app_pedidos/core/service/product/product_service.dart';
import 'package:app_pedidos/locator.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService productService = locator<ProductService>();

  List<Product> _products = [];

  bool _isLoading = false;

  String? _error;

  List<Product> get products => _products;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> getProducts() async {
    try {
      _isLoading = true;
      _error = null;

      notifyListeners();

      _products = await productService.getProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}