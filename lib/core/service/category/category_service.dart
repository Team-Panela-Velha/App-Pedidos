import 'package:app_pedidos/core/base/base_service.dart';
import 'package:app_pedidos/core/model/category.dart';
import 'package:app_pedidos/core/service/api_service.dart';
import 'package:app_pedidos/locator.dart';

class CategoryService extends BaseService {
  final ApiService apiService = locator<ApiService>();

  Future<List<Category>> getCategories() async {
    final response = getResponse(await apiService.get('/categories'));
    return (response['data'] as List).map((e) => Category.fromJson(e)).toList();
  }
}
