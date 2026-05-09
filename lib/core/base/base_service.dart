import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// Exceções customizadas
// ---------------------------------------------------------------------------

class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, {required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException()
      : super('Não autorizado. Faça login novamente.', statusCode: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException()
      : super('Acesso negado.', statusCode: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException()
      : super('Recurso não encontrado.', statusCode: 404);
}

class ServerException extends ApiException {
  const ServerException(super.message, {required super.statusCode});
}

class NoInternetException extends ApiException {
  const NoInternetException()
      : super('Sem conexão com a internet.', statusCode: 0);
}

// ---------------------------------------------------------------------------
// BaseService — extenda e use getResponse para tratar o http.Response
// ---------------------------------------------------------------------------

abstract class BaseService {

  /// Recebe o http.Response do ApiService e retorna o Map já parseado.
  /// Lança uma [ApiException] em caso de erro (4xx / 5xx / sem internet).
  Map<String, dynamic> getResponse(http.Response response) {
    final statusCode = response.statusCode;

    // ── 2xx ────────────────────────────────────────────────────────────────
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return {};

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) return decoded;

      // Listas são embrulhadas em { "data": [...] }
      if (decoded is List) return {'data': decoded};

      return {};
    }

    // ── 4xx / 5xx — extrai mensagem e lança exceção ────────────────────────
    Map<String, dynamic>? json;
    if (response.body.isNotEmpty) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) json = decoded;
      } catch (_) {}
    }

    final message = _extractError(json) ?? _defaultMessage(statusCode);

    switch (statusCode) {
      case 401:
        throw const UnauthorizedException();
      case 403:
        throw const ForbiddenException();
      case 404:
        throw const NotFoundException();
      case >= 500:
        throw ServerException(message, statusCode: statusCode);
      default:
        throw ApiException(message, statusCode: statusCode);
    }
  }

  // -------------------------------------------------------------------------
  // Helpers privados
  // -------------------------------------------------------------------------

  String? _extractError(Map<String, dynamic>? json) {
    if (json == null) return null;
    // Adapte as chaves conforme sua API retorna o erro
    return (json['message'] ?? json['error'] ?? json['msg'])?.toString();
  }

  String _defaultMessage(int statusCode) => switch (statusCode) {
        400 => 'Requisição inválida.',
        409 => 'Conflito ao processar a requisição.',
        422 => 'Dados inválidos.',
        429 => 'Muitas requisições. Tente novamente mais tarde.',
        502 => 'Gateway inválido.',
        503 => 'Serviço indisponível.',
        _   => 'Erro inesperado ($statusCode).',
      };
}

// ---------------------------------------------------------------------------
// EXEMPLO — UserService
// ---------------------------------------------------------------------------

/*
class UserService extends BaseService {
  final _api = ApiService();

  Future<List<Usuario>> getUsuarios() async {
    final json = getResponse(await _api.get('/api/usuarios'));
    return (json['data'] as List).map((e) => Usuario.fromJson(e)).toList();
  }

  Future<Usuario> getUsuario(int id) async {
    final json = getResponse(await _api.get('/api/usuarios/$id'));
    return Usuario.fromJson(json);
  }

  Future<Usuario> createUsuario(Map<String, dynamic> body) async {
    final json = getResponse(await _api.post('/api/usuarios', body: body));
    return Usuario.fromJson(json);
  }
}
*/