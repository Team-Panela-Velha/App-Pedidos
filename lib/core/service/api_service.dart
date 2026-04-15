import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  String baseUrl = "";
  String token = "";

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    return await http.get(url, headers: _headers());
  }

  Future<http.Response> post(String endpoint, {dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    return await http.post(url, headers: _headers(), body: jsonEncode(body));
  }

  Future<http.Response> put(String endpoint, {dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    return await http.put(url, headers: _headers(), body: jsonEncode(body));
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    return await http.delete(url, headers: _headers());
  }

  Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      // "Authorization": "Bearer token" (quando precisar)
    };
  }
}
