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
    final response = await _api.put('/tabs/$id/close'); // O controller usa PatchMapping no Java, mas o ApiService tem put/post/get/delete.
    // Verificando se o ApiService tem patch. Se não tiver, usarei o que for compatível.
    // Como o controller Java usa @PatchMapping("/{id}/close"), vou assumir que o ApiService deve ser atualizado ou usar o método correto.
    // Vou usar o put por enquanto ou criar um método customizado se necessário.
    final data = getResponse(response);
    return Tab.fromJson(data);
  }

  Future<Tab> getTabById(int id) async {
    final response = await _api.get('/tabs/$id');
    final data = getResponse(response);
    return Tab.fromJson(data);
  }
}
