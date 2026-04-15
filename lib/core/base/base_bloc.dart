import 'package:app_pedidos/core/base/app_exception.dart';
import 'package:app_pedidos/core/bloc/app/app_data.dart';
import 'package:app_pedidos/locator.dart';
import 'package:flutter/material.dart';

class BaseBloc with ChangeNotifier {
  dynamic state;
  var appData = locator.get<AppData>();
  var isLoading = false;

  BaseBloc({this.isLoading = false, this.state});

  setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> execute(Function() asyncFunction) async {
    try {
      setLoading(true);
      await asyncFunction.call();
      setLoading(false);
    } catch (error) {
      onError(error);
    } finally {
      setLoading(false);
    }
  }

  onError(error) {
    String message =
        'Ocorreu um erro inesperado, tente fechar o seu aplicativo';
    if (error is List<dynamic> && error.isNotEmpty) {
      message = error[0].message;
    } else if (error is AppException) {
      message = error.message;
    }

    print(error);
    print(message);
  }
}
