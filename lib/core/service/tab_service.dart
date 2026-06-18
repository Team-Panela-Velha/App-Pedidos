import 'package:app_pedidos/core/base/base_service.dart';
import 'package:app_pedidos/core/model/tab/tab.dart';
import 'package:app_pedidos/core/service/api_service.dart';

class TabService extends BaseService {
  final ApiService _api = ApiService();

  Future<Tab> startTab(String tableCode) async {
    final response = await _api.post('/tabs/start', body: {'tableCode': tableCode});
    final data = getResponse(response);
    return Tab.fromJson(data);
  }

  Future<Tab> closeTab(int id) async {
    final response = await _api.patch('/tabs/$id/close');
    final data = getResponse(response);
    return Tab.fromJson(data);
  }

  Future<Tab> getTabById(int id) async {
    final response = await _api.get('/tabs/$id');
    final data = getResponse(response);
    return Tab.fromJson(data);
  }
}
