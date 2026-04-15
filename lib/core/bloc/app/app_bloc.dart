import 'dart:async';

import 'package:app_pedidos/core/base/base_bloc.dart';
import 'package:app_pedidos/router.dart';
import 'package:go_router/go_router.dart';

class AppBloc extends BaseBloc {
  late GoRouter router; 

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
