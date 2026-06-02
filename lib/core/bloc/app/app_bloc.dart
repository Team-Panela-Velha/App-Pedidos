import 'dart:async';

import 'package:app_pedidos/core/base/base_bloc.dart';
import 'package:app_pedidos/router.dart';
import 'package:go_router/go_router.dart';

class AppBloc extends BaseBloc {
  late GoRouter router; 

  void startSession(int tabId, String tableCode) {
    appData.tabId = tabId;
    appData.tableCode = tableCode;
    notifyListeners();
  }

  void endSession() {
    appData.tabId = null;
    appData.tableCode = null;
    notifyListeners();
  }

  Future<void> initialize() async {
    await execute(() async {
      await Future.delayed(const Duration(seconds: 3));

      router.go(Routes.startSession);
      // final token = await authService.checkLocalToken();
      // appData.info = await PackageInfo.fromPlatform();

      // if (token != null) {
      //   var login = LoginResponse.fromJson(jsonDecode(token));
      //   onLogin(login);
      // } else {
      //   navigator.go(Routes.login);
      // }
    });
  }
}
