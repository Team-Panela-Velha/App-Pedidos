import 'dart:async';
import 'dart:convert';

import 'package:app_pedidos/core/base/base_service.dart';
import 'package:app_pedidos/settings.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String baseUrl = Settings.baseUrl;
  static const _timeout = Duration(seconds: 15);

  Future<http.Response> get(String endpoint) =>
      _send(() => http.get(_url(endpoint), headers: _headers()));

  Future<http.Response> post(String endpoint, {dynamic body}) => _send(
    () =>
        http.post(_url(endpoint), headers: _headers(), body: jsonEncode(body)),
  );

  Future<http.Response> put(String endpoint, {dynamic body}) => _send(
    () => http.put(_url(endpoint), headers: _headers(), body: jsonEncode(body)),
  );

  Future<http.Response> patch(String endpoint, {dynamic body}) => _send(
    () =>
        http.patch(_url(endpoint), headers: _headers(), body: jsonEncode(body)),
  );

  Future<http.Response> delete(String endpoint) =>
      _send(() => http.delete(_url(endpoint), headers: _headers()));

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException {
      throw const ApiException(
        'A conexão demorou demais. Tente novamente.',
        statusCode: 0,
      );
    } on http.ClientException {
      throw const NoInternetException();
    }
  }

  Uri _url(String endpoint) => Uri.parse('$baseUrl$endpoint');

  Map<String, String> _headers() => {'Content-Type': 'application/json'};
}
