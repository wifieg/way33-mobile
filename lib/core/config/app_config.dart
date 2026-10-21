class AppConfig {
  // Build-time values. Never embed secrets in the mobile client.
  static const apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static const demoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: true);
}
