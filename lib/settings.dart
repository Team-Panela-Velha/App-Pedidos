class Settings {
  // No Docker o endereco vem do build: --dart-define=API_URL=...
  static String baseUrl = const String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080');
}
