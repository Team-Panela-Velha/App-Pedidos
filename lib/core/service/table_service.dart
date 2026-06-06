import 'package:app_pedidos/core/base/base_service.dart';
import 'package:app_pedidos/core/model/table_model.dart';
import 'package:app_pedidos/core/service/api_service.dart';

class TableService extends BaseService {
  final ApiService _api = ApiService();

  Future<TableModel> getTableByCode(String code) async {
    final response = await _api.get('/tables/code/$code');
    final data = getResponse(response);
    return TableModel.fromJson(data);
  }

  Future<List<TableModel>> getAllTables() async {
    final response = await _api.get('/tables');
    final data = getResponse(response);
    final List list = data['data'] ?? [];
    return list.map((json) => TableModel.fromJson(json)).toList();
  }
}
