class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://proconnect-backend-2-6sn4.onrender.com/api',
  );
}
