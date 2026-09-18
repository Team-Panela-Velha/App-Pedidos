import 'package:app_pedidos/core/base/base_service.dart';
import 'package:app_pedidos/core/model/product/product.dart';
import 'package:app_pedidos/core/service/api_service.dart';
import 'package:app_pedidos/locator.dart';

class ProductService extends BaseService {
  final ApiService apiService = locator<ApiService>();

  Future<List<Product>> getProducts() async {
    final response = getResponse(await apiService.get('/products'));
    return (response['data'] as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response = getResponse(
      await apiService.get('/products/category/$categoryId?available=true'),
    );
    return (response['data'] as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> searchProducts({
    String? keyword,
    int? categoryId,
    bool? available,
  }) async {
    final query = <String, String>{
      if (keyword != null && keyword.trim().isNotEmpty)
        'keyword': keyword.trim(),
      if (categoryId != null) 'categoryId': '$categoryId',
      if (available != null) 'available': '$available',
    };
    final uri = Uri(path: '/products/search', queryParameters: query);
    final response = getResponse(await apiService.get(uri.toString()));
    return (response['data'] as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> getProductById(int id) async {
    final response = getResponse(await apiService.get('/products/$id'));
    return Product.fromJson(response);
  }

  Future<Product> createProduct({
    required String name,
    required double price,
    String? description,
    String? image,
    int? categoryId,
    bool available = true,
  }) async {
    final response = getResponse(
      await apiService.post(
        '/products',
        body: {
          'name': name,
          'price': price,
          'description': description,
          'image': image,
          'categoryId': categoryId,
          'available': available,
        },
      ),
    );
    return Product.fromJson(response);
  }

  Future<void> updateProduct(int id, Map<String, dynamic> body) async {
    await apiService.put('/products/$id', body: body);
  }

  Future<void> deleteProduct(int id) async {
    await apiService.delete('/products/$id');
  }
}
