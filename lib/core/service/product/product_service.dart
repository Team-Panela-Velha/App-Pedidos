import 'package:app_pedidos/core/base/base_service.dart';
import 'package:app_pedidos/core/model/product.dart';
import 'package:app_pedidos/core/service/api_service.dart';
import 'package:app_pedidos/locator.dart';

class ProductService extends BaseService {
  final ApiService apiService = locator<ApiService>();

  Future<List<Product>> getProducts() async {
    final response = getResponse(await apiService.get('/products'));
    return (response['data'] as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> getProductById(int id) async {
    final response = getResponse(await apiService.get('/products/$id'));
    return Product.fromJson(response);
  }

  // Future<void> createProduct(Map<String, dynamic> body) async {
  //   await apiService.post('/products', body);
  // }

  // Future<void> updateProduct(int id, Map<String, dynamic> body) async {
  //   await apiService.put('/products/$id', body);
  // }

  // Future<void> deleteProduct(int id) async {
  //   await apiService.delete('/products/$id');
  // }
}