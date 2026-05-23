import 'package:app_pedidos/core/bloc/app/app_data.dart';
import 'package:app_pedidos/core/service/api_service.dart';
import 'package:app_pedidos/core/service/product/product_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppData());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => ProductService());
}